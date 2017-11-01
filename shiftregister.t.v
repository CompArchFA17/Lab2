//------------------------------------------------------------------------
// Shift Register test bench
//------------------------------------------------------------------------
`timescale 1 ns / 1 ps
`include "shiftregister.v"
module testshiftregister();

    reg             clk;
    reg             peripheralClkEdge;
    reg             parallelLoad;
    wire[7:0]       parallelDataOut;
    wire            serialDataOut;
    reg[7:0]        parallelDataIn;
    reg             serialDataIn; 
    
    // Instantiate with parameter width = 8
    shiftregister #(8) dut(.clk(clk), 
                       .peripheralClkEdge(peripheralClkEdge),
                       .parallelLoad(parallelLoad), 
                       .parallelDataIn(parallelDataIn), 
                       .serialDataIn(serialDataIn), 
                       .parallelDataOut(parallelDataOut), 
                       .serialDataOut(serialDataOut));
    
    initial clk=0;
    always #10 clk=!clk;

    initial begin
        // Your Test Code
        $dumpfile("shiftregister.vcd");
        $dumpvars(0, testshiftregister);
        
        // Parallel mode Test
        $display("Testing parallel mode");
        $display("ParallelDataOut  |  Expected Result");
        peripheralClkEdge=0;parallelLoad=1;parallelDataIn=8'b00000000;serialDataIn=1; #50
        $display("%b |  %b", parallelDataOut, parallelDataIn);

        parallelLoad=0;parallelDataIn=8'b11111111;serialDataIn=0; #50
        $display("%b |  00000000", parallelDataOut, parallelDataIn);
        parallelLoad=1; #50
        $display("%b |  %b", parallelDataOut, parallelDataIn);
        
        parallelDataIn=8'b00110110;serialDataIn=0; #50
        $display("%b |  %b", parallelDataOut, parallelDataIn);

        parallelLoad=0; #30

        // Serial mode Test
        $display("Testing serial mode");
        $display("ParallelDataOut  serialDataOut  |  Expected Result");
        peripheralClkEdge=1;serialDataIn = 1; #20
        $display("%b         %b      |  01101101  0", parallelDataOut, serialDataOut);
        peripheralClkEdge=0;serialDataIn = 0; #20
        $display("%b         %b      |  01101101  0", parallelDataOut, serialDataOut);

        peripheralClkEdge=1; #20
        $display("%b         %b      |  11011010  0", parallelDataOut, serialDataOut);
        peripheralClkEdge=0; #20

        peripheralClkEdge=1;serialDataIn = 0; #20
        $display("%b         %b      |  10110100  1", parallelDataOut, serialDataOut);
        peripheralClkEdge=0;
        
    end
