// 32-bit alu testbench

//`timescale 1 ns / 1 ps
`include "finiteStateMachine.v"

module testFSM();
    
    reg clk;
    reg chipSelect;
    reg rw_select;

    wire MISObuff, memWE, addrWE, srWE;

    fsm test(MISObuff, memWE, addrWE, srWE, clk, chipSelect, rw_select);

    // generate clock
    initial clk = 0;
    always #10 clk = !clk; //50 MHz clock

    initial
	#1000 $finish;

    initial begin
	$dumpfile("fsm.vcd");
	$dumpvars();

        $display(" chip select | read/write | MISObuff | memWE | addrWE | srWE | state");
	$display();
	$display("Chip Not Selected -------------------------------------------------------------------------------------");
	chipSelect=1; rw_select=0;
        #30;
        $display("|     %b      |     %b      |     %b    |   %b   |    %b   |  %b   |   %b", chipSelect, rw_select, MISObuff, memWE, addrWE, srWE, test.state);
	$display("Chip Not Selected -------------------------------------------------------------------------------------");
	chipSelect=1; rw_select=1;
        #20;
        $display("|     %b      |     %b      |     %b    |   %b   |    %b   |  %b   |   %b", chipSelect, rw_select, MISObuff, memWE, addrWE, srWE, test.state);
	$display("Chip Selected: 1 clk cycle read -------------------------------------------------------------------------------------");
	chipSelect=0; rw_select=1;
        #30;
        $display("|     %b      |     %b      |     %b    |   %b   |    %b   |  %b   |   %b", chipSelect, rw_select, MISObuff, memWE, addrWE, srWE, test.state);
	$display("Chip Selected: 7 clk cycles read -------------------------------------------------------------------------------------");
        #120;
        $display("|     %b      |     %b      |     %b    |   %b   |    %b   |  %b   |   %b", chipSelect, rw_select, MISObuff, memWE, addrWE, srWE, test.state);
	$display("Chip Selected: 9 clk cycles read -------------------------------------------------------------------------------------");
        #40;
        $display("|     %b      |     %b      |     %b    |   %b   |    %b   |  %b   |   %b", chipSelect, rw_select, MISObuff, memWE, addrWE, srWE, test.state);
	$display("Chip Not Selected -------------------------------------------------------------------------------------");
	#130;
	chipSelect=1; rw_select=0;
        #20;
        $display("|     %b      |     %b      |     %b    |   %b   |    %b   |  %b   |   %b", chipSelect, rw_select, MISObuff, memWE, addrWE, srWE, test.state);
	$display("Chip Selected: 1 clk cycle write -------------------------------------------------------------------------------------");
	chipSelect=0; rw_select=0;
        #30;
        $display("|     %b      |     %b      |     %b    |   %b   |    %b   |  %b   |   %b", chipSelect, rw_select, MISObuff, memWE, addrWE, srWE, test.state);
	$display("Chip Selected: 7 clk cycles write -------------------------------------------------------------------------------------");
        #120;
        $display("|     %b      |     %b      |     %b    |   %b   |    %b   |  %b   |   %b", chipSelect, rw_select, MISObuff, memWE, addrWE, srWE, test.state);
	$display("Chip Selected: 9 clk cycles write -------------------------------------------------------------------------------------");
        #40;
        $display("|     %b      |     %b      |     %b    |   %b   |    %b   |  %b   |   %b", chipSelect, rw_select, MISObuff, memWE, addrWE, srWE, test.state);
	$display("Chip Selected: 16 clk cycles write -------------------------------------------------------------------------------------");
        #140;
        $display("|     %b      |     %b      |     %b    |   %b   |    %b   |  %b   |   %b", chipSelect, rw_select, MISObuff, memWE, addrWE, srWE, test.state);
	$display("Chip Selected: 20 clk cycles write -------------------------------------------------------------------------------------");
        #220;
        $display("|     %b      |     %b      |     %b    |   %b   |    %b   |  %b   |   %b", chipSelect, rw_select, MISObuff, memWE, addrWE, srWE, test.state);
    end

endmodule

