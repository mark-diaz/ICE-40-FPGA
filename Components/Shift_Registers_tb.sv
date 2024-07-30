module shift_register_tb;

    // Parameters, wires and regs needed to drive UUT
    parameter WIDTH = 32;
    reg data;
    reg clk = 1'b0;
    reg en;
    reg dir;
    reg rstn;
    
    wire [WIDTH-1:0] out;

    // instantiate UUT
    shift_register #(WIDTH) shift_register_UUT(
        .d_i(data), 
        .clk_i(clk), 
        .en_i(en),
        .dir_i(dir),
        .rstn_i(rstn),
        .reg_o(out)
    );

    // generate clock
    always#10 clk = ~clk;

    // initialize values for sim
    initial begin
      
        clk <= 0;
        data <= 1'b1;
        en <= 0;
        dir <= 0;
        rstn <= 0;

    end

    initial begin
     	$dumpfile("test.vcd");
   		$dumpvars(1, shift_register_tb);
        rstn <= 0;
        #20 rstn <= 1;
        en <= 1;

        // Alternate Data for 7 clock cycles
      	repeat (7) @(posedge clk)
            data <= ~data;
        
        // switch directions: right
        #10 dir <= 1;
        
        // Alternate Data for 7 clock cycles
      	repeat(7) @(posedge clk)
        	data <= ~data;

        $finish;

    end

    initial begin
$monitor ("rstn = %0b, data = %b, en = %b, dir = %b, out = %b", rstn, data, en, dir, out);
 	end

  
endmodule