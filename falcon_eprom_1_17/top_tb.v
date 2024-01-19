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


    wire [31:0] EFUSE_OUT ;
    
//    output [7:0] EFUSE_CTRL     ,
    
    wire [7:0] CTRL_ONE       ;
    wire [7:0] CTRL_TWO       ;
    wire [7:0] CTRL_THREE     ;
    wire    XCE;                            // Chip Enable signal
    wire     XREAD;                          // Read control signal
    wire     XPGM;                           // Program control signal 
    wire     XTM;                            // Margin read mode control signal
    wire     [1:0]    XA;     // Program/Read address
    wire     [7:0]        XDIN;   // Data input 
    wire     [7:0]        DQ;     // Data output
	wire     VPP_EN ;
	
	always #500 clk = ~clk;
	
	initial begin

    sda_out         = 1'b1;
    scl             = 1'b1;

    clk                 = 1'b1;
    reset_n             = 1'b0;
    #650 reset_n        = 1'b0;
    #900 reset_n        = 1'b1;
    
    #300_000
    //slave_addr
    #2000 sda_out = 1'b0;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[5];
    #1000 scl = 1;
    #2000 scl = 0 ;
    #1000 sda_out = addr_slave[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 0;//write = 0;
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    #1000 scl = 1;
    #2000 scl = 0;
    //
    #1000 sda_out = write_reg_addr[7];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[5];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[7];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[5];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    #1000 scl = 1;
    #2000 scl = 0;   
    //stop
    #2000 scl = 1;
    #2000 sda_out = 1;
    //////////////////////////////////////////////////////////////////////////////////////////ox03
     //start
    #2000 sda_out = 0;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[5];
    #1000 scl = 1;
    #2000 scl = 0 ;
    #1000 sda_out = addr_slave[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 0;//write = 0;
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    #1000 scl = 1;
    #2000 scl = 0;
    
    write_reg_addr       = 8'b00000011   ;
    write_reg_data       = 8'b00110000   ;
    #1000 sda_out = write_reg_addr[7];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[5];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[7];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[5];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    #1000 scl = 1;
    #2000 scl = 0;   
    //stop
    #2000 scl = 1;
    #2000 sda_out = 1;
   /////////////////////////////////////////////////////////////////////////////////////////////////0x04
     //start
    #2000 sda_out = 0;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[5];
    #1000 scl = 1;
    #2000 scl = 0 ;
    #1000 sda_out = addr_slave[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 0;//write = 0;
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    #1000 scl = 1;
    #2000 scl = 0;
    
    write_reg_addr       = 8'b00000100   ;
    write_reg_data       = 8'b11110000   ;
    #1000 sda_out = write_reg_addr[7];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[5];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[7];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[5];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    #1000 scl = 1;
    #2000 scl = 0;   
    //stop
    #2000 scl = 1;
    #2000 sda_out = 1;
  
  //////////////////////////////////////////////////////////////////////////////////////////0x05
  
   //start
    #2000 sda_out = 0;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[5];
    #1000 scl = 1;
    #2000 scl = 0 ;
    #1000 sda_out = addr_slave[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 0;//write = 0;
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    #1000 scl = 1;
    #2000 scl = 0;
    
    write_reg_addr       = 8'b00000101   ;
    write_reg_data       = 8'b00110000   ;
    #1000 sda_out = write_reg_addr[7];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[5];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[7];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[5];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    #1000 scl = 1;
    #2000 scl = 0;   
    //stop
    #2000 scl = 1;
    #2000 sda_out = 1;
  
  ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////0x06
  
   //start
    #2000 sda_out = 0;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[5];
    #1000 scl = 1;
    #2000 scl = 0 ;
    #1000 sda_out = addr_slave[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 0;//write = 0;
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    #1000 scl = 1;
    #2000 scl = 0;
    
    write_reg_addr       = 8'b00000110   ;
    write_reg_data       = 8'b00000001   ;
    #1000 sda_out = write_reg_addr[7];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[5];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[7];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[5];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    #1000 scl = 1;
    #2000 scl = 0;   
    //stop
    #2000 scl = 1;
    #2000 sda_out = 1;
  
  
  ////////////////////////////////////////////////////////////////////////////////////////multiple_write
  
   //start
    #5002000 sda_out = 0;
    #5002000 scl = 0;
    #1000 sda_out = addr_slave[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[5];
    #1000 scl = 1;
    #2000 scl = 0 ;
    #1000 sda_out = addr_slave[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 0;//write = 0;
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    #1000 scl = 1;
    #2000 scl = 0;
    
    write_reg_addr       = 8'b00000010   ;
    write_reg_data       = 8'b11001111   ;
    #1000 sda_out = write_reg_addr[7];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[5];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[7];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[5];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    #1000 scl = 1;
    #2000 scl = 0;   
    //stop
    #2000 scl = 1;
    #2000 sda_out = 1;
  
  
  /////////////////////////////////////////////////////////////////////////////////////0x03
  
   //start
    #2000 sda_out = 0;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[5];
    #1000 scl = 1;
    #2000 scl = 0 ;
    #1000 sda_out = addr_slave[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 0;//write = 0;
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    #1000 scl = 1;
    #2000 scl = 0;
    
    write_reg_addr       = 8'b00000011   ;
    write_reg_data       = 8'b11001111   ;
    #1000 sda_out = write_reg_addr[7];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[5];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[7];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[5];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    #1000 scl = 1;
    #2000 scl = 0;   
    //stop
    #2000 scl = 1;
    #2000 sda_out = 1;
  
  
 ///////////////////////////////////////////////////////////////////////0x04 
  
   //start
    #2000 sda_out = 0;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[5];
    #1000 scl = 1;
    #2000 scl = 0 ;
    #1000 sda_out = addr_slave[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 0;//write = 0;
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    #1000 scl = 1;
    #2000 scl = 0;
    
    write_reg_addr       = 8'b00000100   ;
    write_reg_data       = 8'b11001111   ;
    #1000 sda_out = write_reg_addr[7];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[5];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[7];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[5];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    #1000 scl = 1;
    #2000 scl = 0;   
    //stop
    #2000 scl = 1;
    #2000 sda_out = 1;
  
  
  /////////////////////////////////////////////////////////////////////////////0x05
  
   //start
    #2000 sda_out = 0;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[5];
    #1000 scl = 1;
    #2000 scl = 0 ;
    #1000 sda_out = addr_slave[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 0;//write = 0;
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    #1000 scl = 1;
    #2000 scl = 0;
    
    write_reg_addr       = 8'b00000101   ;
    write_reg_data       = 8'b11001111   ;
    #1000 sda_out = write_reg_addr[7];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[5];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[7];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[5];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    #1000 scl = 1;
    #2000 scl = 0;   
    //stop
    #2000 scl = 1;
    #2000 sda_out = 1;
  
  
  ////////////////////////////////////////////////////////////////////////////////0x06
  
  
   //start
    #2000 sda_out = 0;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[5];
    #1000 scl = 1;
    #2000 scl = 0 ;
    #1000 sda_out = addr_slave[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 0;//write = 0;
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    #1000 scl = 1;
    #2000 scl = 0;
    
    write_reg_addr       = 8'b00000110   ;
    write_reg_data       = 8'b00000000   ;
    #1000 sda_out = write_reg_addr[7];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[5];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[7];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[5];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    #1000 scl = 1;
    #2000 scl = 0;   
    //stop
    #2000 scl = 1;
    #2000 sda_out = 1;
  
  
  /////////////////////////////////////////////////////////////////////////////////0x06
  
  
   //start
    #2000 sda_out = 0;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[5];
    #1000 scl = 1;
    #2000 scl = 0 ;
    #1000 sda_out = addr_slave[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 0;//write = 0;
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    #1000 scl = 1;
    #2000 scl = 0;
    
    write_reg_addr       = 8'b00000110   ;
    write_reg_data       = 8'b00001101   ;
    #1000 sda_out = write_reg_addr[7];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[5];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_addr[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[7];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[5];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = write_reg_data[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    #1000 scl = 1;
    #2000 scl = 0;   
    //stop
    #2000 scl = 1;
    #2000 sda_out = 1;
  
  ////////////////////////////////////////////////////////////////////////////////////////////////////////////read
  
    #2000 sda_out = 0;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[5];
    #1000 scl = 1;
    #2000 scl = 0 ;
    #1000 sda_out = addr_slave[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 0;//write = 0;
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    #1000 scl = 1;
    #2000 scl = 0;
    
    #1000 sda_out = read_reg_addr[7];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = read_reg_addr[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = read_reg_addr[5];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = read_reg_addr[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = read_reg_addr[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = read_reg_addr[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = read_reg_addr[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = read_reg_addr[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    #1000 scl = 1;
    #2000 sda_out = 0;
    
    #1000 scl = 1;
    #2000 scl = 0;
    
    #1000 sda_out = addr_slave[6];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[5];
    #1000 scl = 1;
    #2000 scl = 0 ;
    #1000 sda_out = addr_slave[4];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[3];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[2];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[1];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = addr_slave[0];
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//read = 1;
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 sda_out = 1;//release the bus
    wait(!sda_in);
    
    #1000 scl = 1;
    #2000 scl = 0;
    #2000 scl = 1;
    #2000 scl = 0;
    #1000 master_read_addr[7] = sda_in;
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 master_read_addr[6] = sda_in;
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 master_read_addr[5] = sda_in;
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 master_read_addr[4] = sda_in;
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 master_read_addr[3] = sda_in;
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 master_read_addr[2] = sda_in;
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 master_read_addr[1] = sda_in;
    #1000 scl = 1;
    #2000 scl = 0;
    #1000 master_read_addr[0] = sda_in;
    #1000 scl = 1;
    #2000 scl = 0;
    
    #8000000
    $finish;

end
 


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

 /*                .Q         (q      ),
                 .VDD5V     (vdd5v  ),
                 .PGENB     (pgenb  ),
                 .STROBE    (strobe ),
                 .NR        (nr     ),
                 .WE        (we     )
				 
				 */
				. EFUSE_OUT(EFUSE_OUT) ,
    
//    output [7:0] EFUSE_CTRL     ,
    
               . CTRL_ONE(CTRL_ONE)       ,
               . CTRL_TWO(CTRL_TWO)       ,
               . CTRL_THREE(CTRL_THREE)     ,
				 
				 
				.XCE(XCE), 
                .XREAD(XREAD), 
                .XPGM(XPGM), 
                .XTM(XTM), 
                .XA(XA), 
                .XDIN(XDIN), 
                .DQ(DQ) ,
				.VPP_EN(VPP_EN) 
				 
				 
				 
                 );
/*TEF018BCD3G32X1PI5 u_TEF018BCD3G32X1PI5(
                 .Q(q),
                 .VDD5V(vdd5v),
                 .PGENB(pgenb),
                 .STROBE(strobe),
                 .NR(nr),
                 .WE(we)

);
*/

DBH_181aBD18BA_EP_4x8_5V_ISO U_DBH_181aBD18BA_EP_4x8_5V_ISO (
        .XCE(XCE), 
        .XREAD(XREAD), 
        .XPGM(XPGM), 
        .XTM(XTM), 
        .XA(XA), 
        .XDIN(XDIN), 
        .DQ(DQ)
        );


endmodule