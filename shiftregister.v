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
output [width-1:0]  parallelDataOut,    // Shift reg data contents
output              serialDataOut       // Positive edge synchronized
);

	reg [width-1:0]      shiftregistermem;
  always @((posedge peripheralClkEdge && clk)|| (posedge clk && peripheralClkEdge)) begin
		shiftregistermem << 1;
      	shiftregistermem[0]=serialDataIn;
    	serialDataOut=shiftregistermem[width-1];
    	parallelDataOut=shiftregistermem;
  	end
    always @(posedge clk) begin
        // handle parallel load
      if (parallelLoad) begin
        shiftregistermem = parallelDataIn;
      end
      // output serial and parallel
      parallelDataOut = shiftregistermem;
      serialDataOut = shiftregistermem[width - 1];
    end
endmodule
