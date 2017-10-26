//midpoint check-in top-level module
//3 input conditioners input to a shift register

`timescale 1ns / 1ps
`include "inputconditioner.v"
`include "shiftregister.v"

module midpoint
(
input butn0,
input switch0,
input switch1,
input[7:0] xA5,
input clk,
output [7:0] LEDs
);
wire sout;
wire peripheralClockEdge;
wire parallelLoad;
wire serialIn;
inputconditioner IR0(clk, butn0, condit0,posedge0,parallelLoad); //parallel in
inputconditioner IR1(clk, switch0, serialIn,posedge1,negedge1); //MOSI
inputconditioner IR2(clk,switch1, condit2,peripheralClockEdge,negedge2); //sclock

shiftregister SR(clk, peripheralClockEdge, parallelLoad, xA5, serialIn, LEDs[7:0], sout);


endmodule

//--------------------------------------------------------------------------------
// Lab 2 building block modules
//   D flip flop, JK Flip flop, MUX
//--------------------------------------------------------------------------------
module dff #( parameter W = 1 )
(
    input trigger,
    input enable,
    input      [W-1:0] d,
    output reg [W-1:0] q
);
    always @(posedge trigger) begin
        if(enable) begin
            q <= d;
        end 
    end
endmodule

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

//--------------------------------------------------------------------------------
// Main Lab 2 wrapper module
//   Interfaces with switches, buttons, and LEDs on ZYBO board. 
//--------------------------------------------------------------------------------

module lab0_wrapper
(
    input        clk,
    input  [3:0] sw,
    input  [3:0] btn,
    output [7:0] je

    //inputs utilized for the are clk, sw0&sw1, and btn0
  //buttons 2 and 3 switch between res0 and res1 displays :)
);

  //wire[3:0] res0, res1;     // Output display options (res0 is least sig. res1 is most sig figs)
	//wire res_sel;             // Select between display options
  //wire[7:0] LEDout;
	// Capture button input to switch which MUX input to LEDs
	//jkff1 src_sel(.trigger(clk), .j(btn[3]), .k(btn[2]), .q(res_sel));
	//mux2 #(4) output_select(.in0(res0), .in1(res1), .sel(res_sel), .out(led));
  
  midpoint mid(btn[0], sw[0],sw[1], 8'b10100101, clk, je[7:0]);
  
  // assign res0[3:0]= LEDout[7:4]; //least significant
  // assign res1[3:0]=LEDout[3:0]; //most significant
  
endmodule
 
