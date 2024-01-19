//============================================================ DBH Header-Start =====//
// PLEASE BE ADVISED THAT:                                                           //
// All the database in DBH Design Kit (including any information or attachments to   //
// this Design Kit) are the exclusive property of DB HiTek Co., Ltd.                 //
//                                                                                   //
// All copyright, trademark and other intellectual property and proprietary rights   //
// in the text, graphics and all other materials originated or used by DB HiTek at   //
// the database for DBH Design Kit are reserved to DB HiTek. The database or any     //
// part thereof must be used only for the purpose of NDA or any other agreement      //
// executed between DB HiTek and you (or your company) and not be used, reproduced,  //
// published, adapted, modified, displayed, distributed or sold in any manner, in    //
// any form or media, without the prior written permission of DB HiTek.              //
//                                                                                   //
// A breach of this notice may result in irreparable and continuing damage to DB     //
// HiTek for which there may be no adequate remedy at law, and DB HiTek shall be     //
// entitled to seek injunctive relief and/or a decree for specific performance, and  //
// such other relief (including monetary damages) as may be proper.                  //
//===================================================================================//

//===================================================================================//
// File Name        : DBH_181aBD18BA_EP_4x8_5V_ISO.v                                 //
// IP Type          : 4x8bit EPROM Isolated 5V IP                                    //
// DK Type          : Verilog (test-bench, parameter)                                //
// Process Name     : 181aBD18BA                                                     //
// Version          : 2.0.10                                                         //
// Update           : 08/02/2019                                                     //
//===================================================================================//
//                                  Revision History                                 //
//===================================================================================//
// Version     Date(MM/DD/YYYY)    Who            Description                        //
//===================================================================================//
// 1.2.10      05/09/2018          OY SHIM        Initial Release                    //
// 2.0.10      08/02/2019          JE KIM         Updates Timing Parameters(tRD,tAC) //
//============================================================ DBH Header-End =======//

`timescale 1ns/1ps

`include "./DBH_181aBD18BA_EP_4x8_5V_ISO.param"

module DBH_181aBD18BA_EP_4x8_5V_ISO(XCE, XREAD, XPGM, XTM, XA, XDIN, DQ);

//===================================================================================
//  Pin Define
//===================================================================================
input     XCE;                            // Chip Enable signal
input     XREAD;                          // Read control signal
input     XPGM;                           // Program control signal 
input     XTM;                            // Margin read mode control signal
input     [`BIT_ADDR_BITS-1:0]    XA;     // Program/Read address
input     [`DATA_BITS-1:0]        XDIN;   // Data input 
output    [`DATA_BITS-1:0]        DQ;     // Data output

//===================================================================================
//  Internal Register Define
//===================================================================================
reg       [`DATA_BITS-1:0]        MemoryCell[`Word_Depth-1:0];   // EPROM data memory array
reg       [`BIT_ADDR_BITS-1:0]    MAIN_ADDR;
reg       [`DATA_BITS-1:0]        DQ_temp;                       // Data-Out Resister
          
reg       Read_Err_W_tRD;
reg       Read_Err_ST_tCEs;
reg       Read_Err_HD_tCEh;
reg       Read_Err_ST_tADs;
reg       Read_Err_HD_tADh;
          
reg       Program_Err_W_tPGM;
reg       Program_Err_ST_tCEs;
reg       Program_Err_HD_tCEh;
reg       Program_Err_ST_tADs;
reg       Program_Err_HD_tADh;
reg       Program_Err_ST_tPDs;
reg       Program_Err_HD_tPDh;
          
integer   i;

//===================================================================================
//  AC Characteristics
//===================================================================================
specify
specparam
          tRC   = `para_tRD +`para_tADs +`para_tADh,  // Read Cycle Time
          tRD   = `para_tRD,                          // Read High Pulse Width
          tRDL  = `para_tADs +`para_tADh,             // Read Low Pulse Width
          tAC   = `para_tAC,                          // Access Time
          tCEs  = `para_tCEs,                         // CE Setup Time
          tCEh  = `para_tCEh,                         // CE Hold Time
          tADs  = `para_tADs,                         // Address Setup Time
          tADh  = `para_tADh,                         // Address Hold Time
          tPDs  = `para_tPDs,                         // Program Data Setup Time
          tPDh  = `para_tPDh,                         // Program Data Hold Time
          tPGM_Min  = `para_tPGM_min,                 // Min Program Time
          tPGM_Max  = `para_tPGM_max,                 // Max Program Time
          tPGML     = `para_tADs +`para_tADh;         // Program Low Pulse Width
endspecify
    
//===================================================================================
//  Memory Initialize
//===================================================================================
initial begin
        for(i = 0; i <= `Word_Depth-1; i = i+1) begin
            MemoryCell[i] = `DATA_BITS'hFF;
        end
end

//===================================================================================
//  Run by Control Signal
//===================================================================================
//-------------------- Program Mode operation ---------------------------------------
always @(posedge XPGM) begin
         if(XCE && !XREAD && XPGM) begin                  // Program Status
            MemoryCell[XA] = MemoryCell[XA] & XDIN;
         end
end

//-------------------- Read Mode operation ------------------------------------------
wire      ReadMode;
assign    ReadMode = (XCE == 1 && XREAD == 1 && XPGM == 0 && XTM == 0)? 1 : 0;
assign    DQ = DQ_temp;

always @(posedge XREAD) begin                           // Read Status
         MAIN_ADDR = XA;
         if(XCE && XREAD && !XPGM && !XTM) begin
            DQ_temp <= MemoryCell[MAIN_ADDR];
         end
end

always @(negedge XREAD) begin
         DQ_temp <= #0 0;
end

//-------------------- Margin Read Mode operation ------------------------------------------
wire      MarginReadMode;
assign    MarginReadMode = (XCE == 1 && XREAD == 1 && XPGM == 0 && XTM == 1)? 1 : 0;
assign    DQ = DQ_temp;

always @(posedge XREAD) begin                           // Read Status
         MAIN_ADDR = XA;
         if(XCE && XREAD && !XPGM && XTM) begin
            DQ_temp <= MemoryCell[MAIN_ADDR];
         end
end

always @(negedge XREAD) begin
         DQ_temp <= #0 0;
end

//===================================================================================
//  AC Parameter Check
//===================================================================================
	wire StandbyModeCheckEnable ;
	wire ReadModeFunction ;
	wire MarginReadModeFunction ;
	wire ProgramModeCheckEnable ;
	wire ReadModeCheckEnable ;

	assign StandbyModeCheckEnable	= (XCE == 0 && XREAD == 0 && XPGM == 0  && XTM == 0 )? 1 : 0;
	assign ReadModeFunction 	= (XCE == 1 	       	  && XPGM == 0  && XTM == 0 )? 1 : 0;
	assign MarginReadModeFunction 	= (XCE == 1 	          && XPGM == 0  && XTM == 1 )? 1 : 0;
	assign ProgramModeCheckEnable 	= (XCE == 1 && XREAD == 0 	        && XTM == 0 )? 1 : 0;
	assign ReadModeCheckEnable 	= ( ReadModeFunction || MarginReadModeFunction )? 1 : 0;

specify
        // XCE Pin
        //$width(negedge XCE, tCEL);                                     // XCE Deselect Time
        $setup(posedge XCE, posedge XREAD  &&& ReadModeCheckEnable, 	tCEs, Read_Err_ST_tCEs);      // Chip Select Setup Time
        $setup(posedge XCE, posedge XPGM &&& ProgramModeCheckEnable, 	tCEs, Program_Err_ST_tCEs);   // Chip Select Setup Time
        $hold(negedge XREAD  &&& ReadModeCheckEnable, 	 negedge XCE, 	tCEh, Read_Err_HD_tCEh);      // Chip Select Hold Time
        $hold(negedge XPGM &&& ProgramModeCheckEnable, negedge XCE, 	tCEh, Program_Err_HD_tCEh);   // Chip Select Hold Time
                        
        // XA Pin
        $setup(XA, posedge XREAD  &&& ReadModeCheckEnable, 	tADs, Read_Err_ST_tADs);              // Address Setup Time
        $setup(XA, posedge XPGM &&& ProgramModeCheckEnable, 	tADs, Program_Err_ST_tADs);           // Address Setup Time
        $hold(negedge XREAD  &&& ReadModeCheckEnable,    XA, 	tADh, Read_Err_HD_tADh);              // Address Hold Time
        $hold(negedge XPGM &&& ProgramModeCheckEnable, XA, 	tADh, Program_Err_HD_tADh);           // Address Hold Time
        
        // XDIN Pin
        $setup(XDIN, posedge XPGM &&& ProgramModeCheckEnable, tPDs, Program_Err_ST_tPDs);           // Data Setup Time
        $hold(negedge XPGM &&& ProgramModeCheckEnable, XDIN, 	tPDh, Program_Err_HD_tPDh);           // Data Hold Time

        // XPGM pin
        $width (posedge XPGM &&& ProgramModeCheckEnable, 	tPGM_Min, 0, Program_Err_W_tPGM);          // Program Min. Time
	$width (negedge XPGM &&& ProgramModeCheckEnable, 	tPGML, 0, Program_Err_W_tPGM);             // Program Low Pulse Width
        $skew(posedge XPGM &&& ProgramModeCheckEnable, negedge XPGM &&& ProgramModeCheckEnable, tPGM_Max, Program_Err_W_tPGM); // Program Max. Time

        // XREAD pin
        $width(posedge XREAD &&& ReadModeCheckEnable, tRD, 0, Read_Err_W_tRD);                   // Read High Pulse Width
        $width(negedge XREAD &&& ReadModeCheckEnable, tRDL, 0, Read_Err_W_tRD);                  // Read Low Pulse Width
        $period(posedge XREAD &&& ReadModeCheckEnable, tRC);                                     // READ cycle Time

        // DQ
        if(ReadModeCheckEnable==1)
        (posedge XREAD *> (DQ:8'hxx)) = (tAC, tAC); 
endspecify

//===================================================================================
//  Operation Violation display (If Operation Violation occur, Simulation is stopped)
//===================================================================================
always @(posedge XREAD) begin
         if(XCE == 0) $display($time, "#####===== Warning!! You have entered an invalid command!(0) XREAD:High @XCE:Low =====#####");
         if(XCE) begin
            if(XPGM) $display($time, "#####===== Warning!! You have entered an invalid command!(1) XREAD:High @XPGM:High =====#####");
         //$stop;
         end
end

always @(posedge XPGM) begin
         if(XCE == 0) $display($time, "#####===== Warning!! You have entered an invalid command!(2) XPGM:High @XCE:Low =====#####");
         if(XCE) begin
            if(XREAD) $display($time, "#####===== Warning!! You have entered an invalid command!(3) XPGM:High @XREAD:High =====#####");
         //$stop;
         end
end

always @(XA) begin
         if(XCE) begin
            if(XREAD) $display($time, "#####===== Warning!! You have entered an invalid command!(4) XA:Changed @XREAD:High =====#####");
            if(XPGM) $display($time, "#####===== Warning!! You have entered an invalid command!(5) XA:Changed @XPGM:High =====#####");
         //$stop;
         end
end
       
//===================================================================================
//  Timing Violation display (If Timing Violation occur, Simulation is stopped)
//===================================================================================
//--------------------  XPGM signal Width Violation ---------------------------------
always @(Program_Err_W_tPGM) begin
         $display ($time, "#========== XPGM Min./Max. Width Violation Occur at Program Mode  ==========#");
         //$stop;
end

//-------------------- Program Mode Setup Violation ---------------------------------
always @(Program_Err_ST_tCEs) begin
         $display ($time, "#========== XCE Setup Violation Occur at Program Mode ==========#");
         //$stop;
end
always @(Program_Err_ST_tADs) begin
         $display ($time, "#========== XA Setup Violation Occur at Program Mode ==========#");
         //$stop;
end   
always @(Program_Err_ST_tPDs) begin
         $display ($time, "#========== XDIN Setup Violation Occur at Program Mode ==========#");
         //$stop;
end
always @(Program_Err_ST_tADs or Program_Err_ST_tPDs) begin
         for(i = 0; i <= `Word_Depth-1; i = i+1) begin
             MemoryCell[i] = `DATA_BITS'hxx;
         end
end
 
//-------------------- Program Mode Hold Violation ----------------------------------
always @(Program_Err_HD_tCEh) begin
         $display ($time, "#========== XCE Hold Violation Occur at Program Mode ==========#");
         //$stop;
end   
always @(Program_Err_HD_tADh) begin
         $display ($time, "#========== XA Hold Violation Occur at Program Mode ==========#");
         //$stop;
end   
always @(Program_Err_HD_tPDh) begin
         $display ($time, "#========== XDIN Hold Violation Occur at Program Mode ==========#");
         //$stop;
end

//--------------------  XREAD signal Width Violation ---------------------------------
always @(Read_Err_W_tRD) begin
         $display ($time, "#========== XREAD Min. Width Violation Occur at Read Mode ==========#");
         //$stop;
end

//--------------------  Read mode Set-up Violation ----------------------------------
always @(Read_Err_ST_tCEs) begin
         if(XCE && XTM == 0) begin
            $display ($time, "#========== XCE Set-up Violation Occur at Read Mode ==========#");
         end
         //$stop;
end
always @(Read_Err_ST_tADs) begin
         if(XCE && XTM == 0) begin
            $display ($time, "#========== XA Set-up Violation Occur at Read Mode ==========#");
         end
         //$stop;
end

//--------------------  Read mode Hold Violation ------------------------------------
always @(Read_Err_HD_tCEh) begin
         if(XCE && XTM == 0) begin
            $display ($time, "#========== XCE Hold Violation Occur at Read Mode ==========#");
         end
         //$stop;
end
always @(Read_Err_HD_tADh) begin
         if(XCE && XTM == 0) begin
            $display ($time, "#========== XA Hold Violation Occur at Read Mode ==========#");
         end
         //$stop;
end

//--------------------  Margin Read mode Set-up Violation ----------------------------
always @(Read_Err_ST_tCEs) begin
         if(XCE && XTM == 1) begin
            $display ($time, "#========== XCE Set-up Violation Occur at Margin Read Mode ==========#");
         end
         //$stop;
end
always @(Read_Err_ST_tADs) begin
         if(XCE && XTM == 1) begin
            $display ($time, "#========== XA Set-up Violation Occur at Margin Read Mode ==========#");
         end
         //$stop;
end

//--------------------  Margin Read mode Hold Violation ------------------------------
always @(Read_Err_ST_tCEs) begin
         if(XCE && XTM == 1) begin
            $display ($time, "#========== XCE Hold Violation Occur at Margin Read Mode ==========#");
         end
         //$stop;
end
always @(Read_Err_HD_tADh) begin
         if(XCE && XTM == 1) begin
            $display ($time, "#========== XA Hold Violation Occur at Margin Read Mode ==========#");
         end
         //$stop;
end

endmodule





