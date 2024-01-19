`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/03/09 16:38:25
// Design Name: 
// Module Name: main_state_machine
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module main_state_machine(

    input clk           ,
    input rst_n         , 
    input efuse_bypass        ,
	input margin_read_in     ,
	input eprom_multiple_en,
    output reg [31:0] efuse_out,
    //from decoder

    input efuse_write       ,
    input [31:0] efuse_in   ,


    //to efuse_controller
    output reg [31:0] data_write,
    output reg ack              ,
    output reg write            ,
    output reg read             ,
	output reg margin_read_out ,
    
    
    //from efuse_controller
    input wr_done               ,
    input rd_done               ,
    input [31:0] data_read    
    );

    localparam READ = 2'b00;
    localparam WAIT = 2'b01;
    localparam PGM  = 2'b10;
    
    reg [1:0] state_c;
    reg [1:0] state_n;
    reg efuse_write_d0;
    wire efuse_write_up;
    // reg efuse_out_write_en;

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            state_c <= READ;
        else 
            state_c <= state_n;
    end

    always @(*) begin
        case(state_c)
            READ:   if(rd_done)
                        state_n = WAIT;
                    else    
                        state_n = state_c;
            WAIT:   if((efuse_write_up)&&((efuse_out==32'd0) || (eprom_multiple_en)))
                        state_n = PGM;
                    else    
                        state_n = state_c;
            PGM:    if(wr_done)
                        state_n = READ;
                    else    
                        state_n = state_c;
            default:state_n = READ;
        endcase
    end


    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            efuse_write_d0 <= 1'b0;
        else 
            efuse_write_d0 <= efuse_write;
    end


    assign efuse_write_up = (efuse_write)&&(!efuse_write_d0);
    
    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            read <= 1'b0;
        else if(rd_done)
            read <= 1'b0;
        else if(state_c == READ)
            read <= 1'b1;
        else 
            read <= 1'b0;
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            write <= 1'b0;
        else if(state_n == PGM)begin
                write <= 1'b1;
        end
        else if(wr_done)
            write <= 1'b0;
        else 
            write <= 1'b0; 
    end


    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            efuse_out <= 32'd0;
        else if (efuse_bypass)
            efuse_out <= efuse_in;
        else if(rd_done) begin       
            efuse_out <= data_read;
        end
        else    
            efuse_out <= efuse_out;
    end

    always @(posedge clk or negedge rst_n)begin
        if(!rst_n)
            ack <= 1'b0;
        else if(rd_done)
            ack <= 1'b1;
        else if(wr_done)
            ack <= 1'b1;
        else 
            ack <= 1'b0; 
    end

    always @(posedge clk or negedge rst_n) begin
        if(!rst_n)
            data_write <= 32'd0;
        else if(efuse_write)
            data_write <= (efuse_in & (~efuse_out));
        else 
            data_write <= data_write; 
    end
	
	
	always@(posedge clk or negedge rst_n) begin 
	    if(!rst_n) begin
		    margin_read_out <= 1'b0 ;
		end 
		else if(margin_read_in == 1'b1) begin 
		    margin_read_out <= 1'b1 ;
		end 
		else begin 
		    margin_read_out <= 1'b0 ;
		end 
	end 
	
	
	
endmodule
