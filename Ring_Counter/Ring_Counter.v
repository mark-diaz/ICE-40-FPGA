module Ring_Counter (
    input clk_i,     // 25 MHz 
    input sw_i,     
    output LED_1_o,  
    output LED_2_o,
    output LED_3_o,
    output LED_4_o );

    // debounce switch
    reg sw_r;
    assign sw_w = sw_r;
    
  debounced_filter debounced_filter_inst(.clk_i(clk_i), .sw_i(sw_i), .sw_o(sw_w));

    // Divide clock to allow ring counter to rotate at 1 Hz
    wire clk_w;
    clock_divider #(.DIVISOR(25_000_000)) clk_div_inst (
        .clk_i(clk_i),
        .clk_o(clk_w)
    );

    // 4 bit Ring Counter
    reg[3:0] q = 4'b0000;

    always@ (posedge clk_w)
    begin
      sw_r <= sw_i;
      if(sw_i == 1'b1 && sw_r == 1'b0)
        begin
            q <= 4'b0001;
        end
        else
        begin
            q[1] <= q[0];
            q[2] <= q[1];
            q[3] <= q[2];
            q[0] <= q[3];
        end
    end

    assign {LED_4_o, LED_3_o, LED_2_o, LED_1_o} = q;

endmodule

module clock_divider #(parameter DIVISOR = 25_000_000) (
    input clk_i,
    output clk_o);
  
    reg state_r;
    reg [$clog2(DIVISOR)-1:0] count_r = 0;

    always@ (posedge clk_i)
    begin
        if(count_r < DIVISOR - 1) 
        begin
          	state_r <= 0;
            count_r <= count_r + 1;
        end
        else 
        begin
            count_r <= 0;
            state_r <= ~state_r;
      	end
    end

  assign clk_o = state_r;

endmodule

module debounced_filter (
    input clk_i, 
    input sw_i, 
    output sw_o );
  
  	reg sw_r;

    // Divide clock to debounce switch
    wire clk_w;
    clock_divider #(.DIVISOR(20)) clk_div_inst (
        .clk_i(clk_i),
        .clk_o(clk_w)
    );
  
    always @(posedge clk_w)
    begin
        sw_r <= sw_i; // can only non-block with regs
   	end
  	
  	assign sw_o = sw_r;

endmodule