// midpoint tests the

`include "inputconditioner.v"
`include "shiftregister.v"

module midpoint
(
input clk,
input btn,
input [1:0] sw,
output [7:0] je
);
    wire neg_edg, pos_edg, srl_in;
    inputconditioner i1 (clk, btn, , , neg_edg);
    inputconditioner i2 (clk, sw[0], srl_in, , );
    inputconditioner i3 (clk, sw[1], , pos_edg, );

    shiftregister shft(clk, pos_edg, neg_edg, 8'hA5, srl_in, je, );
endmodule
