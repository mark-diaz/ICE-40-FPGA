module UART_RX_tb();
    // 25 Mhz clock
    // 115200 Baud Rate
    
    // 1 / 25 000 000 Mhz = 40 ns
    parameter CLK_PERIOD = 40;
    
    // 25 000 000 / 115 200 = 217
    parameter CLKS_PER_BIT = 217;

    // 1 / 115 200 = 8600
    parameter BIT_PERIOD = 8600; 

    reg clk_r = 0;
    reg rx_serial_r = 1'b1; // start at 1 
    wire [7:0] rx_byte_w;

    // convert input to serial
    task  UART_write_byte;

    input [7:0] data_i;
    integer i;
    begin
        // Start Bit
        rx_serial_r <= 1'b0;
        #(BIT_PERIOD);
        #1000;

        // Data Bits
        for(i = 0; i < 8; i = i + 1)
        begin
            rx_serial_r <= data_i[i];
            #(BIT_PERIOD);
        end

        // Stop Bit
        rx_serial_r <= 1'b1;
        #(BIT_PERIOD);
    end
        
    endtask 

    UART_RX #(.CLKS_PER_BIT(CLKS_PER_BIT)) UART_RX_uut
    (
        .clk_i(clk_r),
        .rx_serial_i(rx_serial_r),
        .rx_dv_o(),
        .rx_byte_o(rx_byte_w)
    );

    always #(CLK_PERIOD / 2) clk_r = ~clk_r;

    initial 
    begin
        // send command to UART
        @(posedge clk_r);
            UART_write_byte(8'hAB);

        @(posedge clk_r);

        if(rx_byte_w == 8'hAB)
            $display("Test Passed - Correct Byte Received! :)");
        else
            $display("Test Failed - Incorrect Byte Received! :(");

        $finish();

    end

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1, UART_RX_tb);
    end
endmodule