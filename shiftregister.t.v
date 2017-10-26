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
	
$dumpfile("shiftregister.vcd");
$dumpvars();



// Check Parallel In, Serial Out 
	$display("PIn? | PDataIn | SDataOut");
	parallelLoad =1; parallelDataIn = 8'b00011111; #21
	$display("%b   | %b | %b ", parallelLoad, parallelDataIn, serialDataOut); // expect 0
	parallelLoad =1; parallelDataIn = 8'b00111110; #21
	$display("%b   | %b | %b", parallelLoad, parallelDataIn, serialDataOut); // expect 0
	parallelLoad =1; parallelDataIn = 8'b01111101; #21
	$display("%b   | %b | %b", parallelLoad, parallelDataIn, serialDataOut); // expect 0
	parallelLoad =1; parallelDataIn = 8'b11111010; #21
	$display("%b   | %b | %b", parallelLoad, parallelDataIn, serialDataOut); // expect 1
	parallelLoad =1; parallelDataIn = 8'b11110100; #21
	$display("%b   | %b | %b", parallelLoad, parallelDataIn, serialDataOut); // expect 1

// Check Serial In, Parallel Out
// This is what we'll want to do on the FPGA

	$display("PIn? | SDataIn | PDataOut");
	parallelLoad =0; serialDataIn = 1; peripheralClkEdge = 1; #21
	$display("%b    | 	%b      | %b ", parallelLoad, serialDataIn, parallelDataOut);
	parallelLoad =0; serialDataIn = 1;peripheralClkEdge = 1;  #21
	$display("%b    | 	%b      | %b ", parallelLoad, serialDataIn, parallelDataOut);
	parallelLoad =0; serialDataIn = 0;peripheralClkEdge = 1;  #21
	$display("%b    | 	%b      | %b ", parallelLoad, serialDataIn, parallelDataOut);
	parallelLoad =0; serialDataIn = 0;peripheralClkEdge = 1;  #21
	$display("%b    | 	%b      | %b ", parallelLoad, serialDataIn, parallelDataOut);
	parallelLoad =0; serialDataIn = 0;peripheralClkEdge = 1;  #21
	$display("%b    | 	%b      | %b ", parallelLoad, serialDataIn, parallelDataOut);
	parallelLoad =0; serialDataIn = 1;peripheralClkEdge = 1;  #21
	$display("%b    | 	%b      | %b ", parallelLoad, serialDataIn, parallelDataOut);


	$finish;
    end

endmodule

