module Ring_Counter (
    input clk_i,     // Lattice ICE40: 25 MHz Clock
    input sw_i,     
    output LED_1_o,  
    output LED_2_o,
    output LED_3_o,
    output LED_4_o );

    // holds state of switch
    reg sw_r;
    
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
            q <= {q[2:0], q[3]};
        end
    end

    assign {LED_4_o, LED_3_o, LED_2_o, LED_1_o} = q;

endmodule

module clock_divider #(parameter DIVISOR = 25_000_000) (
    input clk_i,
    output clk_o);
  
    reg clk_r;
    reg [$clog2(DIVISOR)-1:0] count_r = 0;

    always@ (posedge clk_i)
    begin
        if(count_r < DIVISOR - 1) 
        begin
          	clk_r <= 0;
            count_r <= count_r + 1;
        end
        else 
        begin
            count_r <= 0;
            clk_r <= ~clk_r;
      	end
    end

  assign clk_o = clk_r;

endmodule

// A simple module to debounce a switch utilizing a clock divider: not necessary because 1 Hz clock is used for Ring Counter
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
        sw_r <= sw_i; 
   	end
  	
  	assign sw_o = sw_r;

endmodule