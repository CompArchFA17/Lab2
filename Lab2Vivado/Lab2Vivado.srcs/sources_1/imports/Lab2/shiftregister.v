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
		//parallelDataOut <= shiftregistermem;

	end

	if(parallelLoad ==0) begin   // We are deciding that parallelLoad will win. This takes priority over serial shift - peripheralClkEdge only matters if parallelLoad = 0.
		if (peripheralClkEdge == 1) begin

			shiftregistermem[1] <= shiftregistermem[0];
			shiftregistermem[2] <= shiftregistermem[1];
			shiftregistermem[3] <= shiftregistermem[2];
			shiftregistermem[4] <= shiftregistermem[3];
			shiftregistermem[5] <= shiftregistermem[4];
			shiftregistermem[6] <= shiftregistermem[5];
			shiftregistermem[7] <= shiftregistermem[6];
			shiftregistermem[0] <= serialDataIn;
			//shiftregistermem <= {{shiftregistermem[width-2:0]}, {serialDataIn}};
		end
		parallelDataOut <= shiftregistermem;

	end

end

endmodule

// general thoughts: make a loop that happens width # of times, 
// and then use the idea behind the behavioral flip flop below  
// so that you can pass things along as needed. 

// from the assignment: 
// " Each of these four behaviors can be implemented in one or two lines of behavioral Verilog. 
// You may want to look at Verilog's {} concatenate syntax for implementing the serial behavior. "


/*module flipflop
(
output reg  q,
input       d,
input       wrenable,
input       clk
);
    always @(posedge clk) begin
        if(wrenable) begin
            q = d;
        end
    end
endmodule */


