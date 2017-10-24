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

$dumpfile("shift.vcd");
$dumpvars();
   
$display(" test stuff here "); 
parallelLoad = 1; parallelDataIn = 00001110; #400
$display("%b | %b | %b | %b ", clk, parallelLoad, parallelDataIn, serialDataOut );


 	
end

endmodule

