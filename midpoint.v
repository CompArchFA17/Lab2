//midpoint check-in top-level module
//3 input conditioners input to a shift register

`include inputconditioner.v
`include shiftregister.v

module midpoint begin
(
input butn0;
input switch0;
input switch1;
input xA5;
input clk;
output LEDs;
)
wire sout;

inputconditioner IR0(condit0,posedge0,negedge0,clk,butn0); //parallel in
inputconditioner IR1(condit1,posedge1,negedge1,clk,switch0); //MOSI
inputconditioner IR2(condit2,posedge2,negedge2,clk,switch1); //sclock

shiftregister SR(LEDs,sout,clk,posedge2,negedge0,xA5,condit1);


end