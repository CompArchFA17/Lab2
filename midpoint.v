`include "shiftregister.v"
`include "inputconditioner.v"
module midpoint_wrapper
  (
   input clk,
   input [3:0] sw,
   input [3:0] btn,
   input [3:0] led
   )

  wire par_load;
   wire ser_in;
   wire clk_edge;
   wire [7:0] par_data_in;
   wire [7:0] par_data_out;
   
   inputconditioner btn_cond(.clk(clk),.noisysignal(btn[0]),.negativeedge(par_load));
   inputconditioner sw0_cond(.clk(clk),.noisysignal(sw[0]),.coditioned(ser_in));
   inputconditioner sw1_cond(.clk(clk),.noisysignal(sw[1]),.positiveedge(clk_edge));

   assign par_data_in = 8'hA5;

   shiftregister reg(.clk(clk),.peripheralClkEdge(clk_edge),.parallelLoad(par_load),.parallelDataIn(par_data_in),.serialDataIn(ser_in),.parallelDataDout(par_data_out));

   always @(posedge clk)begin
      if(sw[1])
	led <= par_data_out[4:7];
      else begin
	 led <= par_data_out[0:3];
      end
   end
endmodule
