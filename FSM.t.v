`timescale 1 ns/ 1 ps
`include "FSM.v"

module FSMtest();

    reg             clk;
    reg             SCLKEdge;
    reg             ChipSelCond;
	reg 			shiftRegOutPZero;
	wire 			MISO_BUFE;
	wire 			DM_WE;
	wire 			ADDR_WE;
	wire			SR_WE;
//	wire			counter;

FSM trial1(clk, SCLKEdge, ChipSelCond, shiftRegOutPZero, MISO_BUFE, DM_WE, ADDR_WE, SR_WE);

    initial clk=0;
    always #10 clk=!clk;    // 50MHz Clock  



initial begin

$dumpfile("FSM.vcd");
$dumpvars();

// trial 1. Chip Sel = 1, SCLKEdge = 1, everything else should be zero.
$display("CS | MISO_BUFE 	| DM_WE | ADDR_WE 	| SR_WE");
ChipSelCond = 1; SCLKEdge = 1; #200
$display("%b  | %b		| %b 	| %b 		| %b ", ChipSelCond, MISO_BUFE, DM_WE, ADDR_WE, SR_WE);


// trial 2. Chip Sel = 0, SCLKEdge = 1, shiftRegOutPZero = 0 (write), everything else is zero
ChipSelCond = 0; SCLKEdge = 1; shiftRegOutPZero = 0; #200
$display("%b  | %b		| %b 	| %b 		| %b ", ChipSelCond, MISO_BUFE, DM_WE, ADDR_WE, SR_WE);

// intermediate. Chip Sel = 1, SCLKEdge = 1, shiftRegOutPZero = 1 (read), everything else is zero
ChipSelCond = 1; SCLKEdge = 1; shiftRegOutPZero = 1; #200
$display("%b  | %b		| %b 	| %b 		| %b ", ChipSelCond, MISO_BUFE, DM_WE, ADDR_WE, SR_WE);


// trial 3. Chip Sel = 0, SCLKEdge = 1, shiftRegOutPZero = 1 (read), everything else is zero
ChipSelCond = 0; SCLKEdge = 1; shiftRegOutPZero = 1; #200
$display("%b  | %b		| %b 	| %b 		| %b ", ChipSelCond, MISO_BUFE, DM_WE, ADDR_WE, SR_WE);

$finish;
end


endmodule
