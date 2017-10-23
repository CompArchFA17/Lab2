//------------------------------------------------------------------------
// Shift Register
//   Parameterized width (in bits)
//   Shift register can operate in two modes:
//      - serial in, parallel out
//      - parallel in, serial out
//------------------------------------------------------------------------

module shiftregister
#(parameter width = 8)
(
input               clk,                // FPGA Clock
input               peripheralClkEdge,  // Edge indicator
input               parallelLoad,       // 1 = Load shift reg with parallelDataIn
input  [width-1:0]  parallelDataIn,     // Load shift reg in parallel
input               serialDataIn,       // Load shift reg serially
output [width-1:0]  parallelDataOut,    // Shift reg data contents
output              serialDataOut       // Positive edge synchronized
);

reg [width-1:0]      shiftregistermem;

// general thoughts: make a loop that happens width # of times, 
// and then use the idea behind the behavioral flip flop below  
// so that you can pass things along as needed. 

// confusion points: I don't know what the peripheral clock edge does. 
// The assignement says that the bits advance when the periperal clock 
// has an edge, but I don't know why you don't use the normal clock? 

// from the assignment: 
// " Each of these four behaviors can be implemented in one or two lines of behavioral Verilog. 
// You may want to look at Verilog's {} concatenate syntax for implementing the serial behavior. "

always @(posedge clk) begin
    peripheralCLkEdge <= clk; 

end

always @(posedge periperalClkEdge)

end



endmodule



module flipflop
(
output reg  q,
input       d,
input       wrenable,
input       clk
);
    always @(posedge clk) begin
        if(wrenable) begin
            q = d;
        end
    end
endmodule
