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
wire [size-2:0] dataMemOut;
reg MISO_BUFE;
reg DM_WE;
reg ADDR_WE;
reg SR_WE;

inputconditioner serialInCond(clk, mosi_pin, MOSI, positiveedge0, negativeedge0); // MOSICond is cleaned up MOSI / Serial In

inputconditioner SCLKCond(clk, sclk_pin, conditioned1, SCLKEdge, negativeedge1); // positive edge is your cleaned up SCLKEdge

inputconditioner ChipSelCond(clk, cs_pin, ChipSel, positiveedge2, negativeedge2); // conditioned2 is your cleaned up Chip Select


datamemory data(clk, dataMemOut, address, DM_WE, shiftRegOutP);

dff8 DFFAddr(clk, ADDR_WE, shiftRegOutP, address);

dff DFFMISO(clk, negativeedge1, MISO, MISO_PreBuff);

shiftregister SPIShift(clk, SCLKEdge, SR_WR, dataMemOut, MOSI, shiftRegOutP, MISO);
 
FSM SPIFSM(clk, SCLKEdge, ChipSel, shiftRegOutP[0], MISO_BUFE, DM_WE, ADDR_WE, SR_WE);



// current problem. certain things only happen for the second set of 8 bits (or whatever). need counters? 
// Not using things properly :(

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

module dff8 #( parameter W = 8 )
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


