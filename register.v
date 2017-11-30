module register
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
endmodule

module addresslatch
#(
    parameter width  = 8
)
(
output reg[width-1:0]  	q,
input[width-1:0] 		d,
input	 				wrenable,
input       			clk
);
    always @(posedge clk) begin
        if(wrenable) begin
            q = d;
        end
    end
endmodule

