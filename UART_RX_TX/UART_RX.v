// UART Receiver

// CLOCK CYCLES PER_BIT = FREQUENCY / BAUD RATE
// 25000000 / 115200 = 217
module UART_RX #(parameter CLKS_PER_BIT = 217)
(
    input clk_i,
    input rx_serial_i,
    output rx_dv,
    output [7:0] rx_byte_o
);

    // Parameters for state for readability 
    parameter IDLE = 3'b000;
    parameter RX_START_BIT = 3'b001;
    parameter RX_DATA_BITS = 3'b010;
    parameter RX_STOP_BITS = 3'b011;
    parameter CLEANUP = 3'b100;

    reg [7:0] clk_count_r = 0;
    reg [2:0] bit_index_r = 0;
    reg [7:0] rx_byte_r;
    reg rx_dv_r;

    reg [2:0] SM_Main_r;

    // Handle Receiver State Machine
    always @(posedge clk_i) 
    begin
        case (SM_Main_r)
            // Initial State: No data currently being sent
            IDLE : 
                begin
                    rx_dv_r <= 1'b0;
                    clk_count_r <= 0;
                    bit_index_r <= 0;
                    if (rx_serial_i == 1'b0)
                        SM_Main_r <= RX_START_BIT;
                    else
                        SM_Main_r <= IDLE;
                end
            
            // Start bit detected
            RX_START_BIT :
                begin
                    // Sample data in the middle of data bit length 
                    if (clk_count_r == CLKS_PER_BIT / 2)
                    begin
                        if (rx_serial_i == 1'b0)
                        begin
                            clk_count_r <= 0;
                            SM_Main_r <= RX_DATA_BITS';
                        end
                        else
                            SM_Main_r <= IDLE;
                    end
                    else
                    begin
                        clk_count_r <= clk_count_r + 1;
                        SM_Main_r <= RX_START_BIT;
                    end
                end
            
            // Data received
            RX_DATA_BITS :
                begin
                    if (clk_count_r == CLKS_PER_BIT - 1)
                    begin
                        clk_count_r <= clk_count_r + 1;
                        SM_Main_r <= RX_DATA_BITS;
                    end
                    else
                    begin
                        clk_count_r <= 0;

                        // serial to parallel
                        rx_byte_r[bit_index_r] <= rx_serial_i;

                        // check for all bits:
                        if(bit_index_r < 7)
                        begin
                            bit_index_r <= bit_index_r + 1;
                            SM_Main_r <= RX_DATA_BITS;
                        end
                        else
                        begin
                            bit_index_r <= 0;
                            SM_Main_r <= RX_STOP_BITS;
                        end
                    end
                end
            
            // Stop bit detected
            RX_STOP_BITS :
            begin
                if (clk_count_r < CLKS_PER_BIT - 1)
                begin
                    clk_count_r <= clk_count_r + 1;
                    SM_Main_r <= RX_STOP_BITS;
                end           
                else
                begin
                    rx_dv_r <= 1'b1;
                    clk_count_r <= 0'
                    SM_Main_r <= CLEANUP;
                end
            end

            // Handle cleanup for one clock cycle
            CLEANUP :
            begin
                SM_Main_r <= IDLE;
                rx_dv_r <= 1'b0;
            end
            
            default: 
            SM_Main_r <= IDLE;
        endcase
    end
    
endmodule