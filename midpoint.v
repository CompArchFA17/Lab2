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
inputconditioner IR0(condit0,posedge0,parallelLoad,clk,butn0); //parallel in
inputconditioner IR1(serialIn,posedge1,negedge1,clk,switch0); //MOSI
inputconditioner IR2(condit2,peripheralClockEdge,negedge2,clk,switch1); //sclock

shiftregister SR(clk, peripheralClockEdge, parallelLoad, xA5, serialIn, LEDs[7:0], sout);


endmodule
