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
    always #5 clk=!clk;

    initial begin
        // Test parallel looads
    	parallelLoad = 1;
        parallelDataIn = 8'b00000000;
        #20;
        if (parallelDataOut == 8'b00000000) begin
            $display("Test Case 1 Passed");
        end
        else begin
            $display("Test Case 1 Failed!");
        end

        parallelDataIn = 8'b00001111;
        #20;
        if (parallelDataOut == 8'b00001111) begin
            $display("Test Case 2 Passed");
        end
        else begin
            $display("Test Case 2 Failed!");
        end

        parallelDataIn = 8'b11111111;
        #20;
        if (parallelDataOut == 8'b11111111) begin
            $display("Test Case 3 Passed");
        end
        else begin
            $display("Test Case 3 Failed!");
        end

        parallelLoad = 0;
        parallelDataIn = 8'b00000000;
        #20;
        if (parallelDataOut == 8'b00000000) begin
            $display("Test Case 4 Failed!");
        end
        else begin
            $display("Test Case 4 Passed");
        end


        $finish;
    end

endmodule
