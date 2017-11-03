//------------------------------------------------------------------------
// D Flip Flop
//   Positive edge triggered
//   If writeEnable is true, q is equal to d 
//   otherwise, q holds its previous value
//------------------------------------------------------------------------

module dflipflop
(
    input d,
    input writeEnable,
    input clk,
    output reg q
);

    always @(posedge clk) begin
        if(writeEnable) begin
            q <= d;
        end
    end

endmodule