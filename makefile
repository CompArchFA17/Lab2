all: inputconditioner shiftregister

inputconditioner: inputconditioner.t.v inputconditioner.v
	iverilog -Wall -o inputconditioner inputconditioner.t.v

shiftregister: shiftregister.t.v shiftregister.v
	iverilog -Wall -o shiftregister shiftregister.t.v