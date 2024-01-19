`timescale 1ns/1ps

module i2c  (
    input clk                   ,      //high freq sample clock, 2MHz and above
    input reset_n               ,
    
    input  [31:0] efuse_out     ,
    output [31:0] efuse_in      ,
    output efuse_bypass         ,
    output efuse_write          ,
    
    //read only regs
    input [7:0] RO_ONE         ,
    input [7:0] RO_TWO         ,
//    input [7:0] RO_THREE       ,
//    input [7:0] RO_FOUR        ,
     
    output [7:0] CTRL_ONE       ,
    output [7:0] CTRL_TWO       ,
    output [7:0] CTRL_THREE     ,
//    output [7:0] CTRL_FOUR      ,
//    output [7:0] CTRL_FIVE      ,
//    output [7:0] CTRL_SIX       ,
//    output [7:0] CTRL_SEVEN     ,
//    output [7:0] CTRL_EIGHT     ,
//    output [7:0] CTRL_NINE      ,
//    output [7:0] CTRL_TEN       ,
//    output [7:0] CTRL_ELEVEN    ,
//    output [7:0] CTRL_TWELVE    ,
//    output [7:0] CTRL_THIRTEEN  ,
//    output [7:0] CTRL_FOURTEEN  ,
//    output [7:0] CTRL_FIFTEEN   ,
//    output [7:0] CTRL_SIXTEEN   ,
    
    // ========= I/O for Host==========================
    input scl                   ,
    input sda                   ,
    output reg sda_out          ,
    output reg sda_out_en
    );
    parameter I2C_IDLE = 0      ;
    parameter I2C_WORK = 1      ;
    parameter MAX_REGS = 14     ;
    parameter  [6:0] i2c_slave_addr = 7'b1010101;// to set i2c slave address
    
    //set initial value of regs
    parameter  [7:0] in_reg6    = 8'b0 ;
    parameter  [7:0] in_reg7    = 8'b0 ;
    parameter  [7:0] in_reg8    = 8'b0 ;
    parameter  [7:0] in_reg9    = 8'hff ;
//    parameter  [7:0] in_reg10   = 8'hff ;
    //read only regs for efuse_out
    parameter  [7:0] in_reg10   = 8'b0 ;
    parameter  [7:0] in_reg11   = 8'b0 ;
    parameter  [7:0] in_reg12   = 8'b0 ;
    parameter  [7:0] in_reg13   = 8'b0 ;
//    parameter  [7:0] in_reg17   = 8'h55;
//    parameter  [7:0] in_reg18   = 8'h55;
//    parameter  [7:0] in_reg19   = 8'h55;
//    parameter  [7:0] in_reg20   = 8'h55;
//    parameter  [7:0] in_reg21   = 8'hAA;
//    parameter  [7:0] in_reg22   = 8'hAA;
//    parameter  [7:0] in_reg23   = 8'hAA;
//    parameter  [7:0] in_reg24   = 8'hAA;
//    parameter  [7:0] in_reg25   = 8'hFF;
//    parameter  [7:0] in_reg26   = 8'hFF;
//    parameter  [7:0] in_reg27   = 8'hFF;
//    parameter  [7:0] in_reg28   = 8'hFF;
    
    wire  [7:0] EFUSE_IN_ONE  ;
    wire  [7:0] EFUSE_IN_TWO  ;
    wire  [7:0] EFUSE_IN_THREE;
    wire  [7:0] EFUSE_IN_FOUR ;
    wire  [7:0] EFUSE_CTRL    ;
    
    wire [7:0] read_data            ;       //i2c read translation
    
    reg [7:0] myregs[0:MAX_REGS-1]  ;//registers
    reg [7:0] addr                  ;                //register address

    reg [4:0] i                     ;
    reg [7:0] j                     ;
    reg [7:0] slave_addr            ;
    reg [7:0] data                  ;
    reg state                       ;
    reg n_state                     ;
    
    //signal conditioning, the clean signal would be sdain and sclin
    reg i2c_start       ;
    reg i2c_stop        ;
    reg scl_rise        ;
    reg scl_fall        ;
    reg i2c_set         ;
    reg i2c_get         ;
    reg slave_addr_match;
    reg scl_in, sda_in  ;
    reg scl_old, sda_old;
    wire time_out       ;
    
    assign EFUSE_IN_ONE     = myregs[2] ;
    assign EFUSE_IN_TWO     = myregs[3] ;
    assign EFUSE_IN_THREE   = myregs[4];
    assign EFUSE_IN_FOUR    = myregs[5];
    assign EFUSE_CTRL       = myregs[6];
    assign CTRL_ONE         = myregs[7];
    assign CTRL_TWO         = myregs[8];
    assign CTRL_THREE       = myregs[9];
//    assign CTRL_FOUR        = myregs[10];
//    assign CTRL_FIVE        = myregs[17];
//    assign CTRL_SIX         = myregs[18];
//    assign CTRL_SEVEN       = myregs[19];
//    assign CTRL_EIGHT       = myregs[20];
//    assign CTRL_NINE        = myregs[21];
//    assign CTRL_TEN         = myregs[22];
//    assign CTRL_ELEVEN      = myregs[23];
//    assign CTRL_TWELVE      = myregs[24];
//    assign CTRL_THIRTEEN    = myregs[25];
//    assign CTRL_FOURTEEN    = myregs[26];
//    assign CTRL_FIFTEEN     = myregs[27];
//    assign CTRL_SIXTEEN     = myregs[28];
    
    assign read_data = myregs[addr[7:0]];
    assign time_out = (j >= 8'd250) ? 1'b1 : 1'b0;    //No response for a long time
    assign efuse_in = {EFUSE_IN_FOUR,EFUSE_IN_THREE,EFUSE_IN_TWO,EFUSE_IN_ONE};
    assign efuse_write  = EFUSE_CTRL[0];
    assign efuse_bypass = EFUSE_CTRL[1];
    
    /*************************FSM*************************/
    always @(posedge clk or negedge reset_n)begin
        if(!reset_n) begin
            state <= I2C_IDLE;
        end
        else begin
            state <= n_state;
        end
    end
    
    always @(*) begin
        n_state = state;
        case(state)
            I2C_IDLE:begin
                if(i2c_start == 1'b1)
                    n_state = I2C_WORK;
                else
                    n_state = state;
            end
            I2C_WORK:begin
                if(i2c_stop == 1'b1)
                    n_state = I2C_IDLE;
                else if ((scl_fall == 1'b1)&&(i==5'd17 && slave_addr_match && i2c_get))
                    n_state = I2C_IDLE;
                else if ((scl_fall == 1'b1)&&(i==5'd27 && slave_addr_match && i2c_get))
                    n_state = I2C_IDLE;
                else
                    n_state = state ;
            end        
            default: n_state = I2C_IDLE;
        endcase
    end
    
    always @(posedge clk or negedge reset_n) begin
        if (!reset_n) begin
                myregs[0]  <= 8'd0     ;
                myregs[1]  <= 8'd0     ;
                myregs[2]  <= 8'd0     ;
                myregs[3]  <= 8'd0     ;
                myregs[4]  <= 8'd0     ;
                myregs[5]  <= 8'd0     ;
                myregs[6]  <= in_reg6  ;
                myregs[7]  <= in_reg7  ;
                myregs[8]  <= in_reg8  ;
                myregs[9]  <= in_reg9  ;
                myregs[10] <= in_reg10 ;
                myregs[11] <= in_reg11 ;
                myregs[12] <= in_reg12 ;
                myregs[13] <= in_reg13 ;
//                myregs[14] <= in_reg14 ; 
//                myregs[15] <= in_reg15 ;
//                myregs[16] <= in_reg16 ;
//                myregs[17] <= in_reg17 ;
//                myregs[18] <= in_reg18 ;
//                myregs[19] <= in_reg19 ;
//                myregs[20] <= in_reg20 ;
//                myregs[21] <= in_reg21 ; 
//                myregs[22] <= in_reg22 ;
//                myregs[23] <= in_reg23 ; 
//                myregs[24] <= in_reg24 ;           
//                myregs[25] <= in_reg25 ; 
//                myregs[26] <= in_reg26 ;
//                myregs[27] <= in_reg27 ; 
//                myregs[28] <= in_reg28 ;     
        end
        else begin
            myregs[0] <= RO_ONE             ;
            myregs[1] <= RO_TWO             ;            
            myregs[11] <= efuse_out[7:0]     ;
            myregs[12] <= efuse_out[15:8]    ;            
            myregs[13] <= efuse_out[23:16]   ;
            myregs[14] <= efuse_out[31:24]   ;
//            myregs[6] <= RO_THREE           ;
//            myregs[7] <= RO_FOUR            ;
            
            //I2C write, only write to non read only ones
           if((state==I2C_WORK)&&(scl_fall == 1'b1)&&(i==5'd26) && (i2c_set))begin        
                case(addr) 
                    8'd2 :  myregs[2]  <= data;
                    8'd3 :  myregs[3]  <= data;
                    8'd4 :  myregs[4]  <= data;
                    8'd5 :  myregs[5]  <= data;
                    8'd6 :  myregs[6]  <= data;
                    8'd7 :  myregs[7]  <= data;
                    8'd8 :  myregs[8]  <= data;
                    8'd9 :  myregs[9]  <= data;
//                    8'd10:  myregs[10] <= data;				    
//                    8'd13:  myregs[13] <= data;
//                    8'd14:  myregs[14] <= data;
//                    8'd15:  myregs[15] <= data;
//                    8'd16:  myregs[16] <= data;
//                    8'd17:  myregs[17] <= data;
//                    8'd18:  myregs[18] <= data;
//                    8'd19:  myregs[19] <= data;
//                    8'd20:  myregs[20] <= data;
//                    8'd21:  myregs[21] <= data;
//                    8'd22:  myregs[22] <= data;
//                    8'd23:  myregs[23] <= data;
//                    8'd24:  myregs[24] <= data;
//                    8'd25:  myregs[25] <= data;
//                    8'd26:  myregs[26] <= data;
//                    8'd27:  myregs[27] <= data;
//                    8'd28:  myregs[28] <= data;		        
                endcase				    
           end        
        end  
    end

    always @(posedge clk or negedge reset_n)begin
        if (reset_n == 1'b0) begin
            scl_in <= 1'b0; 
            sda_in <= 1'b0;
        end
        else begin
            scl_in <= scl;
            sda_in <= sda;
        end
    end
    
    always @(posedge clk or negedge reset_n)begin
        if (reset_n == 1'b0) begin
            scl_old <= 1'b0; 
            sda_old <= 1'b0;
        end
        else begin
            scl_old <= scl_in; 
            sda_old <= sda_in;
        end
    end
    
    // conditions
    always @(*) begin
        if(scl_old==1'b1 && scl_in ==1'b1 && sda_old ==1'b1 && sda_in == 1'b0) 
            i2c_start = 1'b1; 
        else 
            i2c_start = 1'b0;
        if(scl_old==1'b1 && scl_in ==1'b1 && sda_old ==1'b0 && sda_in == 1'b1) 
            i2c_stop = 1'b1; 
        else 
            i2c_stop = 1'b0;
        if(scl_old == 1'b0 && scl_in == 1'b1) 
            scl_rise = 1'b1; 
        else 
            scl_rise = 1'b0;
        if(scl_old == 1'b1 && scl_in == 1'b0) 
            scl_fall = 1'b1; 
        else 
            scl_fall = 1'b0;
    end
      
    //conditions
    always @(*) begin
        if (slave_addr[7:1] == i2c_slave_addr) 
            slave_addr_match = 1'b1; 
        else 
            slave_addr_match = 1'b0;
        if (slave_addr_match && slave_addr[0] == 1'b1) //read
            i2c_get = 1'b1; 
        else 
            i2c_get = 1'b0;
        if (slave_addr_match && slave_addr[0] == 1'b0) //write
            i2c_set = 1'b1; 
        else 
            i2c_set = 1'b0;
    end
    
    
    //  bit counts  
    //  SCL 0-7: slave_addr
    //  SCL 8: ACK
    //  SCL 9,10,11,12,13,14,15,16: I2C addr
    //  SCL 17: ACK
    //  SCL 18,19,20,21,22,23,24,25: I2C data
    //  SCL 26: ACK    end session:
    always @(posedge clk or negedge reset_n)begin
        if(!reset_n)begin
            i <= 5'd0;
        end
        else begin
            if(state==I2C_WORK)begin
                if (i2c_stop == 1'b1)
                    i <= 5'd0;
                else if(i2c_start == 1'b1)
                    i <= 5'd0;
                else if (scl_rise == 1'b1)begin
                    if ( i<5'd30 )
                        i <= i + 5'd1;
                end
                else if ((scl_fall == 1'b1)&&(i==5'd17 && slave_addr_match && i2c_get)) 
                    i <= 5'd0;
                else if ((scl_fall == 1'b1)&&(i==5'd27 && slave_addr_match && i2c_get)) // 
                    i <= 5'd0;
            end
            else if(state==I2C_IDLE)begin
                i <= 5'd0;
                if (i2c_start == 1'b1)
                    i <= 5'd0;
            end
        end
    end
    
    //timer
    always @(posedge clk or negedge reset_n)begin
        if(!reset_n) begin
            j <= 8'd0;
        end
        else begin
            if( state==I2C_IDLE)
                j <= 8'd0;
            else if( state==I2C_WORK)begin
                if (i2c_start == 1'b1)
                    j <= 8'd0;
                else if (scl_fall == 1'b1)
                    j <= 8'd0;
                else
                    j <= j+8'd1;
            end
        end
    end
    
    //sda_out
    always @(posedge clk or negedge reset_n) begin
        if(!reset_n)begin
            sda_out <= 1'b0;
        end
        else begin
            if(state==I2C_IDLE)
                sda_out <= 1'b1;
            else if( state==I2C_WORK)begin
                if (i2c_stop == 1'b1)
                    sda_out <= 1'b1;
                else if (i2c_start == 1'b1)
                    sda_out <= 1'b1;
                else if (scl_fall == 1'b1)begin
                    if (i==5'd8 && slave_addr_match)
                        sda_out <= 1'b0;
                    else if (i==5'd17 && slave_addr_match && i2c_set)
                        sda_out <= 1'b0;
                    else if (i==5'd26 && slave_addr_match && i2c_set)
                        sda_out <= 1'b0;
                    else if (i==5'd9 && i2c_get)
                        sda_out    <= read_data[7];
                    else if (i==5'd10 && i2c_get)
                        sda_out    <= read_data[6];
                    else if (i==5'd11 && i2c_get)
                        sda_out    <= read_data[5];
                    else if (i==5'd12 && i2c_get)
                        sda_out    <= read_data[4];
                    else if (i==5'd13 && i2c_get)
                        sda_out    <= read_data[3];
                    else if (i==5'd14 && i2c_get)
                        sda_out    <= read_data[2];
                    else if (i==5'd15 && i2c_get)
                        sda_out    <= read_data[1];
                    else if (i==5'd16 && i2c_get)
                        sda_out    <= read_data[0];
                    else if (i==5'd17 && slave_addr_match && i2c_get)
                        sda_out <= 1'b1;
                    else if (i==5'd27 && slave_addr_match && i2c_set)
                        sda_out <= 1'b1;
                end              
            end      
        end
    end
    
    //receive reg data   
    always @(posedge clk or negedge reset_n) begin
        if(!reset_n)begin
            data <= 8'd0;    
        end
        else begin
            if(state==I2C_WORK)begin
                if ((scl_rise == 1'b1)&&(i>5'd17) && (i<5'd26)&&(i2c_get==0) )
                    data <= {data[6:0], sda_in};   
            end
        end
    end
    
    //receive reg addr 
    always @(posedge clk or negedge reset_n) begin
        if(!reset_n)begin
            addr <= 8'd0;    
        end
        else begin
            if(state==I2C_WORK)begin
                if ((scl_rise == 1'b1)&&(i>5'd8) && (i<5'd17)&&(i2c_get==0) )
                    addr <= {addr[6:0], sda_in};   
            end    
        end
    end
    
    //receive device addr 
    always @(posedge clk or negedge reset_n) begin
        if(!reset_n)begin
            slave_addr <= 8'd0;  
        end
        else begin
            if(state==I2C_WORK)begin
                if (i2c_stop == 1'b1) 
                    slave_addr <= 8'd0;
                else if (i2c_start == 1'b1)
                    slave_addr <= 8'd0;
                else if (scl_rise == 1'b1)begin
                    if(i<5'd8)begin
                        slave_addr <= {slave_addr[6:0], sda_in};
                    end
                end
                else if (scl_fall == 1'b1)begin
                    if (i==5'd17 && slave_addr_match && i2c_get)
                        slave_addr <= 8'd0;
                    else if (i==5'd27 && slave_addr_match && i2c_set)
                        slave_addr <= 8'd0;        
                end  
            end
        end
    end
    
    always @(posedge clk or negedge reset_n) begin
        if(!reset_n)begin
            sda_out_en <= 1'b0;
        end
        else begin
            if( state==I2C_WORK)begin           
                if (i2c_stop == 1'b1)
                    sda_out_en <= 1'b0;
                else if (i2c_start == 1'b1)
                    sda_out_en <= 1'b0;
                else if (scl_fall == 1'b1)begin
                    if (i==5'd8 && slave_addr_match)
                        sda_out_en <= 1'b1;
                    else if (i==5'd17 && slave_addr_match && i2c_set)
                        sda_out_en <= 1'b1;
                    else if (i==5'd26 && slave_addr_match && i2c_set)
                        sda_out_en <= 1'b1;
                    else if (i==5'd9 && i2c_get)
                        sda_out_en <= 1'b1;
                    else if (i==5'd10 && i2c_get)
                        sda_out_en <= 1'b1;
                    else if (i==5'd11 && i2c_get)
                        sda_out_en <= 1'b1;
                    else if (i==5'd12 && i2c_get)
                        sda_out_en <= 1'b1;
                    else if (i==5'd13 && i2c_get)
                        sda_out_en <= 1'b1;
                    else if (i==5'd14 && i2c_get)
                        sda_out_en <= 1'b1;
                    else if (i==5'd15 && i2c_get)
                        sda_out_en <= 1'b1;
                    else if (i==5'd16 && i2c_get)
                        sda_out_en <= 1'b1;
                    else if (i==5'd17 && slave_addr_match && i2c_get)
                        sda_out_en <= 1'b0;
                    else if (i==5'd27 && slave_addr_match && i2c_set)
                        sda_out_en <= 1'b0;
                    else 
                        sda_out_en <= 1'b0;
                end
                else if (sda_out_en && time_out)  
                    sda_out_en <= 1'b0;     
            end
        end
    end

endmodule
