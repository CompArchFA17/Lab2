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


	$display("PIn? | PDataIn | SDataOut");
	parallelLoad =1; parallelDataIn = 8'b00011111; #20
	$display("%b | %b | %b ", parallelLoad, parallelDataIn, serialDataOut);
	parallelLoad =1; parallelDataIn = 8'b00111101; #20
	$display("%b | %b | %b", parallelLoad, parallelDataIn, serialDataOut);
		parallelLoad =1; parallelDataIn = 8'b10011110; #20
	$display("%b | %b | %b", parallelLoad, parallelDataIn, serialDataOut);



	$display("PIn? | PClock| SDataIn | PDataOut");
	parallelLoad =0; peripheralClkEdge = 1; serialDataIn = 1; #20
	$display("%b    |    %b | 	%b 	| %b ", parallelLoad, peripheralClkEdge, serialDataIn, parallelDataOut);
	parallelLoad =0; peripheralClkEdge = 0; serialDataIn = 1; #20
	$display("%b    |    %b | 	%b 	| %b ", parallelLoad, peripheralClkEdge, serialDataIn, parallelDataOut);
	parallelLoad =0; peripheralClkEdge = 1; serialDataIn = 0; #20
	$display("%b    |    %b | 	%b	| %b ", parallelLoad, peripheralClkEdge, serialDataIn, parallelDataOut);
	parallelLoad =0; peripheralClkEdge = 0; serialDataIn = 0; #20
	$display("%b    |    %b | 	%b	| %b ", parallelLoad, peripheralClkEdge, serialDataIn, parallelDataOut);
	parallelLoad =0; peripheralClkEdge =1; serialDataIn = 0; #20
	$display("%b    |    %b | 	%b	| %b ", parallelLoad, peripheralClkEdge, serialDataIn, parallelDataOut);


	$finish;
    end

endmodule

