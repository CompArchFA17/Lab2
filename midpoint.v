//------------------------------------------------------------------------
// Midpoint module
//------------------------------------------------------------------------

// JK flip-flop
module jkff1
(
    input trigger,
    input j,
    input k,
    output reg q
);
    always @(posedge trigger) begin
        if(j && ~k) begin
            q <= 1'b1;
        end
        else if(k && ~j) begin
            q <= 1'b0;
        end
        else if(k && j) begin
            q <= ~q;
        end
    end
endmodule

// Two-input MUX with parameterized bit width (default: 1-bit)
module mux2 #( parameter W = 1 )
(
    input[W-1:0]    in0,
    input[W-1:0]    in1,
    input           sel,
    output[W-1:0]   out
);
    // Conditional operator - http://www.verilog.renerta.com/source/vrg00010.htm
    assign out = (sel) ? in1 : in0;
endmodule


module Midpoint(
        input clk,
		input [1:0] sw,
		input[3:0] btn,
		output [3:0] led
	);
    wire             peripheralClkEdge;
    wire             parallelLoad;
    wire            serialDataIn;
    wire[7:0]       parallelDataOut;
    wire            serialDataOut;
    wire[7:0]        parallelDataIn;
    wire[3:0]  res0, res1;
    wire res_sel;

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
    			 .noisysignal(btn[0]),
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

    assign res0 = parallelDataOut[3:0];
    assign res1 = parallelDataOut[7:4];

    // Capture button input to switch which MUX input to LEDs
    jkff1 src_sel(.trigger(clk), .j(btn[3]), .k(btn[2]), .q(res_sel));
    mux2 #(4) output_select(.in0(res0), .in1(res1), .sel(res_sel), .out(led));

endmodule
