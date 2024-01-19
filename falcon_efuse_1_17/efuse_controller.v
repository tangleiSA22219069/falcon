`timescale 1us / 1us
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Chu er meng 
// 
// Create Date: 2021/12/02 19:19:27
// Design Name: 
// Module Name: efuse_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.02 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////
module efuse_controller #(parameter M=32) (

    //controller from main state machine 
    
    input rst_n ,
    input clk_div2,
    input wr    ,
    input rd    ,
    input ack   ,
    input [M-1:0] data_in       ,
    output  reg [M-1:0] data_out,

    // controller to  efuse
    input  q,
    output reg pgenb,
    output reg nr,
    output reg strobe,
    output reg [M-1:0] we,
    //output wire vdd5v,
    
    // controller to  main state machine
    output reg rd_done,
    output reg wr_done
    );



    reg [M-1:0] temp            ;
    reg [M-1:0] we_d0           ;
    reg [M-1:0] data_out_temp   ;
    reg [1:0] state_c           ;
    reg [1:0] state_n           ;
    reg [4:0] cnt_t_pgm         ;  
    reg [4:0] cnt_pgm           ;
    reg [4:0] cnt_read          ;

    reg strobe_d0   ;
    wire we_rise    ;
    wire strobe_fall;

   //FSM states 
    localparam WAIT = 2'b00 ;
    localparam READ = 2'b01 ;
    localparam PGM  = 2'b10 ;

    always @(posedge clk_div2 or negedge rst_n) begin
        if(!rst_n)
            state_c <= WAIT   ;
        else
            state_c <= state_n;
    end

    always @(*) begin
        case(state_c)
            WAIT:begin
                if(rd)
                    state_n = READ;
                else if(wr)
                    state_n = PGM;
                else
                    state_n = state_c;
            end
            READ:begin
                if(rd_done)
                    state_n = WAIT;
                else
                    state_n = state_c;
            end
            PGM:begin
                if(wr_done)
                    state_n = WAIT;
                else 
                    state_n = state_c;
            end
            default:state_n = WAIT;
        endcase
    end

    always @(*) begin
        case(state_c)
            WAIT:begin
                pgenb = 1'b1;
                nr    = 1'b0;
            end
            READ:begin
                pgenb = 1'b1;
                nr    = 1'b1;
            end
            PGM:begin
                pgenb = 1'b0;
                nr    = 1'b0;
            end
            default:begin
                pgenb = 1'b1;               
                nr    = 1'b0;           
            end
        endcase
    end

    always @(posedge clk_div2 or negedge rst_n) begin
        if(!rst_n)
            strobe <= 1'b0;
        else if(state_c==READ)begin
            if(cnt_t_pgm=='d0&&we!='d0)
                strobe <= 1'b1;
            else if(cnt_t_pgm=='d1)
                strobe <= 1'b1;
            else 
                strobe <= 1'b0; 
        end
        else if(state_c==PGM)begin
            if(we_rise)
                strobe <= 1'b1;
            else if(cnt_t_pgm =='d19)
                strobe <= 1'b0;            
        end
        else
            strobe <= 1'b0;
    end

    always @(posedge clk_div2 or negedge rst_n) begin
        if(!rst_n)begin
            data_out <= 'd0;
        end
        else if((cnt_read == 'd31)&&(strobe_fall))
            data_out <= data_out_temp;
        else 
            data_out <= data_out;
    end

    always @(posedge clk_div2 or negedge rst_n) begin
        if(!rst_n)begin
            strobe_d0 <= 1'b0;
        end
        else begin
            strobe_d0 <= strobe;
        end

    end

    always @(posedge clk_div2 or negedge rst_n) begin
        if(!rst_n)begin
            we_d0 <= 'd0;
        end
        else
            we_d0 <= we;
       
    end

    assign we_rise = (we!='d0&&we_d0 =='d0);
    assign strobe_fall = (!strobe && strobe_d0);

    /****************cnt_read_sign******************/
    // always @(posedge clk_div2 or negedge rst_n) begin
    //     if(!rst_n) begin
    //         cnt_read_sign <= 'd0;
    //     end
    //     else if(state_c==READ)begin
    //         if(cnt_read_sign == 'd4)
    //             cnt_read_sign <= 'd0;
    //         else
    //             cnt_read_sign <= cnt_read_sign + 'd1;
    //     end

    //     else 
    //         cnt_read_sign <= 'd0;
    // end

    /*****************cnt_pgm*****************/
    always @(posedge clk_div2 or negedge rst_n) begin
        if(!rst_n)begin
            cnt_pgm <=0;
        end
        else if(state_c == PGM) begin
            if(cnt_pgm == 5'd31) begin
                if(strobe_fall)
                    cnt_pgm <=0;
                else if(data_in[cnt_pgm]==0)
                    cnt_pgm <=0;
            end 
            else if(state_n == WAIT)
                cnt_pgm <=0;
            else if(data_in[cnt_pgm]==0)
                cnt_pgm <= cnt_pgm +1;
            else if(strobe_fall)
                cnt_pgm <= cnt_pgm +1;
            else 
                cnt_pgm <= cnt_pgm;
        end
    end


    wire sign_cnt_t_pgm;
    assign sign_cnt_t_pgm = (cnt_t_pgm==5'd4)?1'b1:1'b0;
    /**********T_PGM*********/
    always @(posedge clk_div2 or negedge rst_n) begin
        if(!rst_n)
            cnt_t_pgm <=0;
        else if(state_c == PGM&&we!='d0)
            if(cnt_t_pgm=='d19)
                cnt_t_pgm <= 'd0;
            else if(strobe)
                cnt_t_pgm <= cnt_t_pgm+1;
            else
                cnt_t_pgm<=0;
        else if(state_c == READ)begin
            if(sign_cnt_t_pgm)
                cnt_t_pgm <= 'd0;
            else
                cnt_t_pgm <= cnt_t_pgm + 'd1;
        end
        else 
            cnt_t_pgm <= 'd0;
    end

    /*****************wr_done*****************/
    always @(posedge clk_div2 or negedge rst_n) begin
        if(!rst_n)begin
            wr_done <= 0;
        end
        else if(cnt_pgm == 5'd31)begin
            if(strobe_fall)
                wr_done <= 1'b1;
            else if(data_in[cnt_pgm]==1'b0)
                wr_done <= 1'b1; 
            else
                wr_done <= 0 ;
        end        
        else if(ack)begin
            wr_done <= 0;
        end
        else 
            wr_done <= 0;
    end
    
    /*****************rd_done*****************/
      always @(posedge clk_div2 or negedge rst_n) begin
        if(!rst_n)
            rd_done <= 0;
        else if(state_c == READ)begin
            if(cnt_read == 5'd31&&strobe_fall)
                rd_done <= 1'b1; 
            else 
                rd_done <= 1'b0;
        end
        else if(ack)begin
             rd_done <= 0;
        end
    end
    

    /*************data_out_temp**************/

    always @(posedge clk_div2 or negedge rst_n) begin
        if(!rst_n)
            data_out_temp<= 'd0;
        else if(state_c == WAIT)
            data_out_temp<= 'd0;
        else if(state_c==READ&&cnt_t_pgm=='d2)
            data_out_temp[cnt_read] <= q;
        else
            data_out_temp <= data_out_temp;
    end

    always @(posedge clk_div2 or negedge rst_n) begin
        if(!rst_n)begin
            cnt_read <= 0;
        end
        else if(state_c==READ)begin
            if((cnt_read == 5'd31)&&(strobe_fall))
                cnt_read <= 'd0;
            else if(cnt_t_pgm=='d3)
                cnt_read <= cnt_read +1;
            else 
                cnt_read <= cnt_read;
        end
    end

    always @(posedge clk_div2 or negedge rst_n) begin
        if(!rst_n)
            we <= 'd0;
        else if(state_n == READ && we == 'd0)   
            we <= temp;        
        else if(state_c == READ)begin
            if(cnt_t_pgm=='d3)
                we <= 'd0;
            else if(cnt_t_pgm == 'd4)
                we <= temp;
            else 
                we <= we;
        end
        else if(state_c==PGM)begin
            if(strobe_fall)
                we <= 'd0;
            else
                we <= temp & data_in; 
        end
    end

    //temp shift operation  
    always @(posedge clk_div2 or negedge rst_n) begin
        if(!rst_n)
            temp <= 'd1;
        else if( state_c==READ&&cnt_t_pgm=='d3)
            temp <= temp<<1;                    
        else if(cnt_t_pgm=='d19) 
            temp <= temp<<1;
        else if(state_c == PGM && !data_in[cnt_pgm])
            temp <= temp<<1;
        else if(state_c == WAIT)
            temp <= 'd1;
        else
            temp <= temp;
    end


    
endmodule
