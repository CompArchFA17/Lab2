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
        peripheralClkEdge=1;parallelLoad=1;parallelDataIn=8'b01110101;serialDataIn=0; #50
        $display("testing serial outputs");
        peripheralClkEdge=0; parallelLoad=0; #10
        peripheralClkEdge=1;
        
    end

endmodule

