// https://www.edaplayground.com/x/6u6S

// This test bench instantiates both the transmitter and receiver and sends a byte of data

`timescale 1ns/10ps

`include "UART_RX.v"

module UART_tb ();
    // 25 Mhz clock
    // 115200 Baud Rate
    
    // 1 / 25 000 000 Mhz = 40 ns
    parameter CLK_PERIOD = 40;
    
    // 25 000 000 / 115 200 = 217
    parameter CLKS_PER_BIT = 217;

    // 1 / 115 200 = 8600
    parameter BIT_PERIOD = 8600; 

    reg clk_r = 0;
    reg tx_dv_r = 0;
    wire rx_dv_w;
    wire tx_active_w;
    wire UART_line_w;
    wire tx_serial_w;
    reg [7:0] tx_byte_r = 0;
    wire [7:0] rx_byte_w;

    // Receiver
    UART_RX #(.CLKS_PER_BIT(CLKS_PER_BIT)) UART_RX_uut
    (
        .clk_i(clk_r),
        .rx_serial_i(UART_line_w),
        .rx_dv_o(rx_dv_w),
        .rx_byte_o(rx_byte_w)
    );

    // Transmitter
    UART_TX #(.CLKS_PER_BIT(CLKS_PER_BIT)) UART_TX_uut
    (
        .clk_i(clk_r),
        .tx_dv_i(tx_dv_r),
        .tx_byte_i(tx_byte_r),
        .tx_active_o(tx_active_w),
        .tx_serial_o(tx_serial_w),
        .tx_done_o()
    );
    
    // UART Transmit 1 (high) when not active 
    assign UART_line_w = tx_active_w ? tx_serial_w : 1'b1;

    always #(CLK_PERIOD / 2) clk_r <= ~clk_r;

    initial 
    begin
        @(posedge clk_r);
        @(posedge clk_r);
        tx_dv_r <= 1'b1; // data valid
        tx_byte_r <= 8'hAB;

        @(posedge clk_r);
        tx_dv_r <= 1'b0;

        // wait until receiver data is valid
        @(posedge rx_dv_w);

        if(rx_byte_w == 8'hAB)
            $display("Test Passed - Correct Byte Received!");
        else
            $display("Test Failed - Incorrect Byte Received!");
        $finish();
    end
   
    initial 
    begin
        $dumpfile("dump.vcd");
        $dumpvars(1, UART_tb);
    end

endmodule