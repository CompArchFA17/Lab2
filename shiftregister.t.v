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

    initial clk = 0;
    always #10 clk=!clk;  // 50MHz Clock

    initial begin
        $dumpfile("shiftregister.vcd");
        $dumpvars(0, clk, peripheralClkEdge, parallelLoad, parallelDataOut, serialDataOut, parallelDataIn, serialDataIn);

        peripheralClkEdge = 0;
    	parallelLoad = 1; 
        parallelDataIn = 8'b10011101; #50
        $display("parallelDataOut after loading b10011101: %b", parallelDataOut);

        parallelLoad = 0; 
        serialDataIn = 0; #100
        $display("parallelDataOut shouldn't change: %b", parallelDataOut);

        $display("serialdata out before shifting: %b", serialDataOut);
        peripheralClkEdge = 1;
        parallelLoad = 0; 
        serialDataIn = 0; #20
        $display("parallelDataOut after shifting in 0: %b", parallelDataOut);
        $display("serialdata out after shifting: %b", serialDataOut);

        serialDataIn = 1; #20
        $display("parallelDataOut after shifting in 1: %b", parallelDataOut);
        $display("serialdata out after shifting: %b", serialDataOut);

        serialDataIn = 1; #20
        $display("parallelDataOut after shifting in 1: %b", parallelDataOut);
        $display("serialdata out after shifting: %b", serialDataOut);

        $finish;
    end

endmodule

