module inputconditioner
(
input 	    shiftRegOut,            //defines the state (read or write)
input	    CS,						//chip select
input 		sclockedge,    			//serial clock
output	    MISOBUFE,    // controls output to MISO
output 	    DM_WE,   // Write enable data memory
output      ADDR_WE,    //  address write enable
output		SR_WE //Parallel Load
);

always @(!CS) begin
	


end

endmodule