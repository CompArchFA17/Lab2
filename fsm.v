//                MISO_BUFF            DM_WE            ADDR_WE          SR_WE
//CS              0                    0                0                0
//~CS             0                    0                1                1
//shiftRegOutP[0] 1                    0                0                1
//~shiftRegOutP[0]0                    1                0                0
module fsm(MISO_BUFF,DM_WE,ADDR_WE,SR_WE,POS_EDGE,CS,shiftRegOutP0);
   input POS_EDGE;
   input CS;
   input shiftRegOutP0;
   output MISO_BUFF;
   output DM_WE;
   output ADDR_WE;
   output SR_WE;

   reg [1:0] state;
   reg MISO_BUFF,DM_WE,ADDR_WE,SR_WE;
   wire [1:0] next_state;

   assign next_state = fsm_function(state,POS_EDGE,CS,shiftRegOutP0);   

   function [1:0] fsm_function;
      input [1:0] state;
      input POS_EDGE;
      input CS;
      input ShiftRegOutP0;
      case(state)
        2'b00:if(!CS) begin
                 fsm_function = 2'b01;
              end
        2'b01:if(shiftRegOutP0) begin
                 fsm_function = 2'b10;
              end else if (!shiftRegOutP0) begin
                 fsm_function = 2'b11;
              end
        2'b10:if(CS) begin
                 fsm_function = 2'b00;
              end
        2'b11:if(CS) begin
                 fsm_function = 2'b00;
              end
        default:fsm_function = 2'b00;
      endcase
   endfunction

   always @ (*) begin
      state <= next_state;
      if (state == 2'b00) begin
         MISO_BUFF <= 0;
         DM_WE <= 0;
         SR_WE <= 0;
      end else if (state == 2'b01) begin
         ADDR_WE <= 1;
         SR_WE <= 1;
      end else if (state == 2'b10) begin
         MISO_BUFF <= 1;
         ADDR_WE <= 0;
      end else if (state == 2'b11) begin
         DM_WE <= 1;
         ADDR_WE <= 0;
         SR_WE <= 0;
      end
   end
endmodule