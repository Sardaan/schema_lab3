module sqrt(
    input [7:0] arg_i,
    input clk_i,
    input rst_i,
    input start_i,
    output reg [4:0] res,
    output busy_o,
    output done_o
    );
    
    localparam IDLE = 0;
    localparam WORK_1 = 1;
    localparam WORK_2 = 2;
    localparam WORK_3 = 3;
    
    reg [7:0] x;
    reg [7:0] part_result;
    reg [7:0] b;
    reg [6:0] m;
    reg [1:0] state;
    reg done;
    wire end_step;
    wire x_above_b;
    assign end_step = (m == 0);
    assign x_above_b = (x >= b);
    assign busy_o = state;
    assign done_o = done;
    
    always @(posedge clk_i)
        if (rst_i) begin
            res <= 0;
            b <= 0;
            done <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE:
                    if(start_i) begin
                        state <= WORK_1;
                        part_result <= 0;
                        x <= arg_i;
                        m <= 7'b1000000;
                    end 
                WORK_1:
                    begin
                        if (!end_step) begin
                            b <= part_result | m;
                            part_result <= part_result >> 1;
                            state <= WORK_2;
                        end else begin
                            res <= part_result[4:0];
                            state <= IDLE;
                        end
                    end 
                WORK_2:
                    begin
                        if (x_above_b) begin
                            x <= x - b;
                            part_result <= part_result | m;
                        end
                        state <= WORK_3;
                    end     
                WORK_3:
                    begin
                        m <= m >> 2;
                        state <= WORK_1;
                    end
                endcase
            end        
endmodule
