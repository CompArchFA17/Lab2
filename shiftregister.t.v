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
    
    // Generate clock (50MHz)
    initial clk=0;
    always #10 clk=!clk;    // 50MHz Clock

    initial begin
        $display("Tests of parallel in, serial out");
        $display("parallelLoad | parallelDataIn | serialDataOut |");
        // test of parallelLoad = 1
        parallelLoad = 1; parallelDataIn = 8'b11110000; #150
        $display("      %b      |    %b    |       %b       |", parallelLoad, parallelDataIn, serialDataOut);
        parallelLoad = 0; parallelDataIn = 8'b00000000; #150
        $display("      %b      |    %b    |       %b      |", parallelLoad, parallelDataIn, serialDataOut);
        $display("----------------------------------------------");
        $display("Tests of serial in, parallel out");
        $display("peripheralClkEdge | serialDataIn | parallelDataOut |");
        peripheralClkEdge = 1; serialDataIn = 1; #20
        $display("        %b         |       %b      |     %b    |", peripheralClkEdge, serialDataIn, parallelDataOut);
        peripheralClkEdge = 0; serialDataIn = 1; #20
        $display("        %b         |       %b      |     %b    |", peripheralClkEdge, serialDataIn, parallelDataOut);
        peripheralClkEdge = 1; serialDataIn = 1; #20
        $display("        %b         |       %b      |     %b    |", peripheralClkEdge, serialDataIn, parallelDataOut);
        // peripheralClkEdge should take priority over parallelLoad
        $display("peripheralClkEdge | serialDataIn | parallelDataOut | parallelLoad | parallelDataIn | serialDataOut |");
        peripheralClkEdge = 1; parallelLoad = 1; parallelDataIn = 8'b11111111; serialDataIn = 1; #150
        $display("        %b         |       %b      |     %b    |     %b      |    %b    |       %b       |", peripheralClkEdge, serialDataIn, parallelDataOut,parallelLoad, parallelDataIn, serialDataOut);

        #10000 
        $finish;
    end
endmodule
