`include "inputconditioner.v"
`include "finiteStateMachine.v"
`include "datamemory.v"
`include "shiftregister.v"
`include "testAnd.v"

module bufferSwitch
(
    input buff_in,
    input buff_enable,
    output buff_out
);
    wire buff_out;
    and bufenable(buff_out, buff_enable, buff_in);
endmodule

module dff
(
    input d,
    //input ce,
    input clk,
    output reg q
);
    always @(posedge clk) begin
        //if (ce == 1) begin
            q <= d;
        //end
    end
endmodule

module dff7Bit
(
    input [6:0] d,
    //input ce,
    input clk,
    output reg [6:0] q
);
    always @(posedge clk) begin
        //if (ce == 1) begin
            q <= d;
        //end
    end
endmodule


//------------------------------------------------------------------------
// SPI Memory
//------------------------------------------------------------------------
module spiMemory
(
    input           clk,        // FPGA clock
    input           sclk_pin,   // SPI clock
    input           cs_pin,     // SPI chip select
    output          miso_pin,   // SPI master in slave out
    input           mosi_pin,   // SPI master out slave in
    output [3:0]    leds        // LEDs for debugging
);
    
    wire mosi_rising, mosi_falling, mosi_conditioned;
    wire sclk_rising, sclk_falling, sclk_conditioned;
    wire cs_rising, cs_falling, cs_conditioned;
    wire [7:0] parallelMemToSR, parallelSRtoMem;
    wire serialOut, parallelLoad;
    wire [6:0] address;
    wire MISObuff, memWE, addrWE, srWE;
	wire miso_pin_pre_buffer;
	
    //and buffswitch0(miso_pin, miso_pin_pre_buffer, MISObuff);

	inputconditioner mosiIC(clk, mosi_pin, mosi_conditioned, mosi_rising, mosi_falling);
	inputconditioner csIC(clk, cs_pin, cs_conditioned, cs_rising, cs_falling);
	inputconditioner sclkIC(clk, sclk_pin, sclk_conditioned, sclk_rising, sclk_falling);

    shiftregister shifreg(clk, sclk_falling, srWE, parallelMemToSR, mosi_conditioned, parallelSRtoMem, serialOut);

    datamemory memory1(clk, parallelMemToSR, address, memWE, parallelSRtoMem);
	
	dff dff1(serialOut, sclk_falling, miso_pin);
    dff7Bit dff2(parallelSRtoMem[6:0], addrWE, address);

    fsm fsm1( MISObuff, memWE, addrWE, srWE, sclk_rising, sclk_falling, cs_falling, mosi_conditioned);
endmodule
