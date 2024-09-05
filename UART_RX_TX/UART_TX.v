// https://www.edaplayground.com/x/6u6S

module UART_TX #(parameter CLKS_PER_BIT = 217)
(
    input clk_i,
    input tx_dv_i,
    input [7:0] tx_byte_i,
    output tx_active_o,
    output reg tx_serial_o,
    output tx_done_o
);

    // States for UART Transmitter
    parameter IDLE = 3'b000;
    parameter TX_START_BIT = 3'b001;
    parameter TX_DATA_BITS = 3'b010;
    parameter TX_STOP_BIT = 3'b011;
    parameter CLEANUP = 3'b100;

    reg [2:0] state_r = 0;
    reg [7:0] clk_count_r = 0;
    reg [2:0] bit_index_r = 0;
    reg [7:0] tx_data_r = 0;
    reg tx_done_r = 0;
    reg tx_active_r = 0;

    always @(posedge clk_i) 
    begin
        case (state_r)
            
            // Initial State: No data currently being sent            
            IDLE :
            begin
                tx_serial_o <= 1'b1; // stay high for idle
                tx_done_r <= 1'b0;
                clk_count_r <= 0;
                bit_index_r <= 0;

                if (tx_dv_i == 1'b1)
                begin
                    tx_active_r <= 1'b1;
                    tx_data_r <= tx_byte_i; // register byte on data valid pulse : extra check
                    state_r <= TX_START_BIT;
                end
                else
                begin
                    state_r <= IDLE;
                end
            end 

            // Send start bit: In UART start bit is 0
            TX_START_BIT :
            begin
                tx_serial_o <= 1'b0;

                // Wait full bit period to move onto transmitting data
                if (clk_count_r < CLKS_PER_BIT - 1)
                begin
                    clk_count_r <= clk_count_r + 1;
                    state_r <= TX_START_BIT;
                end
                else
                begin
                    clk_count_r <= 0;
                    state_r <= TX_DATA_BITS;
                end
            end 

            // Send the data bits
            TX_DATA_BITS :
            begin

                // drive the serial output with the current bit index
                tx_serial_o <= tx_data_r[bit_index_r];

                if (clk_count_r < CLKS_PER_BIT - 1)
                begin
                    clk_count_r <= clk_count_r + 1;
                    state_r <= TX_DATA_BITS;
                end
                else
                begin
                    clk_count_r <= 0;

                    // check if all bits have been sent out
                    if (bit_index_r < 7) 
                    begin
                        bit_index_r <= bit_index_r + 1;
                        state_r <= TX_DATA_BITS;                     
                    end
                    else
                    begin
                        bit_index_r <= 0;
                        state_r <= TX_STOP_BIT;
                    end
                end
            end 

            // Send Stop bit
            TX_STOP_BIT :
            begin
                tx_serial_o <= 1'b1;

                if (clk_count_r < CLKS_PER_BIT - 1)
                begin
                    clk_count_r <= clk_count_r + 1;
                    state_r <= TX_STOP_BIT;

                end
                else
                begin
                    tx_done_r <= 1'b1;
                    clk_count_r <= 0;
                    state_r <= CLEANUP;
                    tx_active_r <= 1'b0;
                end
            end 

            CLEANUP :
            begin
                tx_done_r <= 1'b1;
                state_r <= IDLE;
            end 

            default:
                state_r <= IDLE; 
        endcase
    end

    assign tx_active_o = tx_active_r;
    assign tx_done_o = tx_done_r;

endmodule