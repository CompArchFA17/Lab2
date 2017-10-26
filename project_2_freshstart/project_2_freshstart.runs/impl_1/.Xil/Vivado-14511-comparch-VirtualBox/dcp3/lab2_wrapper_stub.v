// Copyright 1986-2017 Xilinx, Inc. All Rights Reserved.

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module lab2_wrapper(clk, sw, btn, led, je);
  input clk;
  input [3:0]sw;
  input [3:0]btn;
  output [3:0]led;
  output [7:0]je;
endmodule
