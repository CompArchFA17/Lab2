all: input

input: inputconditioner.t.v inputconditioner.v
	iverilog -Wall -o input inputconditioner.t.v