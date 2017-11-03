all: inputconditioner shiftregister midpoint addresslatch dflipflop fsm spimemory

inputconditioner: inputconditioner.t.v inputconditioner.v
	iverilog -Wall -o inputconditioner inputconditioner.t.v

shiftregister: shiftregister.t.v shiftregister.v
	iverilog -Wall -o shiftregister shiftregister.t.v

midpoint: midpoint.v
	iverilog -Wall -o midpoint midpoint.v

addresslatch: addresslatch.v
	iverilog -Wall -o addresslatch addresslatch.v

dflipflop: dflipflop.v
	iverilog -Wall -o dflipflop dflipflop.v

fsm: fsm.v
	iverilog -Wall -o fsm fsm.v

spimemory: spimemory.t.v spimemory.v
	iverilog -Wall -o spimemory spimemory.t.v