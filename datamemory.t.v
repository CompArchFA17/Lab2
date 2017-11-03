
`include "datamemory.v"

module datamemorytest();

reg clk;
wire [7:0]dataOut;
reg [7:0]dataIn;
reg [6:0]address;
reg Wren;

initial clk=0;
always #10 clk= !clk;    // 50MHz Clock

datamemory dm(clk,dataOut[7:0],address[6:0],Wren,dataIn[7:0]);
initial begin
$dumpfile("datamemory.vcd");
$dumpvars(0, clk, dataOut[7:0],dataIn[7:0],address[6:0],Wren);

Wren=1; //writing to data memory
dataIn[7:0]=8'b01011010;
address[6:0]=7'b0000001; #20

dataIn[7:0]=8'b11110000;
address[6:0]=7'b0000010; #20

Wren=0; //done writing

//read time
address[6:0]=7'b0000001; #70
$display("%b",dataOut);
#70

address[6:0]=7'b0000010; #70
$display("%b",dataOut);

$finish;

end
endmodule