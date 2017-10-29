//------------------------------------------------------------------------
// Finite State Machine
//------------------------------------------------------------------------

`include "inputconditioner.v"
`include "shiftregister.v"

module FSM
(
	input 			clk,
	input 			sclk, 
    input           positiveedge,        	// 
    input           conditioned,   			//
    input           parallelDataOut[0],     // 
    output          miso_bufe,   	// WTF is this
    output          DM_WE,   		// data memory write enable 
    output	    	ADDR_WE        	// write enable for address latch 
	output 			SR_WE			// shift register write enable 
	output 			MISO_pin
)

shiftregister boofato(//some shit);

//notes 
// maybe miso buffe shoulfd just always be zero unless you set it to 1 
// 


always @(posedge sclk ) begin

if(conditioned == 0)begin				// if you are doing things
	// ADDR_WE is 1 for 7 sclck's, then is set to zero
	// 
	if(parallelDataOut[0] == 0)begin  // if you are writing to datamemory
		// once the above 7 sclks are done, DM_WE = 1 
		// leave that on for 8 sclks then turn to 0 
		// at the end, Addr_WE = 0, DM_WE = 0, SR_WE = 0
		// MISO_BUFE = 0 to set the thing to z 
		
	end
	if(parallelDataOut[0] == 1)begin  // if you are reading from data memory
		// once those 7 sclks are done (on sclk number 8) set SR_WE to 1
		// set MISO_BUFE to 1 so that we get the data the master wants to read 
		// DM_WE to 0 
		//
		
	end
end


if(conditioned == 1)begin			// if you are ingoring things and tri-stating
	// DM_WE = 0
	// ADDR+WE = 0 
	// SR_WE = 0 
	// MISO_BUFE = 0 to get Z 
end

if(MISO_BUFE == 0)
	assign MISO_pin = DFF_serialout // there needs to be the d flip flop that exists here 

if(MISO_BUFE == 1)
	assign MISO_pin = z // syntak might be jank

end 

endmodule
   

