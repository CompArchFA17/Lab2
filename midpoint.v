//midpoint check-in top-level module
//3 input conditioners input to a shift register

`timescale 1ns / 1ps
`include "inputconditioner.v"
`include "shiftregister.v"

module midpoint

input butn0;
input switch0;
input switch1;
input xA5;
input clk;
output LEDs;
)
wire sout;

inputconditioner IR0(condit0,posedge0,negedge0,clk,butn0); //parallel in
inputconditioner IR1(condit1,posedge1,negedge1,clk,switch0); //MOSI
inputconditioner IR2(condit2,posedge2,negedge2,clk,switch1); //sclock

shiftregister SR(LEDs,sout,clk,posedge2,negedge0,xA5,condit1);


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
//   Interfaces with switches, buttons, and LEDs on ZYBO board. Allows for two
//   4-bit operands to be stored, and two results to be alternately displayed
//   to the LEDs.
//--------------------------------------------------------------------------------





module lab0_wrapper
(
    input        clk,
    input  [3:0] sw,
    input  [3:0] btn,
    output [3:0] led
);

	
endmodule