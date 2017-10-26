// Midpoint deliverable file
/*
`include "inputconditioner.v"
`include "shiftregister.v"
*/

//------------------------------------------------------------------------
// Input Conditioner
//    1) Synchronizes input to clock domain
//    2) Debounces input
//    3) Creates pulses at edge transitions
//------------------------------------------------------------------------
// 50 MHz is 2 * 1-^-8 seconds per cycle 

module inputconditioner
(
input 	    clk,            // Clock domain to synchronize input to
input	    noisysignal,    // (Potentially) noisy input signal
output reg  conditioned,    // Conditioned output signal
output reg  positiveedge,   // 1 clk pulse at rising edge of conditioned
output reg  negativeedge    // 1 clk pulse at falling edge of conditioned
);

    parameter counterwidth = 3; // Counter size, in bits, >= log2(waittime) (maybe this could be 2 since 2^2 > 3)
    parameter waittime = 3;     // Debounce delay, in clock cycles
    
    reg[counterwidth-1:0] counter = 0;
    reg synchronizer0 = 0;
    reg synchronizer1 = 0;	// you need 2 synchronizers so you can calculate + and - edge 
  
always @(posedge clk ) begin
    
if(conditioned == synchronizer1)
	counter <= 0;
else begin
	if(counter == waittime) begin 
		counter <= 0;
		conditioned <= synchronizer1;
		if(conditioned == 0 & synchronizer1 ==1) 
			positiveedge <= 1;	
		if(conditioned == 1 & synchronizer1 ==0) 
			negativeedge <= 1; 		
	end
	else 
		counter <= counter+1;
end  				// end to the else begin statement

if(positiveedge == 1)
	positiveedge <= 0;	
if(negativeedge == 1)
	negativeedge <= 0;	

synchronizer0 <= noisysignal;  		// these happen every time there's a clk edge 
synchronizer1 <= synchronizer0;
end

endmodule

//------------------------------------------------------------------------
// Shift Register
//   Parameterized width (in bits)
//   Shift register can operate in two modes:
//      - serial in, parallel out
//      - parallel in, serial out
//------------------------------------------------------------------------

module shiftregister
#(parameter width = 8)
(
input               clk,                // FPGA Clock
input               peripheralClkEdge,  // Edge indicator
input               parallelLoad,       // 1 = Load shift reg with parallelDataIn
input  [width-1:0]  parallelDataIn,     // Load shift reg in parallel
input               serialDataIn,       // Load shift reg serially
output reg [width-1:0]  parallelDataOut,    // Shift reg data contents
output reg          serialDataOut       // Positive edge synchronized
);

reg [width-1:0]      shiftregistermem;

//wire serialDataOut;

always @(posedge clk) begin
    
	if(parallelLoad ==1) begin  // do thisfor parallel data in

		shiftregistermem <= parallelDataIn;
		serialDataOut <= shiftregistermem[width-1];
	end

	else if(parallelLoad ==0) begin   // We are deciding that parallelLoad will win. This takes priority over serial shift - peripheralClkEdge only matters if parallelLoad = 0.
		if (peripheralClkEdge == 1) begin

			shiftregistermem <= {shiftregistermem[width-2:0], serialDataIn};
		parallelDataOut <= shiftregistermem;

		end
	end

end

endmodule









module midpoint
#(parameter width = 8)
(
input		switch0, // SerialDataIn
input 		switch1, // peripheralClkEdge
input 		button,  // ParallelLoad
input 		clk,
input [width-1:0]	parallelDataIn,
output [width-1:0] 	parallelDataOut2,
output wire serialDataOut
);

wire conditioned0;
wire positiveedge0;
wire negativeedge0;

wire conditioned1;
wire positiveedge1;
wire negativeedge1;

wire conditioned2;
wire positiveedge2;
wire negativeedge2;



inputconditioner parallelLoadCond(clk, button, conditioned0, positiveedge0, negativeedge0); // negativeedge0 is your cleaned up button/ParallelLoad

inputconditioner serialInCond(clk, switch0, conditioned1, positiveedge1, negativeedge1); // conditioned1 is your cleaned up SerialDataIn

inputconditioner SCLKCond(clk, switch1, conditioned2, positiveedge2, negativeedge2); // positiveedge2 is your cleaned up peripheralClkEdge

shiftregister shift(clk, positiveedge2, negativeedge0, parallelDataIn, switch0, parallelDataOut2, serialDataOut);


endmodule

/*
module forTesting();
	midpoint mid(.switch0(sw[0]), .switch1(sw[1]), .button(btn[0]), .clk(clk), .parallelDataIn(parallelDataIn), .parallelDataOut2(res), .serialDataOut(serialOut));

endmodule*/

