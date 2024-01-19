`timescale 1ns/1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/12/22 20:26
// Design Name: 
// Module Name: eprom_controller
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision:0.1
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

module eprom_controller #(parameter M=32) (
     // controller from main state machine 
	 
	 input rst_n,
	 input clk_div,
	 input wr,
	 input rd,
	 input ack,
	 input [M-1:0] data_in,
	 input margin_read_en,
	 output reg [M-1:0] data_out,
	 
	 //controller to eprom_controller
	 input [7:0] dq,
	 output reg xce,
	 output reg xread,
	 output reg xpgm,
	 output reg xtm,
	 output reg [1:0] xa,
	 output reg [7:0] xdin,
	 
	 // controller to main state machine
	 output reg rd_done,
	 output reg wr_done,
	 output reg vpp_en
	 
	 );
	 
	reg [12:0] cnt_read_pgm ;
	reg [1:0] state_c ;
	reg [1:0] state_n ;
	
	localparam STAND_BY = 2'b00 ;
    localparam READ = 2'b01 ;
    localparam PGM  = 2'b10 ;

    always @(posedge clk_div or negedge rst_n) begin
        if(!rst_n)
            state_c <= STAND_BY ;
        else
            state_c <= state_n ;
    end

    always @(*) begin
        case(state_c)
            STAND_BY:begin
                if(rd)
                    state_n = READ;
                else if(wr)
                    state_n = PGM;
                else
                    state_n = state_c;
            end
            READ:begin
                if(rd_done)
                    state_n = STAND_BY;
                else
                    state_n = state_c;
            end
            PGM:begin
                if(wr_done)
                    state_n = STAND_BY;
                else 
                    state_n = state_c;
            end
            default:state_n = STAND_BY;
        endcase
    end
	
	
	
	 /********************************cnt_read_pgm***********************/
	always@(posedge clk_div or negedge rst_n) begin
	    if(!rst_n) begin 
		    cnt_read_pgm <= 13'd0 ;
		end 
		else if (state_c == READ) begin 
		     if (cnt_read_pgm == 13'd20) begin 
			     cnt_read_pgm <= 13'd0 ;
			end 
			else begin 
			    cnt_read_pgm <= cnt_read_pgm + 1'b1 ;
			end 
		end 
		else if (state_c == PGM) begin 
		    if (cnt_read_pgm == 13'd4607) begin 
			    cnt_read_pgm <= 13'd0 ;
			end 
			else begin 
			    cnt_read_pgm <= cnt_read_pgm + 1'b1 ;
			end 
		end 
		else begin
		    cnt_read_pgm <= cnt_read_pgm ;
		end 
	end 
	
	
	
	/********************************rd_done*******************************/
	always@(posedge clk_div or negedge rst_n) begin 
	    if(!rst_n) begin 
		    rd_done <= 1'b0 ;
		end 
		else if(state_c == READ && cnt_read_pgm == 13'd19) begin
		    rd_done <= 1'b1 ;
	    end 
		else if(ack) begin 
		    rd_done <= 1'b0 ;
		end 
		else begin
		    rd_done <= 1'b0 ;
		end 
	end 
	
	/*********************************wr_done***************************/
	always@(posedge clk_div or negedge rst_n) begin
	    if(!rst_n) begin 
		    wr_done <= 1'b0 ;
		end 
		else if(state_c == PGM && cnt_read_pgm == 13'd4606) begin
		    wr_done <= 1'b1 ;
		end 
		else if(ack) begin 
		    wr_done <= 1'b0 ;
		end 
		else begin 
		    wr_done <= 1'b0 ;
		end 
	end 
	
	/**********************************xa***********************************/
	always@(posedge clk_div or negedge rst_n) begin 
	    if(!rst_n) begin 
		    xa <= 2'b00 ;
		end 
	    else if(state_c == READ) begin 
		    if((cnt_read_pgm == 13'd5) || (cnt_read_pgm == 13'd10) || (cnt_read_pgm == 13'd15)) begin 
			    xa <= xa + 1'b1 ;
			end 
			else if((cnt_read_pgm == 13'd0) || (cnt_read_pgm == 13'd20)) begin
                xa <= 2'b00 ;
			end 
			else begin 
			    xa <= xa ;
			end 
         end 
        else if(state_c == PGM) begin 
             if((cnt_read_pgm == 13'd1201) || (cnt_read_pgm == 13'd2303) || (cnt_read_pgm == 13'd3405)) begin
                 xa <= xa + 1'b1 ;
             end 
             else if ((cnt_read_pgm == 13'd0) || (cnt_read_pgm == 13'd4507)) begin 
                 xa <= 2'b00 ;
             end 
			 else begin
			     xa <= xa ;
			end 
         end 
        else begin 
             xa <= xa ;
        end 
    end 		
			
	/************************************xread********************************/
	always@(posedge clk_div or negedge rst_n) begin 
	    if(!rst_n) begin 
		    xread <= 1'b0 ;
		end 
		else if(state_c == READ) begin 
		    if((cnt_read_pgm == 13'd1) || (cnt_read_pgm == 13'd6) || (cnt_read_pgm == 13'd11) || (cnt_read_pgm == 13'd16)) begin
			    xread <= 1'b1 ;
			end 
			else if ((cnt_read_pgm == 13'd4) || (cnt_read_pgm == 13'd9) || (cnt_read_pgm == 13'd14) || (cnt_read_pgm == 13'd19)) begin 
			    xread <= 1'b0 ;
			end 
			else begin 
			    xread <= xread ;
			end
		end 
		else begin
		    xread <= 1'b0 ;
		end 
	end 
	
	/*********************************xpgm***********************************/
	always@(posedge clk_div or negedge rst_n) begin 
	    if(!rst_n) begin 
		    xpgm <= 1'b0 ;
		end 
		else if (state_c == PGM) begin 
		    if((cnt_read_pgm == 13'd100) || (cnt_read_pgm == 13'd1202) || (cnt_read_pgm == 13'd2304) || (cnt_read_pgm == 13'd3406)) begin
			    xpgm <= 1'b1 ;
			end 
		    else if((cnt_read_pgm == 13'd1200) || (cnt_read_pgm == 13'd2302) || (cnt_read_pgm == 13'd3404) || (cnt_read_pgm == 13'd4506)) begin
			    xpgm <= 1'b0 ;
			end 
			else begin
			    xpgm <= xpgm ;
			end 
		end 
		else begin 
		    xpgm <= 1'b0 ;
		end 
	end 
	
	/******************************************xdin***************************************/
	always@(posedge clk_div or negedge rst_n) begin 
	    if(!rst_n) begin 
		    xdin <= 8'd0 ;
		end 
		else if(state_c == PGM) begin 
		    if(cnt_read_pgm == 13'd99) begin
			    xdin <= ~data_in[7:0] ;
			end 
			else if(cnt_read_pgm == 13'd1201) begin 
			    xdin <= ~data_in[15:8] ;
			end 
			else if(cnt_read_pgm == 13'd2303) begin
			    xdin <= ~data_in[23:16] ;
			end 
			else if(cnt_read_pgm == 13'd3405) begin 
			    xdin <= ~data_in[31:24] ;
			end 
			else  begin 
			    xdin <= xdin ;
		    end 
		end 
		else begin 
		    xdin <= 8'd0 ;
		end 
	end 
	
	/*********************************data_out**********************************************/
	always@(posedge clk_div or negedge rst_n) begin 
	    if(!rst_n) begin 
		    data_out <= 32'd0 ;
		end 
		else if(state_c == READ) begin 
		    if(cnt_read_pgm == 13'd3) begin 
			    data_out[7:0] <= ~dq ;
			end 
			else if(cnt_read_pgm == 13'd8) begin 
			    data_out[15:8] <= ~dq ;
			end 
			else if(cnt_read_pgm == 13'd13) begin 
			    data_out[23:16] <= ~dq ;
			end 
			else if(cnt_read_pgm == 13'd18) begin 
			    data_out[31:24] <= ~dq ;
			end 
			else begin 
			    data_out <= data_out ;
			end 
		end 
		else begin 
		    data_out <= data_out ;
		end 
	end 
	
	/**********************************************vpp_en********************************************/
	always@(posedge clk_div or negedge rst_n) begin 
	    if(!rst_n) begin
		    vpp_en <= 1'b0 ;
		end 
		else if(state_c == PGM) begin 
		    if(cnt_read_pgm == 13'd0) begin
			    vpp_en <= 1'b1 ;
			end 
			else if(cnt_read_pgm == 13'd4510) begin
			    vpp_en <= 1'b0 ;
			end
			else begin 
			    vpp_en <= vpp_en ;
			end 
		end
		else begin
		    vpp_en <= 1'b0 ;
		end
	end 

	/******************************************xtm**************************************************/
	always@(*) begin
	    if(state_c == READ) begin
		    if(margin_read_en == 1'b1) begin
			    xtm = 1'b1 ;
			end
			else begin
			    xtm = 1'b0 ;
			end 
		end 
		else begin
		    xtm = 1'b0 ;
		end
	end 
	
	/**********************************************xce************************************************/
    always@(posedge clk_div or negedge rst_n) begin
	    if (!rst_n) begin 
		    xce <= 1'b0 ;
		end 
	    else if(state_c == PGM) begin
		    if(cnt_read_pgm == 13'd99) begin
			    xce <= 1'b1 ;
			end 
			else if(cnt_read_pgm == 13'd4507) begin 
			    xce <= 1'b0 ;
			end 
			else begin
			    xce <= xce ;
			end 
		end
		else if(state_c == READ) begin
		    if(cnt_read_pgm == 13'd0) begin
			    xce <= 1'b1 ;
			end 
			else if(cnt_read_pgm == 13'd20) begin 
			    xce <= 1'b0 ;
			end 
			else begin
			    xce <= xce ;
			end 
		end 
		else begin
		    xce <= 1'b0 ;
		end 
	end
	
endmodule 	
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 