`include "shiftregister.v"
`include "inputconditioner.v"
module midpoint_wrapper
(
   input clk,
   input [3:0] sw,
   input [3:0] btn,
   output [3:0] led
   );

  wire par_load;
   wire ser_in;
   wire clk_edge;
   wire [7:0] par_data_in;
   wire [7:0] par_data_out;
   reg [3:0]      ledmem;
   
   inputconditioner btn_cond(.clk(clk),.noisysignal(btn[0]),.negativeedge(par_load));
   inputconditioner sw0_cond(.clk(clk),.noisysignal(sw[0]),.conditioned(ser_in));
   inputconditioner sw1_cond(.clk(clk),.noisysignal(sw[1]),.positiveedge(clk_edge));

   assign par_data_in = 8'hA5;

   shiftregister shftreg(.clk(clk),.peripheralClkEdge(clk_edge),.parallelLoad(par_load),.parallelDataIn(par_data_in),.serialDataIn(ser_in),.parallelDataOut(par_data_out));

   always @(posedge clk)begin
      if(sw[3])
	   ledmem = par_data_out[7:4];
      else begin
	   ledmem = par_data_out[3:0];
      end
   end
   assign led=ledmem;
endmodule
