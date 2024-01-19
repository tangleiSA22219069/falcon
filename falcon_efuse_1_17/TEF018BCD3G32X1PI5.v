//***************************************************************************************************
//
//      Electrical Fuse - TEF018BCD3G32X1PI5
//      The TEF018BCD3G32X1PI5 is organized as a maximum of 32 bits by 1 one-time 
//      programmable electrical fuse with random accesses.  The fuse is a
//      kind of non-volatile memory fabricated in standard CMOS logic process.
//      This fuse macro is widely used in chip ID, memory redundancy repair, security
//      code, configuration setting, and feature selection, etc.
//
//      STROBE     (I) - High to turn on the array for read or program access
//      PGENB      (I) - Program enable, low active
//      WE[31:0]   (I) - WL enable for read or program operation, high active 
//      NR         (I) - High for normal read mode and low for standby mode
//      Q          (O) - Data output
//      VDD5V (Supply) - VDD5V power supply (5V)
//
//      Note:  This Verilog model is suitable only for NC-Verilog, VCS, and Modelsim simulators
//
//      [ Important ] VDD5V constraints:
// 
//         1. VDD5V should be set to 1 for correct model behavior.
//         2. If VDD5V is not set to 1, Q will always be x. 
//     
//      To activate data preloading,
//         1. Please provide an input file containing the value of the fuse data(ex: preload.data).
//         2. Call the simulator with "+preload_file=preload.data" option
//                                                   ^^^^^^^^^^^^ could accept 32 characters
//         ex: 
//            ncverilog +access+rwc +preload_file=preload.data tefxx.v ...
//
//         preload.data format  
//         -------------------
//
//         1. @<address> <data> 
//            @00 0 @01 0 @02 0 @03 0 @04 0 @05 0 @06 0 @07 0                  
//
//         2. <data> <data> <data> ...etc., index from address 0. ex: 
//            0 0 0 0 0 0 0 0
//
//       To waive the timing delays and constraints, please add the following line in the caller
//       module.
//         `define no_timing
//
//      [ EDA Tool Applied ] 
//
//          Category  |  Vendor   |  Tool Name   |  Used Version 
//          ------------------------------------------------------
//      (1) Simulate  |  cadence  |  NC-Verilog  |  ius583p3_lnx86
//      (2) Simulate  |  synopsys |  VCS         |  C-2009.06
//      (3) Simulate  |  Mentor   |  ModelSim    |  v6.2d_lnx
//      (4) Analyze   |  synopsys |  PrimeTime   |  B-2008.12-SP3      
//
//***************************************************************************************************
//
// STATEMENT OF USE
//
// This information contains confidential and proprietary information of TSMC.
// No part of this information may be reproduced, transmitted, transcribed,
// stored in a retrieval system, or translated into any human or computer
// language, in any form or by any means, electronic, mechanical, magnetic,
// optical, chemical, manual, or otherwise, without the prior written permission
// of TSMC. This information was prepared for informational purpose and is for
// use by TSMC's customers only. TSMC reserves the right to make changes in the
// information at any time and without notice.
//
//***************************************************************************************************
`celldefine
`timescale 1ns/1ps

module TEF018BCD3G32X1PI5 (STROBE, PGENB, WE, NR, Q, VDD5V);

// Define Parameters
parameter  TSQ =  161 ;

parameter  fuseSize = 32;

parameter  fuseSizeAddr = 5;
parameter  numOut = 1;
parameter  numOutAddr = 0;

// IO Ports
input  STROBE, PGENB, NR;
input  [fuseSize - 1 : 0] WE;
inout  VDD5V;
output Q;

// Internal Signals
wire  STROBE_i, PGENB_i, NR_i;
wire  [fuseSize - 1 : 0] WE_i;
wire  Q_i;
wire  check_read, check_pgm;
wire  check_read_in, check_pgm_in;
wire  check_read_out, check_pgm_out;

// Registers
reg [fuseSizeAddr - 1 : 0] internal_WE;
reg fuse_data [fuseSize - 1 : 0];
reg preload_data [fuseSize - 1 : 0];
reg [numOut-1 : 0] Q_d;
reg notify_read_trd, notify_read_tsur_pg, notify_read_thr_pg, notify_read_tsur_we, notify_read_thr_we;
reg notify_pgm_tpgm_min, notify_pgm_tsup_pg, notify_pgm_thp_pg, notify_pgm_tsup_we, notify_pgm_thp_we;
reg notify_read_tsur_nr, notify_read_thr_nr;
reg notify_pgm_tsup_nr, notify_pgm_thp_nr;
// data preloadting setting
reg [255:0] preload_file_name ;

// For checking programming STROBE width
real strobe_high_time;
real strobe_low_time;

// Variables
reg read_flag, pgm_flag;
reg read_in_flag, pgm_in_flag;
reg read_out_flag, pgm_out_flag;

reg [fuseSizeAddr:0] i ;
reg [fuseSizeAddr:0] we_bit_count ;

// IO Buffers
buf (STROBE_i, STROBE);
buf (PGENB_i, PGENB);
buf (NR_i, NR);
buf (WE_i[0], WE[0]);
buf (WE_i[1], WE[1]);
buf (WE_i[2], WE[2]);
buf (WE_i[3], WE[3]);
buf (WE_i[4], WE[4]);
buf (WE_i[5], WE[5]);
buf (WE_i[6], WE[6]);
buf (WE_i[7], WE[7]);
buf (WE_i[8], WE[8]);
buf (WE_i[9], WE[9]);
buf (WE_i[10], WE[10]);
buf (WE_i[11], WE[11]);
buf (WE_i[12], WE[12]);
buf (WE_i[13], WE[13]);
buf (WE_i[14], WE[14]);
buf (WE_i[15], WE[15]);
buf (WE_i[16], WE[16]);
buf (WE_i[17], WE[17]);
buf (WE_i[18], WE[18]);
buf (WE_i[19], WE[19]);
buf (WE_i[20], WE[20]);
buf (WE_i[21], WE[21]);
buf (WE_i[22], WE[22]);
buf (WE_i[23], WE[23]);
buf (WE_i[24], WE[24]);
buf (WE_i[25], WE[25]);
buf (WE_i[26], WE[26]);
buf (WE_i[27], WE[27]);
buf (WE_i[28], WE[28]);
buf (WE_i[29], WE[29]);
buf (WE_i[30], WE[30]);
buf (WE_i[31], WE[31]);

u_power_down (Q, Q_i, VDD5V);

`ifdef no_timing
`else
// Specify Block for Timing Delay Path and Timing Constraints
specify

specparam Tsur_pg =	   15            ;
specparam Thr_pg =     15             ;
specparam Trd =        162                ;
specparam Tsur_we =     15             ;
specparam Thr_we =      15              ;
specparam Tsur_nr =    15            ;
specparam Thr_nr =     15             ;
specparam Tsq =        161           ;
specparam Tsup_pg =    15            ;
specparam Thp_pg =     15             ;
specparam Tpgm_min =   18000           ;
specparam Tpgm_max =   22000           ;
specparam Tsup_we =     15             ;
specparam Thp_we =      15              ;
specparam Tsup_nr =    15            ;
specparam Thp_nr =     15             ;

// STROBE -> Q delay

    if (check_read === 1'b1) (posedge STROBE => (Q:STROBE)) = 
    	    (Tsq, Tsq, 0, Tsq, 0, Tsq);

    // READ timing constraints
    $width(posedge STROBE &&& check_read_in, Trd, 0, notify_read_trd);

    $setuphold(posedge STROBE &&& check_read, posedge PGENB, Tsur_pg, 0,  notify_read_tsur_pg);
    $setuphold(negedge STROBE &&& check_read_out, negedge PGENB, 0, Thr_pg,  notify_read_thr_pg);
    $setuphold(posedge STROBE &&& check_read, posedge NR, Tsur_nr, 0,  notify_read_tsur_nr);
    $setuphold(negedge STROBE &&& check_read_out, negedge NR, 0, Thr_nr,  notify_read_thr_nr);
    
    $setuphold(posedge STROBE &&& check_read, posedge WE[0], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[0], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[0], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[0], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[1], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[1], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[1], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[1], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[2], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[2], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[2], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[2], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[3], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[3], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[3], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[3], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[4], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[4], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[4], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[4], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[5], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[5], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[5], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[5], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[6], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[6], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[6], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[6], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[7], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[7], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[7], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[7], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[8], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[8], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[8], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[8], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[9], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[9], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[9], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[9], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[10], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[10], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[10], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[10], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[11], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[11], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[11], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[11], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[12], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[12], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[12], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[12], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[13], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[13], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[13], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[13], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[14], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[14], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[14], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[14], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[15], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[15], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[15], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[15], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[16], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[16], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[16], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[16], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[17], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[17], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[17], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[17], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[18], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[18], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[18], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[18], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[19], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[19], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[19], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[19], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[20], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[20], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[20], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[20], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[21], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[21], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[21], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[21], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[22], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[22], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[22], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[22], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[23], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[23], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[23], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[23], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[24], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[24], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[24], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[24], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[25], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[25], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[25], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[25], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[26], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[26], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[26], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[26], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[27], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[27], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[27], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[27], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[28], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[28], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[28], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[28], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[29], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[29], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[29], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[29], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[30], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[30], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[30], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[30], 0, Thr_we,  notify_read_thr_we);
    $setuphold(posedge STROBE &&& check_read, posedge WE[31], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(posedge STROBE &&& check_read, negedge WE[31], Tsur_we, 0,  notify_read_tsur_we);
    $setuphold(negedge STROBE &&& check_read_out, posedge WE[31], 0, Thr_we,  notify_read_thr_we);
    $setuphold(negedge STROBE &&& check_read_out, negedge WE[31], 0, Thr_we,  notify_read_thr_we);

    // PROGRAM timing constraints
    $width(posedge STROBE &&& check_pgm_in, Tpgm_min, 0, notify_pgm_tpgm_min);
    
    $setuphold(posedge STROBE &&& check_pgm, negedge PGENB, Tsup_pg, 0,  notify_pgm_tsup_pg);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge PGENB, 0, Thp_pg,  notify_pgm_thp_pg);
    $setuphold(posedge STROBE &&& check_pgm, negedge NR, Tsup_nr, 0,  notify_pgm_tsup_nr);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge NR, 0, Thp_nr,  notify_pgm_thp_nr);
    
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[0], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[0], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[0], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[0], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[1], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[1], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[1], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[1], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[2], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[2], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[2], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[2], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[3], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[3], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[3], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[3], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[4], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[4], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[4], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[4], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[5], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[5], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[5], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[5], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[6], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[6], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[6], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[6], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[7], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[7], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[7], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[7], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[8], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[8], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[8], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[8], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[9], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[9], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[9], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[9], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[10], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[10], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[10], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[10], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[11], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[11], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[11], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[11], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[12], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[12], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[12], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[12], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[13], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[13], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[13], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[13], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[14], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[14], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[14], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[14], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[15], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[15], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[15], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[15], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[16], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[16], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[16], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[16], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[17], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[17], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[17], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[17], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[18], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[18], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[18], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[18], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[19], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[19], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[19], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[19], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[20], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[20], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[20], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[20], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[21], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[21], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[21], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[21], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[22], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[22], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[22], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[22], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[23], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[23], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[23], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[23], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[24], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[24], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[24], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[24], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[25], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[25], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[25], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[25], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[26], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[26], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[26], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[26], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[27], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[27], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[27], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[27], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[28], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[28], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[28], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[28], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[29], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[29], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[29], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[29], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[30], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[30], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[30], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[30], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(posedge STROBE &&& check_pgm, posedge WE[31], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(posedge STROBE &&& check_pgm, negedge WE[31], Tsup_we, 0,  notify_pgm_tsup_we);
    $setuphold(negedge STROBE &&& check_pgm_out, posedge WE[31], 0, Thp_we,  notify_pgm_thp_we);
    $setuphold(negedge STROBE &&& check_pgm_out, negedge WE[31], 0, Thp_we,  notify_pgm_thp_we);

endspecify
`endif

// Initial Block
initial begin
    initFuseData;
    
    if ($value$plusargs("preload_file=%s", preload_file_name)) begin
        if(!$fopen(preload_file_name, "r")) begin
            $write("%.3f (ns) Error: Preload file(%0s) not found. \n", $realtime, preload_file_name); 
        end else begin
            $write("Activate data preloading with file: %0s\n", preload_file_name);
            preloadFuse(preload_file_name);  
        end 
    end

    Q_d = {numOut{1'bx}};
    read_flag = 0;
    pgm_flag = 0;
    read_in_flag = 0;
    pgm_in_flag = 0;
    read_out_flag = 0;
    pgm_out_flag = 0;

    strobe_high_time       <= -1;
    strobe_low_time        <= -1;

end

// Continuous Signals and Data Output
assign Q_i = Q_d;
assign check_read = read_flag;
assign check_pgm = pgm_flag;
assign check_read_in = read_in_flag;
assign check_pgm_in = pgm_in_flag;
assign check_read_out = read_out_flag;
assign check_pgm_out = pgm_out_flag;

always @(STROBE_i) begin
    if(VDD5V === 1'b1) begin
        if (STROBE_i === 1'b1) begin
    	    strobe_high_time = $realtime;
            read_out_flag = 0;
    	    pgm_out_flag = 0;
        end
        else if (STROBE_i === 1'b0) begin
    	    strobe_low_time = $realtime;
        end 
    
        if (STROBE_i === 1'b1) begin
            if (PGENB_i === 1'b0) begin
                Q_d = {numOut{1'bx}};
                if(NR_i === 1'b0) begin
                    if (^WE_i === 1'bx) begin
                    	$display("%.2fns Error: Address unknown during program cycle!", $realtime);
                	    xFuseData;
            	        Q_d = {numOut{1'bx}};
                    end
                    else begin
                        we_bit_count = 0;
                        for (i = 0 ; i < fuseSize ; i = i + 1) begin
                            if(WE_i[i] === 1'b1) begin
                                we_bit_count = we_bit_count + 1;           
                            end
                        end
                        
                        if(we_bit_count > 1) begin
                            $display("%.2fns Error: Only one bit of WE can be high during program cycle!", $realtime);
                            xFuseData;
            	            Q_d = {numOut{1'bx}};
                        end
                        else if(we_bit_count == 0) begin
                            $display("%.2fns Error: One bit of WE must be high during program cycle!", $realtime);
                            xFuseData;
            	            Q_d = {numOut{1'bx}};
                        end
                        else begin
                            pgm_flag = 1;
                            check_burn_duplicated;
                            if (fuse_data[internal_WE] === 1'b0) begin
                                $display("********************************************************************************************\n");
                                $display("%.3f (ns) Start Burn Fuse ...\n", $realtime);
                                $display("********************************************************************************************\n");
                                BurnFuse;
                                $display("********************************************************************************************\n");
                                $display("%.3f (ns) End Burn Fuse ...\n", $realtime);
                                $display("********************************************************************************************\n");
                            end
                        end
                    end	
                end
                else begin
                    $display("%.2fns Error: NR must be low during program cycle!", $realtime);
                    xFuseData;
            	    Q_d = {numOut{1'bx}};
                end	
            end
            else if (PGENB_i === 1'b1) begin
                if (NR_i === 1'b1) begin
                    if (^WE_i === 1'bx) begin
           	            $display("%.2fns Warning: Address unknown during read cycle!", $realtime);
        	            Q_d = {numOut{1'bx}};
                    end
                    else begin
                        we_bit_count = 0;
                        for (i = 0 ; i < fuseSize ; i = i + 1) begin
                            if(WE_i[i] === 1'b1) begin
                                we_bit_count = we_bit_count + 1;           
                            end
                        end
                        
                        if(we_bit_count > 1) begin
                            $display("%.2fns Warning: Only one bit of WE can be high during read cycle!", $realtime);
                            Q_d = {numOut{1'bx}};
                        end
                        else if(we_bit_count == 0) begin
                            $display("%.2fns Warning: One bit of WE must be high during read cycle!", $realtime);
                            Q_d = {numOut{1'bx}};
                        end
                        else begin
                            read_flag = 1;
                            `ifdef no_timing
        	                    Q_d = {numOut{1'bx}};
        	                    #TSQ;
                            `else
        	                `endif
        	                $display("********************************************************************************************\n");
                            $display("%.3f (ns) Start Read Fuse: Normal Read Mode ...\n", $realtime);
                            $display("********************************************************************************************\n");
                            ReadFuse;
                            $display("********************************************************************************************\n");
                            $display("%.3f (ns) End Read Fuse ...\n", $realtime);
                            $display("********************************************************************************************\n");
                        end
                    end	
                end
                else begin
                    $display("%.2fns Warning: NR must be high during read cycle!", $realtime);
            	    Q_d = {numOut{1'bx}};
                end	
            end
            else begin
                $display("%.2fns Error: PGENB x/z unknown when STROBE is high!", $realtime);
                $display("---------- PGENB = %b", PGENB_i);
                read_flag = 0;
                pgm_flag = 0;
                xFuseData;
                Q_d = {numOut{1'bx}};
            end
        end
        else if (STROBE_i === 1'b0) begin
	    Q_d = {numOut{1'bx}};
            if (read_flag == 1) begin
            	read_out_flag = 1;
            end
            else if (pgm_flag == 1) begin
        
                `ifdef no_timing
                 //no width check for program window
                `else
                 //check program window
                     if ((strobe_low_time - strobe_high_time) > Tpgm_max) begin
                         $write("%.3f (ns) Error: tpgm_max(%.3fns) STROBE width timing violation during program cycle!\n", $realtime, Tpgm_max);
                         xFuseData; 
                         Q_d = {numOut{1'bx}};
                     end
                `endif
                pgm_out_flag = 1;
            end
            read_flag = 0;
            pgm_flag = 0;
        end
        else begin
            if (PGENB_i === 1'b1) begin
                $display("%.2fns Warning: STROBE x/z while PGENB is high!", $realtime);
                Q_d = {numOut{1'bx}};
            end
            else if (PGENB_i === 1'b0) begin
                $display("%.2fns Error: STROBE x/z while PGENB is low!", $realtime);
    	        xFuseData;
    	        Q_d = {numOut{1'bx}};	
            end
            else begin
                $display("%.2fns Error: STROBE x/z while PGENB is x/z!", $realtime);
    	        xFuseData;
    	        Q_d = {numOut{1'bx}};	
            end
            if (read_flag == 1) begin
            	read_out_flag = 1;
            end
            else if (pgm_flag == 1) begin
            	pgm_out_flag = 1;
            end
            read_flag = 0;
            pgm_flag = 0;
        end    
    end
end

always @(NR_i) begin
    if(VDD5V === 1'b1) begin
        if($realtime > 0) begin
            if(NR_i === 1'bx) begin
                $display("%.2fns Warning: NR x/z!", $realtime);
                Q_d = {numOut{1'bx}};
            end
        end
        
        if (read_flag == 1) begin
        	$display("%.2fns Warning: NR toggled during read cycle!", $realtime);
    	    Q_d = {numOut{1'bx}};
        end
        else if (pgm_flag == 1) begin
        	$display("%.2fns Error: NR toggled during program cycle!", $realtime);
    	    xFuseData;
    	    Q_d = {numOut{1'bx}};
        end
    end
end

always @(WE_i) begin
    if(VDD5V === 1'b1) begin
        if($realtime > 0) begin
            if(^WE_i === 1'bx) begin
                $display("%.2fns Warning: WE x/z!", $realtime);
                Q_d = {numOut{1'bx}};
            end
        end
    
        if (read_flag == 1) begin
        	$display("%.2fns Warning: Address toggled during read cycle!", $realtime);
    	    Q_d = {numOut{1'bx}};
        end
        else if (pgm_flag == 1) begin
        	$display("%.2fns Error: Address toggled during program cycle!", $realtime);
    	    xFuseData;
    	    Q_d = {numOut{1'bx}};
        end
    end
end

always @(PGENB_i) begin
    if(VDD5V === 1'b1) begin
        if($realtime > 0) begin
            if(PGENB_i === 1'bx) begin
                $display("%.2fns Error: PGENB x/z!", $realtime);
    	        xFuseData;
                Q_d = {numOut{1'bx}};
            end
        end
    
        if (STROBE_i === 1'b1) begin
        	$display("%.2fns Error: PGENB toggled when STROBE is High!", $realtime);
    	    xFuseData;
            Q_d = {numOut{1'bx}};
    	    read_flag = 0;
    	    pgm_flag = 0;
        end
        
        if (PGENB_i === 1'b1) begin
        	read_in_flag = 1;
        end
        else begin
        	read_in_flag = 0;
        end
        
        if (PGENB_i === 1'b0) begin
        	pgm_in_flag = 1;
        	Q_d = {numOut{1'bx}};
        end
        else begin
        	pgm_in_flag = 0;
        end
    end
end

always @(VDD5V) begin
    if($realtime > 0) begin
        if(VDD5V === 1'b1) begin
            if(PGENB_i !== 1'b1) begin
                $display("%.2fns Error: PGENB must go high when VDD5V reached logic operation level!", $realtime);
                xFuseData;
    	        Q_d = {numOut{1'bx}};
            end
            
            if(|WE_i !== 1'b0) begin
                $display("%.2fns Error: WE must keep low during VDD5V power-up!", $realtime);
                xFuseData;
    	        Q_d = {numOut{1'bx}};
            end
            
            if(STROBE_i !== 1'b0) begin
                $display("%.2fns Error: STROBE must keep low during VDD5V power-up!", $realtime);
                xFuseData;
    	        Q_d = {numOut{1'bx}};
            end
            
            if(NR_i !== 1'b0) begin
                $display("%.2fns Error: NR must keep low during VDD5V power-up!", $realtime);
                xFuseData;
    	        Q_d = {numOut{1'bx}};
            end
        end
        else if(VDD5V === 1'b0) begin
            $display("%.2fns Warning: Power down the eFuse!", $realtime);
            Q_d = {numOut{1'bx}};
        end
        else begin
            $display("%.2fns Error: VDD5V x/z!", $realtime);
            xFuseData;
    	    Q_d = {numOut{1'bx}};
        end
    end
end

// notify 
`ifdef no_timing 
 //no notifier 
`else 
 //reading 
always @(notify_read_trd) begin
    if(VDD5V === 1'b1) begin
        $write("%.3f (ns) ERROR! trd(%.3fns) timing violation during read cycle!!!\n", $realtime, Trd);
        Q_d = {numOut{1'bx}};
    end
end

always @(notify_read_tsur_pg) begin
    if(VDD5V === 1'b1) begin
        $write("%.3f (ns) ERROR! tsur_pg(%.3fns) timing violation during read cycle!!!\n", $realtime, Tsur_pg);
        Q_d = {numOut{1'bx}};
    end
end

always @(notify_read_thr_pg) begin
    if(VDD5V === 1'b1) begin
        $write("%.3f (ns) ERROR! thr_pg(%.3fns) timing violation during read cycle!!!\n", $realtime, Thr_pg);
        Q_d = {numOut{1'bx}};
    end
end

always @(notify_read_tsur_we) begin
    if(VDD5V === 1'b1) begin
        $write("%.3f (ns) ERROR! tsur_we(%.3fns) timing violation during read cycle!!!\n", $realtime, Tsur_we);
        Q_d = {numOut{1'bx}};
    end
end

always @(notify_read_thr_we) begin
    if(VDD5V === 1'b1) begin
        $write("%.3f (ns) ERROR! thr_we(%.3fns) timing violation during read cycle!!!\n", $realtime, Thr_we);
        Q_d = {numOut{1'bx}};
    end
end

always @(notify_read_tsur_nr) begin
    if(VDD5V === 1'b1) begin
        $write("%.3f (ns) ERROR! tsur_nr(%.3fns) timing violation during read cycle!!!\n", $realtime, Tsur_we);
        Q_d = {numOut{1'bx}};
    end
end

always @(notify_read_thr_nr) begin
    if(VDD5V === 1'b1) begin
        $write("%.3f (ns) ERROR! thr_nr(%.3fns) timing violation during read cycle!!!\n", $realtime, Thr_we);
        Q_d = {numOut{1'bx}};
    end
end

//programming 
always @(notify_pgm_tpgm_min) begin
    if(VDD5V === 1'b1) begin
        $write("%.3f (ns) ERROR! tpgm_min(%.3fns) timing violation during program cycle!!!\n", $realtime, Tpgm_min);     
        xFuseData;
        Q_d = {numOut{1'bx}};
    end
end

always @(notify_pgm_tsup_pg) begin
    if(VDD5V === 1'b1) begin
        $write("%.3f (ns) ERROR! tsup_pg(%.3fns) timing violation during program cycle!!!\n", $realtime, Tsup_pg);     
        xFuseData;
        Q_d = {numOut{1'bx}};
    end
end

always @(notify_pgm_thp_pg) begin
    if(VDD5V === 1'b1) begin
        $write("%.3f (ns) ERROR! thp_pg(%.3fns) timing violation during program cycle!!!\n", $realtime, Thp_pg);     
        xFuseData;
        Q_d = {numOut{1'bx}};
    end
end

always @(notify_pgm_tsup_we) begin
    if(VDD5V === 1'b1) begin
        $write("%.3f (ns) ERROR! tsup_we(%.3fns) timing violation during program cycle!!!\n", $realtime, Tsup_we);     
        xFuseData;
        Q_d = {numOut{1'bx}};
    end
end

always @(notify_pgm_thp_we) begin
    if(VDD5V === 1'b1) begin
        $write("%.3f (ns) ERROR! thp_we(%.3fns) timing violation during program cycle!!!\n", $realtime, Thp_we);     
        xFuseData;
        Q_d = {numOut{1'bx}};
    end
end

always @(notify_pgm_tsup_nr) begin
    if(VDD5V === 1'b1) begin
        $write("%.3f (ns) ERROR! tsup_nr(%.3fns) timing violation during program cycle!!!\n", $realtime, Tsup_we);     
        xFuseData;
        Q_d = {numOut{1'bx}};
    end
end

always @(notify_pgm_thp_nr) begin
    if(VDD5V === 1'b1) begin
        $write("%.3f (ns) ERROR! thp_nr(%.3fns) timing violation during program cycle!!!\n", $realtime, Thp_we);     
        xFuseData;
        Q_d = {numOut{1'bx}};
    end
end
`endif

task BurnFuse;
reg [fuseSizeAddr : 0] k;
begin
    for(k = 0; k < fuseSize; k = k + 1) begin
        if(WE_i[k] === 1'b1) begin
            internal_WE = k;
        end
    end
    fuse_data[internal_WE] = 1'b1;
    
end
endtask

task ReadFuse;
reg [fuseSizeAddr : 0] k;
begin

    for(k = 0; k < fuseSize; k = k + 1) begin
        if(WE_i[k] === 1'b1) begin
            internal_WE = k;
        end
    end
    Q_d = fuse_data[internal_WE];

end
endtask

task xFuseData;
reg [fuseSizeAddr : 0] k;
begin

    for (k = 0; k < fuseSize; k = k + 1) begin
    	fuse_data[k] = 1'bx;
    end

end
endtask

task initFuseData;
reg [fuseSizeAddr : 0] k;
begin

    for (k = 0; k < fuseSize; k = k + 1) begin
    	fuse_data[k] = 1'b0;
    end

end
endtask


task preloadFuse;
input [255:0] preload_file;
begin
    $write("%.3f (ns) Preloading data from file %0s.\n", $realtime, preload_file);
    $readmemb(preload_file, preload_data, 0, fuseSize-1);

    //checking each bit in preload_data
    for (i = 0 ; i < fuseSize ; i = i + 1) begin
        if (^preload_data[i] === 1'bx) begin
            $write("%.3f (ns) Error: Preload data contains unknown values. preload[%d] = %b\n", $realtime, i[fuseSizeAddr-1:0], preload_data[i]);
            xFuseData; 
            Q_d = {numOut{1'bx}}; 
        end else begin
            $write("%.3f (ns) Preloading: address: %b, data: %b\n", $realtime, i[fuseSizeAddr-1:0], preload_data[i]);  
            fuse_data[i] = preload_data[i] ;
        end
    end
end
endtask

task check_burn_duplicated;
reg [fuseSizeAddr : 0] k;
begin
    for(k = 0; k < fuseSize; k = k + 1) begin
        if(WE_i[k] === 1'b1) begin
            internal_WE = k;
        end
    end
    //duplicated fuse burn is not allowed.
    if(fuse_data[internal_WE] !== 1'b0) begin 
        $display("%.2f ns Error: Fuse: %b already burned!", $realtime, internal_WE);
        xFuseData; 
        Q_d = {numOut{1'bx}}; 
    end 
end
endtask

endmodule

primitive u_power_down (Z, Zint, vdd);
    output Z;
    input Zint, vdd;
    
    table //Zint vdd : Z
             0    1  : 0 ;
             1    1  : 1 ;
             x    1  : x ;
             ?    0  : x ;
             ?    x  : x ;

    endtable
endprimitive

`endcelldefine


