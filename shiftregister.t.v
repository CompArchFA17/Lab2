//------------------------------------------------------------------------
// Shift Register test bench
//------------------------------------------------------------------------
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
    always #10 clk=!clk;    // 50MHz Clock

    initial begin
        $display("Tests of parallel in, serial out");
        $display("parallelLoad | parallelDataIn | serialDataOut|");
        // test of parallelLoad = 1
        parallelLoad = 1; parallelDataIn = 8'b11110000; #20
        $display("      %b      |    %b    |       %b      |", parallelLoad, parallelDataIn, serialDataOut);

    end

endmodule