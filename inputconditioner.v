//------------------------------------------------------------------------
// Input Conditioner
//    1) Synchronizes input to clock domain
//    2) Debounces input
//    3) Creates pulses at edge transitions
//------------------------------------------------------------------------

module inputconditioner
(
input 	    clk,            // Clock domain to synchronize input to
input	    noisysignal,    // (Potentially) noisy input signal
output reg  conditioned,    // Conditioned output signal
output reg  positiveedge,   // 1 clk pulse at rising edge of conditioned
output reg  negativeedge    // 1 clk pulse at falling edge of conditioned
);

    parameter counterwidth = 3; // Counter size, in bits, >= log2(waittime)
    parameter waittime = 2;     // Debounce delay, in clock cycles

    reg[counterwidth-1:0] counter = 0;
    reg prevconditioned = 0;
    reg synchronizer0 = 0;
    reg synchronizer1 = 0;

    //0 0 0 0 1 0 1 1 1 1
    always @(posedge clk ) begin
        // Case 1: previous signal is same as current output
        if(conditioned == synchronizer1)
            counter <= 0;
        else begin
            // Case 2: Counter reaches maximum limit
            if( counter == waittime) begin
                counter <= 0;
                conditioned <= synchronizer1;
            end
            // Case 3: Counter has not reached max limit
            else
                counter <= counter+1;
        end
        synchronizer0 <= noisysignal;
        synchronizer1 <= synchronizer0;

        prevconditioned <= conditioned;
        // Set positive edge output
        if(conditioned == 1 & prevconditioned == 0) begin
            positiveedge <= 1;
        end
        else begin
            positiveedge <= 0;
        end

        if(conditioned == 0 & prevconditioned == 1) begin
            negativeedge <= 1;
        end
        else begin
            negativeedge <= 0;
        end
    end
endmodule
