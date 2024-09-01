// A simple module to debounce a switch 
module Debounced_Switch #(parameter DEBOUNCE_LIMIT = 250000;
    input clk_i, 
    input sw_i, 
    output sw_o );
  
  	reg state_r = 1'b0;
    reg [$clog2(DEBOUNCE_LIMIT)-1:0] count_r;

  
    always @(posedge clk_w)
    begin
        if(sw_i != state_r && count_r < DEBOUNCE_LIMIT)
          count_r <= count_r + 1; // counter
        else if(count_r == DEBOUNCE_LIMIT)
          begin
            count_r <= 0;
            state_r <= sw_i;
          end
        else 
          count_r <= 0;
   	end
  	
  	assign sw_o = sw_r;

endmodule