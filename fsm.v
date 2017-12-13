//                MISO_BUFF            DM_WE            ADDR_WE          SR_WE
//CS              0                    0                0                0
//~CS             0                    0                1                1
//shiftRegOutP[0] 1                    0                0                1
//~shiftRegOutP[0]0                    1                0                0
module fsm(MISO_BUFF,DM_WE,ADDR_WE,SR_WE,POS_EDGE,CS,shiftRegOutP0,clk,state,counter,relevant_shiftRegOutP0,clk_counter);
   input POS_EDGE;
   input CS;
   input shiftRegOutP0;
   input clk;
   output MISO_BUFF;
   output DM_WE;
   output ADDR_WE;
   output SR_WE;
   output [1:0] state;
   output [5:0] counter;
   output [1:0] relevant_shiftRegOutP0;
   output [5:0] clk_counter;
   
   wire [1:0] state;
   reg MISO_BUFF,DM_WE,ADDR_WE,SR_WE;
   reg [1:0] next_state;
   parameter counter_num_bits = 5;
   reg[counter_num_bits-1:0] counter = 0;
   reg start_counter;
   wire [1:0] previous_state;
   reg [1:0] counter_type;
   reg [1:0] relevant_shiftRegOutP0;
   reg already_counted;
   reg [5:0] clk_counter;
   reg [1:0] counter_flag;

   assign state = next_state;
   
   function [1:0] fsm_function;
      input [1:0] state;
      input CS;
      input relevant_shiftRegOutP0;
      case(state)
        2'b00:if(!CS) begin
                 fsm_function = 2'b01;
              end
        2'b01:if(relevant_shiftRegOutP0 == 2'b10) begin
                 fsm_function = 2'b10;
              end else if (relevant_shiftRegOutP0 == 2'b01) begin
                 fsm_function = 2'b11;
			  end else if (already_counted && counter == 0 && CS) begin
			     fsm_function = 2'b00;
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
      
   always @ (posedge clk) begin
	if(counter == 7) begin
		clk_counter <= 1;
		counter_flag <= 2'b01;
	end else if (counter == 10 && relevant_shiftRegOutP0 == 2'b10) begin
		clk_counter <= 1;
		counter_flag <= 2'b10;
	end else if (counter == 18 && relevant_shiftRegOutP0 == 2'b10) begin
		clk_counter <= 1;
		counter_flag <= 2'b11;
	end else if (clk_counter == 3 && counter_flag == 2'b01) begin
		relevant_shiftRegOutP0 <= shiftRegOutP0 ? 2'b10 : 2'b01;
		clk_counter <= 0;
	end else if (clk_counter == 6 && counter_flag == 2'b10) begin
		MISO_BUFF <= 1;
		clk_counter <= 0;
	end else if (clk_counter == 6 && counter_flag == 2'b11) begin
		MISO_BUFF <= 0;
		clk_counter <= 0;
		counter <= 0;
		relevant_shiftRegOutP0 <= 2'b00;
	end else if (clk_counter  > 0) begin
		clk_counter <= clk_counter + 1;
	end
   end
   
   always @ (posedge POS_EDGE) begin
	  next_state <= fsm_function(state,CS,relevant_shiftRegOutP0); 
      if (next_state == 2'b00) begin
         MISO_BUFF <= 0;
         DM_WE <= 0;
         SR_WE <= 0;
		 ADDR_WE <= 0;
		 already_counted <= 0;
      end else if (next_state == 2'b01) begin
         if(counter == 0 && !already_counted) begin
           counter <= 1;
		   counter_type <= 2'b01;
		   already_counted <= 1;
         end
      end else if (next_state == 2'b10) begin
         ADDR_WE <= 0;
		 DM_WE <= 0;
		 if(counter > 0) begin
			SR_WE <= 1;
			MISO_BUFF <= 1;
		 end
      end else if (next_state == 2'b11) begin
         DM_WE <= 0;
         ADDR_WE <= 0;
         SR_WE <= 0;
      end
      if (counter == 7) begin
		ADDR_WE <= 1;
		//relevant_shiftRegOutP0 <= shiftRegOutP0 ? 2'b10 : 2'b01;
		counter <= counter + 1;
	  end else if (counter == 8) begin
		ADDR_WE <= 0;
		counter <= counter + 1;
	  end else if (counter == 9) begin
		if (relevant_shiftRegOutP0 == 2'b10) begin
			SR_WE <= 1;
		end
		counter <= counter + 1;
	  end else if (counter == 10) begin
	    SR_WE <= 0;
		counter <= counter + 1;
	  //end else if (counter == ) begin
		//if (next_state == 2'b10) begin
			//MISO_BUFF <= 1;
		//end
		//counter <= counter + 1;
	  //end else if (counter == 10) begin
		//if (relevant_shiftRegOutP0 == 2'b10) begin
		//	MISO_BUFF <= 1;
		//end
	  end else if (counter == 15) begin
		if (relevant_shiftRegOutP0 == 2'b01) begin
			DM_WE <= 1;
		end 
		counter <= counter + 1;
	  end else if (counter == 16) begin
		DM_WE <= 0;
		SR_WE <= 0;
		//counter <= 0;
		if (relevant_shiftRegOutP0 == 2'b01) begin
			MISO_BUFF <= 0;
			counter <= 0;
			relevant_shiftRegOutP0 <= 2'b00;
		end else if (relevant_shiftRegOutP0 == 2'b10) begin
			counter <= counter + 1;
		end
	  end else if (counter > 0) begin
		counter <= counter + 1;
	  end
   end
endmodule