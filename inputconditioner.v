//------------------------------------------------------------------------
// Input Conditioner
//    1) Synchronizes input to clock domain
//    2) Debounces input
//    3) Creates pulses at edge transitions
//------------------------------------------------------------------------
// 50 MHz is 2 * 1-^-8 seconds per cycle 

module inputconditioner
(
input 	    clk,            // Clock domain to synchronize input to
input	    noisysignal,    // (Potentially) noisy input signal
output reg  conditioned,    // Conditioned output signal
output reg  positiveedge,   // 1 clk pulse at rising edge of conditioned
output reg  negativeedge    // 1 clk pulse at falling edge of conditioned
);

    parameter counterwidth = 3; // Counter size, in bits, >= log2(waittime) (maybe this could be 2 since 2^2 > 3)
    parameter waittime = 3;     // Debounce delay, in clock cycles
    
    reg[counterwidth-1:0] counter = 0;
    reg synchronizer0 = 0;
    reg synchronizer1 = 0;		// you need 2 synchronizers so you can calculate + and - edge 
    
always @(posedge clk ) begin
    if(conditioned == synchronizer1)
        counter <= 0;
    else begin
        if( counter == waittime) begin 
            counter <= 0;
            conditioned <= synchronizer1;
			if(conditioned == 0 & synchronizer1 ==1) begin
				positiveedge <= 1;	
			end	
			if(conditioned == 1 & synchronizer1 ==0) begin
				negativeedge <= 1; 
			end 			
        end
        else 
            counter <= counter+1;
    end

    synchronizer0 <= noisysignal;  		// these happen every time there's a + clk edge 
    synchronizer1 <= synchronizer0;
	positiveedge <= 0;	
	negativeedge <= 0;	
end

endmodule


