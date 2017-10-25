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
output reg             serialDataOut       // Positive edge synchronized
);

    reg [width-1:0]      shiftregistermem;

    always @(posedge clk) begin

        if(parallelLoad==1) begin
        // load the register with parallelDataIn
        	shiftregistermem <= parallelDataIn;
        end

        else if(parallelLoad==0) begin
        	if(peripheralClkEdge==1) begin
        	//grab the MSB as SDO and then shift everything over 1 place
        	    serialDataOut <= shiftregistermem[width-1];
        		shiftregistermem<={shiftregistermem[width-2:0],serialDataIn};
        	end	
        end
        //parallelDataOut is just the current state of the register
        parallelDataOut <= shiftregistermem;

    end
endmodule
