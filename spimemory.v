//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------

`timescale 1 ns / 1 ps
`include "FSM.v"
`include "datamemory.v"

module spiMemory
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output          miso_pin,   // SPI master in slave out
    input           mosi_pin,   // SPI master out slave in
    output [3:0]    leds        // LEDs for debugging
);
parameter size = 8; // for now

// MOSI conditioned variables
wire MOSI;
wire positiveedge0;
wire negativeedge0;

// SCLK conditioned variables
wire conditioned1;
wire SCLKEdge;
wire negativeedge1;

// Chip Select conditioned variables
wire ChipSel;
wire positiveedge2;
wire negativeedge2;

// Other variables
wire MISO;
wire MISO_PreBuff;
wire [size-1:0] shiftRegOutP;
wire [6:0] address;
wire [size-1:0] dataMemOut;
wire MISO_BUFE;
wire DM_WE;
wire ADDR_WE;
wire SR_WE;

// parameter counterwidth = 5; // Counter size, in bits, >= log2(waittime)
// reg[counterwidth-1:0] counter = 0;

inputconditioner serialInCond(clk, mosi_pin, MOSI, positiveedge0, negativeedge0); // MOSICond is cleaned up MOSI / Serial In

inputconditioner SCLKCond(clk, sclk_pin, conditioned1, SCLKEdge, negativeedge1); // positive edge is your cleaned up SCLKEdge

inputconditioner ChipSelCond(clk, cs_pin, ChipSel, positiveedge2, negativeedge2); // conditioned2 is your cleaned up Chip Select

	shiftregister SPIShift(clk, SCLKEdge, SR_WE, dataMemOut, MOSI, shiftRegOutP, MISO);

	dffADDR DFFAddr(clk, ADDR_WE, shiftRegOutP[7:1], address); 

	FSM SPIFSM(clk, SCLKEdge, ChipSel, shiftRegOutP[0], MISO_BUFE, DM_WE, ADDR_WE, SR_WE); 

	dff DFFMISO(clk, negativeedge1, MISO, MISO_PreBuff);

	datamemory data(clk, dataMemOut, address, DM_WE, shiftRegOutP);

	bufif1 covefefe(miso_pin, MISO_PreBuff, MISO_BUFE);

endmodule
   

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

module dffADDR #( parameter W = 7 )
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


