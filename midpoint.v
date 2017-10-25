//------------------------------------------------------------------------
// Midpoint module
//------------------------------------------------------------------------
`include "shiftregister.v"
`include "inputconditioner.v"

module Midpoint(
		input [1:0] sw,
		input btn,
		output [3:0] led
	);
	reg             clk;
    wire             peripheralClkEdge;
    wire             parallelLoad;
    wire[7:0]       parallelDataOut;
    wire            serialDataOut;
    wire[7:0]        parallelDataIn;

    reg pin;
    wire conditioned;
    wire rising;
    wire falling;
    
    assign parallelDataIn = 8'b10011001;
    // Instantiate with parameter width = 8
    shiftregister #(8) sr1(.clk(clk), 
    		           .peripheralClkEdge(peripheralClkEdge),
    		           .parallelLoad(parallelLoad), 
    		           .parallelDataIn(parallelDataIn), 
    		           .serialDataIn(serialDataIn), 
    		           .parallelDataOut(parallelDataOut), 
    		           .serialDataOut(serialDataOut));
    
    inputconditioner ICParallelLoad(.clk(clk),
    			 .noisysignal(btn),
			 .conditioned(),
			 .positiveedge(),
			 .negativeedge(parallelLoad));

    inputconditioner ICSerialIn(.clk(clk),
    			 .noisysignal(sw[0]),
			 .conditioned(serialDataIn),
			 .positiveedge(),
			 .negativeedge());

    inputconditioner ICPerfClock(.clk(clk),
    			 .noisysignal(sw[1]),
			 .conditioned(),
			 .positiveedge(peripheralClkEdge),
			 .negativeedge());

    // Generate clock (50MHz)
    initial clk = 0;
    always #10 clk=!clk;  // 50MHz Clock

endmodule