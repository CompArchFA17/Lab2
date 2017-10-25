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
output reg conditioned,    // Conditioned output signal
output reg  positiveedge,   // 1 clk pulse at rising edge of conditioned
output reg  negativeedge    // 1 clk pulse at falling edge of conditioned
);
    parameter wait_time = 3;
    reg[wait_time-1:0] prev_vals;
    

    always @(posedge clk ) begin
        // Case 1: The previous values are all 1s
        if( prev_vals == ((2**wait_time) - 1)) begin
            if (conditioned == 0) begin
                positiveedge <= 1;
            end 
            else begin
                positiveedge <= 0;
            end
            conditioned <= 1;
        end
        // Case 2: The previous values are all 0s
        else if( prev_vals == 0) begin
            if (conditioned == 1) begin
                negativeedge <= 1;
            end
            else begin
                negativeedge <= 0;
            end

            conditioned <= 0;
        end
    
        prev_vals <= {prev_vals, noisysignal};
    end

endmodule