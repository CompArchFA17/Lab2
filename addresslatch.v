//------------------------------------------------------------------------
// Address Latch
//   Positive edge triggered
//   If writeEnable is true, addressOut is equal to addressIn 
//   otherwise, addressOut holds its previous value
//------------------------------------------------------------------------

module addresslatch
#(
    parameter width  = 7
)
(
    input [width-1:0] addressIn,
    input writeEnable,
    input clk,
    output reg [width-1:0] addressOut
);

    always @(posedge clk) begin
        if(writeEnable) begin
            addressOut[width-1:0] <= addressIn[width-1:0];
        end
    end

endmodule
