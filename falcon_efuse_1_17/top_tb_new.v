`timescale 1ns/1ps

module top_tb();

reg clk             ;
reg reset_n         ;

reg sda_out         ;
reg scl             ;
wire sda_in         ;
wire out_en         ;

wire [6:0] addr_slave           = 7'b1010101    ;
reg  [7:0] write_reg_addr       = 8'b00000010   ;
reg  [7:0] write_reg_data       = 8'b11110000   ;
reg  [7:0] read_reg_addr        = 8'b00000010   ;
reg  [7:0] master_read_addr     = 8'b00000000   ;

wire   [7:0]   RO_ONE    = 8'h01;       
wire   [7:0]   RO_TWO    = 8'h02;       
//wire   [7:0]   RO_THREE  = 8'h03;    
//wire   [7:0]   RO_FOUR   = 8'h04; 

wire q                  ;
wire vdd5v              ;
wire pgenb              ;
wire strobe             ;
wire nr                 ;
wire [31:0] we          ; 

always #230 clk = ~clk;
`ifdef FSDB
initial begin
        $fsdbDumpfile("top_tb.fsdb");
        $fsdbDumpvars;
end
`endif

initial begin

    sda_out         = 1'b1;
    scl             = 1'b1;

    clk                 = 1'b1;
    reset_n             = 1'b0;
    #650 reset_n        = 1'b0;
    #900 reset_n        = 1'b1;
    
    #300000
    //slave_addr
    #500 sda_out = 1'b0;
    #500 scl = 0;
    #250 sda_out = addr_slave[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[5];
    #250 scl = 1;
    #500 scl = 0 ;
    #250 sda_out = addr_slave[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 0;//write = 0;
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    #250 scl = 1;
    #500 scl = 0;
    //
    #250 sda_out = write_reg_addr[7];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[5];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[7];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[5];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    #250 scl = 1;
    #500 scl = 0;   
    //stop
    #500 scl = 1;
    #500 sda_out = 1;
    
     //start
    #500 sda_out = 0;
    #500 scl = 0;
    #250 sda_out = addr_slave[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[5];
    #250 scl = 1;
    #500 scl = 0 ;
    #250 sda_out = addr_slave[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 0;//write = 0;
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    #250 scl = 1;
    #500 scl = 0;
    
    write_reg_addr       = 8'b00000011   ;
    write_reg_data       = 8'b11110000   ;
    #250 sda_out = write_reg_addr[7];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[5];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[7];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[5];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    #250 scl = 1;
    #500 scl = 0;   
    //stop
    #500 scl = 1;
    #500 sda_out = 1;
   
     //start
    #500 sda_out = 0;
    #500 scl = 0;
    #250 sda_out = addr_slave[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[5];
    #250 scl = 1;
    #500 scl = 0 ;
    #250 sda_out = addr_slave[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 0;//write = 0;
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    #250 scl = 1;
    #500 scl = 0;
    
    write_reg_addr       = 8'b00000100   ;
    write_reg_data       = 8'b11110000   ;
    #250 sda_out = write_reg_addr[7];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[5];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[7];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[5];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    #250 scl = 1;
    #500 scl = 0;   
    //stop
    #500 scl = 1;
    #500 sda_out = 1;
  
   //start
    #500 sda_out = 0;
    #500 scl = 0;
    #250 sda_out = addr_slave[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[5];
    #250 scl = 1;
    #500 scl = 0 ;
    #250 sda_out = addr_slave[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 0;//write = 0;
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    #250 scl = 1;
    #500 scl = 0;
    
    write_reg_addr       = 8'b00000101   ;//EFUSE_IN_THREE
    write_reg_data       = 8'b11110000   ;
    #250 sda_out = write_reg_addr[7];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[5];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[7];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[5];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    #250 scl = 1;
    #500 scl = 0;   
    //stop
    #500 scl = 1;
    #500 sda_out = 1;
  
  //start
    #500 sda_out = 0;
    #500 scl = 0;
    #250 sda_out = addr_slave[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[5];
    #250 scl = 1;
    #500 scl = 0 ;
    #250 sda_out = addr_slave[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 0;//write = 0;
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    #250 scl = 1;
    #500 scl = 0;
    
    write_reg_addr       = 8'b00000110   ;//EFUSE_CTRL
    write_reg_data       = 8'b00000001   ;
    #250 sda_out = write_reg_addr[7];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[5];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[7];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[5];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    #250 scl = 1;
    #500 scl = 0;   
    //stop
    #500 scl = 1;
    #500 sda_out = 1;
  
  
  /////////////////////////////////////////////////////////////////////////////////////////////////////////// new_tb
  
  //start
    #1000500 sda_out = 0;
    #1000500 scl = 0;
    #250 sda_out = addr_slave[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[5];
    #250 scl = 1;
    #500 scl = 0 ;
    #250 sda_out = addr_slave[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 0;//write = 0;
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    #250 scl = 1;
    #500 scl = 0;
    
    write_reg_addr       = 8'b00000010   ;//EFUSE_CTRL
    write_reg_data       = 8'b00000011   ;
    #250 sda_out = write_reg_addr[7];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[5];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[7];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[5];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    #250 scl = 1;
    #500 scl = 0;   
    //stop
    #500 scl = 1;
    #500 sda_out = 1;
	
	
	
///////////////1
  
  //start
    #500 sda_out = 0;
    #500 scl = 0;
    #250 sda_out = addr_slave[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[5];
    #250 scl = 1;
    #500 scl = 0 ;
    #250 sda_out = addr_slave[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 0;//write = 0;
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    #250 scl = 1;
    #500 scl = 0;
    
    write_reg_addr       = 8'b00000011   ;//EFUSE_CTRL
    write_reg_data       = 8'b00000011   ;
    #250 sda_out = write_reg_addr[7];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[5];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[7];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[5];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    #250 scl = 1;
    #500 scl = 0;   
    //stop
    #500 scl = 1;
    #500 sda_out = 1;
  
  
  ////////////////////////////////////2
  //start
    #500 sda_out = 0;
    #500 scl = 0;
    #250 sda_out = addr_slave[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[5];
    #250 scl = 1;
    #500 scl = 0 ;
    #250 sda_out = addr_slave[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 0;//write = 0;
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    #250 scl = 1;
    #500 scl = 0;
    
    write_reg_addr       = 8'b00000100   ;//EFUSE_CTRL
    write_reg_data       = 8'b00000011   ;
    #250 sda_out = write_reg_addr[7];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[5];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[7];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[5];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    #250 scl = 1;
    #500 scl = 0;   
    //stop
    #500 scl = 1;
    #500 sda_out = 1;
  
   //////////3
   //start
    #500 sda_out = 0;
    #500 scl = 0;
    #250 sda_out = addr_slave[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[5];
    #250 scl = 1;
    #500 scl = 0 ;
    #250 sda_out = addr_slave[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 0;//write = 0;
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    #250 scl = 1;
    #500 scl = 0;
    
    write_reg_addr       = 8'b00000101   ;//EFUSE_CTRL
    write_reg_data       = 8'b00000011   ;
    #250 sda_out = write_reg_addr[7];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[5];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[7];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[5];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    #250 scl = 1;
    #500 scl = 0;   
    //stop
    #500 scl = 1;
    #500 sda_out = 1;
    
  ///////////////////4
  
  //start
    #500 sda_out = 0;
    #500 scl = 0;
    #250 sda_out = addr_slave[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[5];
    #250 scl = 1;
    #500 scl = 0 ;
    #250 sda_out = addr_slave[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 0;//write = 0;
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    #250 scl = 1;
    #500 scl = 0;
    
    write_reg_addr       = 8'b00000110   ;//EFUSE_CTRL
    write_reg_data       = 8'b00000000   ;
    #250 sda_out = write_reg_addr[7];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[5];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[7];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[5];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    #250 scl = 1;
    #500 scl = 0;   
    //stop
    #500 scl = 1;
    #500 sda_out = 1;
    
 //////////////////////////////////5
 
/* //start
    #500 sda_out = 0;
    #500 scl = 0;
    #250 sda_out = addr_slave[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[5];
    #250 scl = 1;
    #500 scl = 0 ;
    #250 sda_out = addr_slave[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 0;//write = 0;
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    #250 scl = 1;
    #500 scl = 0;
    
    write_reg_addr       = 8'b00000110   ;//EFUSE_CTRL
    write_reg_data       = 8'b00000100   ;
    #250 sda_out = write_reg_addr[7];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[5];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[7];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[5];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    #250 scl = 1;
    #500 scl = 0;   
    //stop
    #500 scl = 1;
    #500 sda_out = 1;
 */
    //////////////////////////////6
	
	//start
    #500 sda_out = 0;
    #500 scl = 0;
    #250 sda_out = addr_slave[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[5];
    #250 scl = 1;
    #500 scl = 0 ;
    #250 sda_out = addr_slave[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 0;//write = 0;
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    #250 scl = 1;
    #500 scl = 0;
    
    write_reg_addr       = 8'b00000110   ;//EFUSE_CTRL
    write_reg_data       = 8'b00000101   ;
    #250 sda_out = write_reg_addr[7];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[5];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_addr[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[7];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[5];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = write_reg_data[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    #250 scl = 1;
    #500 scl = 0;   
    //stop
    #500 scl = 1;
    #500 sda_out = 1;
	
    
/////////////////////////////////////////////////////////////////////////////////////////////////////new_tb_end 
    
    
//    #250 scl = 0;
    //start
    #500 sda_out = 0;
    #500 scl = 0;
    #250 sda_out = addr_slave[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[5];
    #250 scl = 1;
    #500 scl = 0 ;
    #250 sda_out = addr_slave[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 0;//write = 0;
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    #250 scl = 1;
    #500 scl = 0;
    
    #250 sda_out = read_reg_addr[7];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = read_reg_addr[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = read_reg_addr[5];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = read_reg_addr[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = read_reg_addr[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = read_reg_addr[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = read_reg_addr[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = read_reg_addr[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    #5000 scl = 1;
    #500 sda_out = 0;
    
    #250 scl = 1;
    #500 scl = 0;
    
    #250 sda_out = addr_slave[6];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[5];
    #250 scl = 1;
    #500 scl = 0 ;
    #250 sda_out = addr_slave[4];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[3];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[2];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[1];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = addr_slave[0];
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//read = 1;
    #250 scl = 1;
    #500 scl = 0;
    #250 sda_out = 1;//release the bus
    wait(!sda_in);
    
    #250 scl = 1;
    #500 scl = 0;
    #250 scl = 1;
    #500 scl = 0;
    #250 master_read_addr[7] = sda_in;
    #250 scl = 1;
    #500 scl = 0;
    #250 master_read_addr[6] = sda_in;
    #250 scl = 1;
    #500 scl = 0;
    #250 master_read_addr[5] = sda_in;
    #250 scl = 1;
    #500 scl = 0;
    #250 master_read_addr[4] = sda_in;
    #250 scl = 1;
    #500 scl = 0;
    #250 master_read_addr[3] = sda_in;
    #250 scl = 1;
    #500 scl = 0;
    #250 master_read_addr[2] = sda_in;
    #250 scl = 1;
    #500 scl = 0;
    #250 master_read_addr[1] = sda_in;
    #250 scl = 1;
    #500 scl = 0;
    #250 master_read_addr[0] = sda_in;
    #250 scl = 1;
    #500 scl = 0;
    
    #8000000
    $finish;

end



//assign vdd5v = 1'b1;


top u_top(
                 .CLK       (clk    ),
                 .RST_N     (reset_n),
                 .SCL       (scl),
                 .SDA       (sda_out),
                 .SDA_OUT   (sda_in ),
                 .OUT_EN    (out_en),
                 
                .RO_ONE         (RO_ONE             ),
                .RO_TWO         (RO_TWO             ),
//                .RO_THREE       (RO_THREE           ),
//                .RO_FOUR        (RO_FOUR            ),

                 .Q         (q      ),
                 .VDD5V     (vdd5v  ),
                 .PGENB     (pgenb  ),
                 .STROBE    (strobe ),
                 .NR        (nr     ),
                 .WE        (we     )
                 );
TEF018BCD3G32X1PI5 u_TEF018BCD3G32X1PI5(
                 .Q(q),
                 .VDD5V(vdd5v),
                 .PGENB(pgenb),
                 .STROBE(strobe),
                 .NR(nr),
                 .WE(we)

);
endmodule
