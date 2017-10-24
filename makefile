all: inputconditioner

inputconditioner: inputconditioner.t.v inputconditioner.v
	iverilog -Wall -o inputconditioner inputconditioner.t.v