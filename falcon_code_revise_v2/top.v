`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:chenglin
// Engineer:chuermeng
// 
// Create Date: 2022/03/11 15:24:13
// Design Name: top
// Module Name: top
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


module top(

    input CLK               ,
    input RST_N             ,

    input  SCL              ,
    input  SDA              ,
    output SDA_OUT          ,
    output OUT_EN           ,

    input [7:0] RO_ONE      ,
    input [7:0] RO_TWO      ,
//    input [7:0] RO_THREE    ,
//    input [7:0] RO_FOUR     ,
    
    output [31:0] EFUSE_OUT ,
    
//    output [7:0] EFUSE_CTRL     ,
    
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


    // output VDD5V                ,//???
    
    //I/0 for efuse
    input  Q                    ,
    output PGENB                ,
    output STROBE               ,
    output NR                   ,
    output [31:0] WE                    
    
    );
    
    // assign VDD5V = 1'b1;

    //srl_decoder ---> main_state_machine
    wire efuse_bypass     ;
    wire efuse_write      ;
    wire [31:0] efuse_in  ;
    // wire [31:0] efuse_out ;

  
    //main_state_machine <-------> efuse_controller
    wire write              ;
    wire read               ;
    wire ack                ;
    wire wr_done            ;
    wire rd_done            ;
    wire [31:0] data_in     ;
    wire [31:0] data_out    ;
    
    wire rst_n_s            ;
    wire clk_div_r          ;
    
    clk_div  #(.DIV_CLK(1)) 
        u_clk_div(
        .clk        (CLK        ),
        .rst_n      (rst_n_s    ),
        .clk_div_r  (clk_div_r  )
        );
    
    sync_async_reset u_sync_async_reset(
        .clk    (CLK    ),
        .rst_n  (RST_N  ),
        .rst_n_s(rst_n_s)
   );
   
    main_state_machine u_main_state_machine(

        .clk            (CLK        )  ,
        .rst_n          (rst_n_s    )  ,

        .efuse_write    (efuse_write)  ,
        .efuse_in       (efuse_in   )  ,
        .efuse_out      (EFUSE_OUT  )  ,
        .efuse_bypass   (efuse_bypass) ,

        .write          (write      )  ,
        .read           (read       )  ,
        .ack            (ack        )  ,
        .data_write     (data_in    )  ,
        .data_read      (data_out   )  ,
        .wr_done        (wr_done    )  ,
        .rd_done        (rd_done    )

    );


    efuse_controller u_efuse_controller(
        .clk_div2   (clk_div_r  ),
        .rst_n      (rst_n_s    ),

        .wr         (write      ),
        .rd         (read       ),
        .ack        (ack        ),
        .data_in    (data_in    ),
        .data_out   (data_out   ),
        .wr_done    (wr_done    ),
        .rd_done    (rd_done    ),

        .pgenb      (PGENB      ),
        .strobe     (STROBE     ),
        .nr         (NR         ),
        .q          (Q          ),
        .we         (WE         )
    );

    i2c u_i2c(

        .clk           (CLK                 ),
        .reset_n       (rst_n_s             ),

        .efuse_write    (efuse_write        ),
        .efuse_bypass   (efuse_bypass       ),
        .efuse_out      (EFUSE_OUT          ),
        .efuse_in       (efuse_in           ),

        .RO_ONE         (RO_ONE             ),
        .RO_TWO         (RO_TWO             ),
//        .RO_THREE       (RO_THREE           ),
//        .RO_FOUR        (RO_FOUR            ),
               
//        .EFUSE_CTRL    (EFUSE_CTRL           ),
        
        .CTRL_ONE      (CTRL_ONE             ),
        .CTRL_TWO      (CTRL_TWO             ),
        .CTRL_THREE    (CTRL_THREE           ),
//        .CTRL_FOUR     (CTRL_FOUR            ),
//        .CTRL_FIVE     (CTRL_FIVE            ),
//        .CTRL_SIX      (CTRL_SIX             ),
//        .CTRL_SEVEN    (CTRL_SEVEN           ),
//        .CTRL_EIGHT    (CTRL_EIGHT           ),
//        .CTRL_NINE     (CTRL_NINE            ),
//        .CTRL_TEN      (CTRL_TEN             ),
//        .CTRL_ELEVEN   (CTRL_ELEVEN          ),
//        .CTRL_TWELVE   (CTRL_TWELVE          ),
//        .CTRL_THIRTEEN (CTRL_THIRTEEN        ),
//        .CTRL_FOURTEEN (CTRL_FOURTEEN        ),
//        .CTRL_FIFTEEN  (CTRL_FIFTEEN         ),
//        .CTRL_SIXTEEN  (CTRL_SIXTEEN         ),

        .scl            (SCL                ),
        .sda            (SDA                ),
        .sda_out        (SDA_OUT            ),
        .sda_out_en     (OUT_EN             )

    );

endmodule
