`include "shiftregister.v"
//------------------------------------------------------------------------
// Shift Register test bench
//------------------------------------------------------------------------

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
    reg dutpassed;

    initial begin
      $dumpfile("shift.vcd");
      $dumpvars(0, testshiftregister);
      //initialize
      dutpassed = 1;
      clk = 0; #5;
    	parallelDataIn = 8'd0;
      parallelLoad   = 1;
      clk = 1; #5;
      clk = 0; #5;
      if(parallelDataOut != 8'd0 || ^parallelDataOut === 1'bx) begin
          $display("initialization failed, parallel");
          dutpassed = 0;
      end
      if(serialDataOut != 0 || serialDataOut === 1'bx) begin
          $display("initialization failed, serial");
          dutpassed = 0;
      end

      //serialLoad some bits
      parallelLoad = 0;
      serialDataIn = 1;
      clk = 1; #5; clk = 0; #5;
      serialDataIn = 1;
      clk = 1; #5; clk = 0; #5;
      serialDataIn = 0;
      clk = 1; #5; clk = 0; #5;
      serialDataIn = 0;
      clk = 1; #5; clk = 0; #5;
      serialDataIn = 1;
      clk = 1; #5; clk = 0; #5;
      serialDataIn = 0;
      clk = 1; #5; clk = 0; #5;
      serialDataIn = 1;
      clk = 1; #5; clk = 0; #5;
      serialDataIn = 0;
      clk = 1; #5; clk = 0; #5;
      if(parallelDataOut != 8'b11001010 || ^parallelDataOut === 1'bx) begin
          $display("Serial in failed, parallel");
          dutpassed = 0;
      end
      if(serialDataOut != 1 || serialDataOut === 1'bx) begin
          $display("Serial in failed, serial");
          dutpassed = 0;
      end

      //parallelLoad some bits
      parallelLoad = 1;
      parallelDataIn = 8'b01010011;
      clk = 1; #5; clk = 0; #5;
      if(parallelDataOut != 8'b01010011 || ^parallelDataOut === 1'bx) begin
          $display("Parallel in failed, parallel");
          dutpassed = 0;
      end
      if(serialDataOut != 0 || serialDataOut === 1'bx) begin
          $display("Parallel in failed, serial");
          dutpassed = 0;
      end

      //parallel and serial at the same time
      parallelLoad = 1;
      serialDataIn = 0;
      parallelDataIn = 8'b11111111;
      clk = 1; #5; clk = 0; #5;
      if(parallelDataOut != 8'b11111111 || ^parallelDataOut === 1'bx) begin
          $display("Same time in failed, parallel");
          dutpassed = 0;
      end
      if(serialDataOut != 1 || serialDataOut === 1'bx) begin
          $display("Same time in failed, serial");
          dutpassed = 0;
      end

      if(dutpassed) begin
          $display("DUT passed!");
      end
      $finish();
    end
endmodule
