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

    reg [width-1:0]      data;

    always @(posedge clk) begin
        if (peripheralClkEdge) begin
        	data <= {data << 1, serialDataIn};
        end
        if (parallelLoad) begin
        	data <= parallelDataIn;
        end
        serialDataOut <= data[width - 1];
        parallelDataOut <= data;
    end


endmodule
