// USING SHIFT REGISTER FROM LISA'S 2016 REPOSITORY
//------------------------------------------------------------------------
// Shift Register
//   Parameterized width (in bits)
//   Shift register can operate in two modes:
//      - serial in, parallel out
//      - parallel in, serial out
//------------------------------------------------------------------------
`timescale 1 ns / 1 ps
//`include "inputconditioner.v"

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

    reg [width-1:0] shiftregistermem;
    //wire conditioned;
    //wire positiveedge;
    //wire negativeedge;
    //inputconditioner inputc(clk, peripheralClkEdge, conditioned, positiveedge, negativeedge);

    always @(posedge parallelLoad) begin
	shiftregistermem <= parallelDataIn;
    end

    always @(posedge clk) begin
        // Parallel load will happen if parallel load is high.
        // this takes priority over the serial shift
       // if (parallelLoad) begin // Parallel
         //   shiftregistermem <= parallelDataIn;
        //end
        //the shift register advances one position: serialDataIn is loaded into the LSB (Least Significant Bit), and the rest of the bits shift up by one
        //else begin
            if (peripheralClkEdge) begin
        	shiftregistermem <= {{shiftregistermem[width-2:0]}, {serialDataIn}};
            end
        //end


        //serialDataOut always presents the Most Significant Bit of the shift register.
        serialDataOut <= shiftregistermem[width-1];
        //parallelDataOut always presents the entirety of the contents of the shift register.
        parallelDataOut <= shiftregistermem;

    end
endmodule
