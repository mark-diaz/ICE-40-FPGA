module Ring_Counter
    (input sw,
    input clk,
    output LED_1,
    output LED_2,
    output LED_3,
    output LED_4
);

reg q1, q2, q3, q4;

assign LED_1 = q1;
assign LED_2 = q2;
assign LED_3 = q3;
assign LED_4 = q4;

always@(posedge clk or posedge sw) 
begin
    if(sw) begin
        q1 <= 1'b1;
        q2 <= 1'b0;
        q3 <= 1'b0;
        q4 <= 1'b0;
    end
    else begin
        q1 <= q4;
        q2 <= q1;
        q3 <= q2;
        q4 <= q3;
    end
end

endmodule

// Internally creating 4 D Flip-Flops chained together
module dff 
    (input clk, 
    input d, 
    output reg q);
    
    always@(posedge clk)
    begin
        q <= d;
    end
endmodule