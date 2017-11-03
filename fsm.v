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
   parameter counter_num_bits = 4;
   reg[counter_num_bits-1:0] counter = 0;

    

   function [1:0] fsm_function;
      input [1:0] state;
      input CS;
      input shiftRegOutP0;
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

   always @ (posedge POS_EDGE) begin
	  next_state <= fsm_function(state,CS,shiftRegOutP0); 
      if (next_state == 2'b00) begin
         MISO_BUFF <= 0;
         DM_WE <= 0;
         SR_WE <= 0;
		 ADDR_WE <= 0;
      end else if (next_state == 2'b01) begin
         if(counter == 0) begin
           counter <= 1;
         end
      end else if (next_state == 2'b10) begin
         MISO_BUFF <= 1;
         ADDR_WE <= 0;
		 SR_WE <= 1;
      end else if (next_state == 2'b11) begin
         DM_WE <= 1;
         ADDR_WE <= 0;
         SR_WE <= 0;
      end
      if (counter==7)begin
        ADDR_WE<=1;
		counter <= counter + 1;
      end
      else if (counter==8)begin
        ADDR_WE <=0;
        counter<=0;
      end
      else if (counter>0)begin
        counter<=counter+1;
      end
   end
endmodule