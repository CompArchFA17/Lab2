module inputconditioner
(
input 	    shiftRegOut,            //defines the state (read or write)
input	    CS,						//chip select
input 		sclk,    			//serial clock
output	    MISOBUFE,    // controls output to MISO
output 	    DM_WE,   // Write enable data memory
output      ADDR_WE,    //  address write enable
output		SR_WE //Parallel Load
);
reg counter=0;

always @(posedge sclk) begin
	if(CS==0) begin
		if(counter<=6) begin
			assign ADDR_WE=1;
			counter=counter+1;
		end
		else if(counter==7) begin
			assign ADDR_WE=0;
		end
	end


end

endmodule