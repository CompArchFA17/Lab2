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
output wire conditioned,    // Conditioned output signal
output reg  positiveedge,   // 1 clk pulse at rising edge of conditioned
output reg  negativeedge    // 1 clk pulse at falling edge of conditioned
);
    debouncer deb(clk, noisysignal, conditioned);

    reg prevconditioned = 0;
    always @(posedge clk ) begin
        if(conditioned == 0 & prevconditioned == 1) begin
            positiveedge <= 1;
        end
        else begin
            negativeedge <= 0;
        end
    end
endmodule

// only changes the input signal after it is stable for a given wait_time
module debouncer
(
input       clk,   // Clock domain to synchronize input to
input       sig,   // (Potentially) noisy input signal
output reg  out    // Debounced output signal
);
    parameter wait_time = 3;     // Debounce delay, in clock cycles

    reg[wait_time-1:0] prev_vals;

    //0 0 0 0 1 0 1 1 1 1
    always @(posedge clk ) begin
        // Case 1: The previous values are all 1s
        if( prev_vals == ((2**wait_time) - 1)) begin
            out <= 1;
        end
        // Case 2: The previous values are all 0s
        else if( prev_vals == 0) begin
            out <= 0;
        end
        // Update the previous values to have the new signal bit
        // Note that the output won't reflect the latest signal
        // until the next clock cycle
        prev_vals <= {prev_vals, sig};
    end
endmodule
