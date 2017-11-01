//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------
`timescale 1ns / 1ps
`include "inputconditioner.v"
`include "fsm.v"
`include "datamemory.v"
`include "shiftregister.v"

module addressLatch
(
input CE,
input [6:0]D,
input C,
output reg [6:0]Q
);
always @(posedge C) begin
	if (CE==1)
	Q[6:0]<=D[6:0];
end
endmodule


module dff(
input D,
output reg Q,
input CE,
input C
);
always @(posedge C) begin
	if (CE==1)
		begin Q<=D; end
	end
endmodule

module spiMemory
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output          miso_pin,   // SPI master in slave out
    input           mosi_pin,   // SPI master out slave in
    output [3:0]    leds        // LEDs for debugging
);
wire [7:0] shiftRegOutP;
wire [7:0] DataMemOut;
wire [6:0] address;

//input conditioners
inputconditioner ic0(clk,mosi_pin, SerialIn,posedge0,negedge0);
inputconditioner ic1(clk,sclk_pin, cond0, ClkEdge, CEDFF);
inputconditioner ic2(clk,cs_pin, cs, posedge1,negedge1);

//FSM
fsm fsm0(shiftRegOutP[0],cs,ClkEdge,clk,MISOBUFE,DM_WE,ADDR_WE,SR_WE);

//shift register
shiftregister sr0(clk,ClkEdge,SR_WE,DataMemOut[7:0],SerialIn, shiftRegOutP[7:0],D0);

//data memory
datamemory dm0(clk,DataMemOut[7:0],address[6:0],DM_WE,shiftRegOutP[7:0]);

//address latch
addressLatch aL0(ADDR_WE,shiftRegOutP[6:0],clk,address[6:0]);

//dff
dff dff0(D0,Q0,CEDFF,clk);

//miso buffer
bufif1(miso_pin,Q0,MISO_BUFE);

endmodule