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
    
    always #10 clk=!clk; 
    initial begin
        //$dumpfile("shiftregister.vcd");
        //$dumpvars;
        parallelLoad = 1;
        parallelDataIn = 8'b00000000; #100
        peripheralClkEdge = 1;

        serialDataIn = 1; #10
        if (serialDataOut == 0) begin
            $display("Passed Test Case 1");
        end
        else begin
            $display("Failed Test Case 1");
            $display(serialDataOut);
            $display("%8b", parallelDataOut);
        end
        if (parallelDataOut == 1) begin
            $display("Failed Test Case 2");
        end
        else begin
            $display("Passed Test Case 2");
        end
        #30
        if (serialDataOut != 0) begin
            $display("Failed Test Case 3");
        end
        if (parallelDataOut != 8) begin
            $display("Failed Test Case 4");
        end
        #50
        /*if (parallelLoad == 0) begin
            $display("Failed!");
        end
        serialDataIn = 0; #10
        serialDataIn = 1; #10
        serialDataIn = 1; #10
        serialDataIn = 1; 
        #100*/
        $finish;
    end

endmodule

