//------------------------------------------------------------------------
// Shift Register test bench
//      Tests for the following functions of the shift register:
//      1) The shift register advances one position on a peripheral clock edge.
//          - serialDataIn loaded into the LSB.
//          - The rest of the bits shift up by one position.
//      2) When parallelLoad is asserted, the shift register will take the value of parallelDataIn.
//          - Data is not loaded into the shift register from the serialDataInPort if parallelLoad is true.
//      3) serialDataOut will always present the MSB of the shift register.
//      4) parallelDataOut always presents the entirety of the contents of the shift register
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


    initial begin
        $dumpfile("shiftregister.vcd");
        $dumpvars();

        // Shift register will serially load data
        parallelLoad = 0;

        // Load data into the shift register serially (8'b01010101).
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
        peripheralClkEdge = 1; #10
        peripheralClkEdge = 0; #50

        // Test Case 0: the parallelDataOut port displays the entire contents of the shift register.
        if (parallelDataOut != dut.shiftregistermem) begin
            $display("Test Case 0 failed: parallelDataOut does not match the contents of the shift register.");
        end

        // Test Case 1: Serially load data into the shift register.
        // After 8 peripheral clock cycles, the shift register should contain the bits that were loaded in above.
        if (parallelDataOut != 8'b01010101) begin
            $display("Test Case 1 failed: parallelDataOut does not match the serial input sequence at time %t", $time);
            $displayb("parallelDataOut: %b", parallelDataOut);
        end


        serialDataIn = 1;
        peripheralClkEdge = 1; #10
        peripheralClkEdge = 0; #50

        // Test Case 2: at the peripheral clock edge, serialData in is loaded into the LSB of the shift register
        // and the rest of the bits shift over one position
        if (parallelDataOut != 8'b10101011) begin
            $display("Test Case 2 failed: parallelDataOut not shifted one position from the previous reading.");
            $displayb("parallelDataOut: %b", parallelDataOut);
        end

        #1000;

        // Shift register should load all data at once in parallel.
        parallelLoad = 1; 

        // Parallel load data (8'b00000000).
        parallelDataIn = 8'b00000000;   #50
        peripheralClkEdge = 1;  #10

        // Test Case 3: Load parallel data.
        // ParallelDataIn should have been loaded into the shift register.
        if (parallelDataOut != parallelDataIn) begin
            $display("Test Case 3 failed: parallelDataIn does not match parallelDataOut despite enabled parallelLoad %t", $time);
            $displayb("parallelDataOut: %b", parallelDataOut);
        end

        // Present data to the serialDataIn port. This should not be stored in the register
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


        // Test Case 4: ParallelLoad blocks serial loading into shift register.
        // After 8 perpheral clock cycles with parallelLoad set high, ParallelDataOut should match the input parallel data.
        if (parallelDataOut != parallelDataIn) begin
            $display("Test Case 4 failed: parallelDataIn does not match parallelDataOut despite enabled parallelLoad %t", $time);
            $displayb("parallelDataOut: %b", parallelDataOut);
        end

        // Load parallel data into register (8'b01010101).
        parallelLoad = 1;
        parallelDataIn = 8'b01010101; #50

        // Test Case 5: parallel in serial out.
        // The most significant bit of the parallel data loaded in should match the value of serialDataOut.
        if (serialDataOut != parallelDataIn[7]) begin
            $display("Test Case 5 failed: serial out does not match parallel in at time %t", $time);
            $displayb("serialDataOut: %b", serialDataOut);
        end

        // Shift register should serially load data when parallelLoad is low.
        parallelLoad = 0;

        // Present parallel load data to the parallelDataIn port.
        parallelDataIn = 8'b11010101; #50

        // Test Case 6: Only parallel load data when parallelLoad is high.
        // The parallelDataOut port should not have the value of the parallelDataIn port. 
        if (parallelDataOut == 8'b11010101) begin
            $display("Test Case 6 failed: parallelDataOut changed without parallelLoad enabled %t", $time);
            $displayb("serialDataOut: %b", serialDataOut);
        end

        $finish();

    end

endmodule

