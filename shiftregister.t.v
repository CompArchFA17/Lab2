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
    always #10 clk = !clk;    // 50MHz Clock


    // Basic test for Serial In, Parallel Out.
    initial begin
        $dumpfile("shiftregister.vcd");
        $dumpvars();

        parallelLoad = 0; 
        peripheralClkEdge = 0;
        serialDataIn = 0;   #50
        peripheralClkEdge = 1; #10
        peripheralClkEdge = 0;
        serialDataIn = 1;   #50
        peripheralClkEdge = 1; #10
        peripheralClkEdge = 0;
        serialDataIn = 0;   #50
        peripheralClkEdge = 1; #10
        peripheralClkEdge = 0;
        serialDataIn = 1;   #50
        peripheralClkEdge = 1; #10
        peripheralClkEdge = 0;
        serialDataIn = 0;   #50 
        peripheralClkEdge = 1; #10
        peripheralClkEdge = 0;      
        serialDataIn = 1;   #50 
        peripheralClkEdge = 1; #10
        peripheralClkEdge = 0;       
        serialDataIn = 0;   #50
        peripheralClkEdge = 1; #10
        peripheralClkEdge = 0;
        serialDataIn = 1;   #50

        if (parallelDataOut != 8'b01010101) begin
            $display("Test case 1 failed: parallel out does not match serial in at time %t", $time);
            $display("parallelDataOut: %b", parallelDataOut);
        end

        parallelLoad = 1; 
        parallelDataIn = 8'b00000000;
        peripheralClkEdge = 0;
        serialDataIn = 0;   #50
        peripheralClkEdge = 1; #10
        peripheralClkEdge = 0;
        serialDataIn = 1;   #50
        peripheralClkEdge = 1; #10
        peripheralClkEdge = 0;
        serialDataIn = 0;   #50
        peripheralClkEdge = 1; #10
        peripheralClkEdge = 0;
        serialDataIn = 1;   #50
        peripheralClkEdge = 1; #10
        peripheralClkEdge = 0;
        serialDataIn = 0;   #50 
        peripheralClkEdge = 1; #10
        peripheralClkEdge = 0;      
        serialDataIn = 1;   #50 
        peripheralClkEdge = 1; #10
        peripheralClkEdge = 0;       
        serialDataIn = 0;   #50
        peripheralClkEdge = 1; #10
        peripheralClkEdge = 0;
        serialDataIn = 1;   #50

        if (parallelDataOut != parallelDataIn) begin
            $display("Test case 2 failed: parallelDataIn does not match parallelDataOut despite enabled parallelLoad %t", $time);
            $display("parallelDataOut: %b", parallelDataOut);
        end

        $finish();
    end

    // Basic test for Parallel In, Serial Out.
    initial begin

        parallelLoad = 1;
        parallelDataIn = 8'b01010101; #50

        if (serialDataOut != 0) begin
            $display("Test case 3 failed: serial out does not match parallel in at time %t", $time);
            $display("serialDataOut: %b", serialDataOut);
        end

        parallelLoad = 0;
        parallelDataIn = 8'b11010101; #50

        if (serialDataOut == 1) begin
            $display("Test case 4 failed: serialDataOut changed without parallelLoad enabled %t", $time);
            $display("serialDataOut: %b", serialDataOut);
        end

    end

endmodule

