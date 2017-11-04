// TAKEN FROM LISA'S 2016 REPOSITORY
//------------------------------------------------------------------------
// Input Conditioner
//    1) Synchronizes input to clock domain
//    2) Debounces input
//    3) Creates pulses at edge transitions
//------------------------------------------------------------------------
`timescale 1 ns / 1 ps

module inputconditioner
(
input 	    clk,            // Clock domain to synchronize input to
input	    noisysignal,    // (Potentially) noisy input signal
output reg  conditioned,    // Conditioned output signal
output reg  positiveedge,   // 1 clk pulse at rising edge of conditioned
output reg  negativeedge    // 1 clk pulse at falling edge of conditioned
);

    parameter counterwidth = 3; // Counter size, in bits, >= log2(waittime)
    parameter waittime = 3;     // Debounce delay, in clock cycles

    reg[counterwidth-1:0] counter = 0; //not sure what this syntax is
    reg synchronizer0 = 0;
    reg synchronizer1 = 0;

    always @(posedge clk ) begin
        if(conditioned == synchronizer1) begin //if conditioned is same as we thought
            counter <= 0;
            positiveedge <= 0; //not sure if this should be nonblockingit
            negativeedge <= 0;
	end
        else begin //if conditioned has changed
            if( counter == waittime) begin //when debouncing is done
                counter <= 0; //reset counter
                conditioned <= synchronizer1; //save conditioned in synchronizer1
                positiveedge <= synchronizer1; //set negativeedge opposite
                negativeedge <= !synchronizer1; //set positiveedge opposite
            end
            else begin
                counter <= counter+1; //wait for debouncing
	    end
        end
        if (counter == 0) begin
            synchronizer0 <= noisysignal;
            synchronizer1 <= synchronizer0;
        end
    end

    //max glitch is 6 clock cycles


endmodule
