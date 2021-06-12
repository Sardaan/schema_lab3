module cube(

    input [7:0] arg_i,
    input clk_i,
    input rst_i,
    input start_i,
    output reg [2:0] res,
    output busy_o,
    output done_o
    );
    
   

    localparam IDLE = 0;
    localparam WORK_INIT = 1;
    localparam WORK_1 = 2;
    localparam WORK_2 = 3;
    localparam WORK_3 = 4;
    localparam WORK_4 = 5;
    localparam WORK_5 = 6;
    localparam WORK_6 = 7;
    localparam WORK_7 = 8;

    reg[4:0] state;
    reg[7:0] arg;
    reg done;
    reg[2:0] y;
    reg[7:0] s;
    reg[7:0] b;
    
    
    reg[7:0] mul_a;
    reg[7:0] mul_b;
    reg s_pos;
    reg mul_start;
    wire[15:0] mul_out;
    wire mul_busy;
    
    mult mult(
        .clk_i(clk_i),
        .rst_i(rst_i),
        .a_bi(mul_a),
        .b_bi(mul_b),
        .start_i(mul_start),
        .busy_o(mul_busy),
        .y_bo(mul_out)
    );
    
    assign busy_o = state > 0;
    assign done_o = done;
    always @(posedge clk_i) begin
    if(rst_i) begin
        arg <= 0;
        res <= 0;
        done <= 0;
        state <= IDLE;
    end else  begin 
        case(state)
            IDLE:
            if(start_i) begin
            arg <= arg_i;
            y <= 0;
            s <= 6;
            s_pos <= 1;
            b <= 0;
            state <= WORK_INIT;
            end
            WORK_INIT:
            begin
                if(s > 253 || s < 7) begin
                    y <= y << 1;
                    state <= WORK_1;
                    
                end else begin
                    res <= y;
                    state <= IDLE;
                    done <= 1;
                end
            end
            WORK_1:
            begin
                mul_a <= y + 1;
                mul_b <= y;
                mul_start <= 1;
                state <= WORK_2;
            end
            WORK_2:
            begin
                if(mul_busy == 0 && mul_start == 0) begin
                    mul_a <= mul_out;
                    mul_b <= 3;
                    mul_start <= 1;
                    state <= WORK_3;
                end else begin
                    mul_start <= 0;
                end
            end
            WORK_3:
            begin
                if(mul_busy == 0 && mul_start == 0) begin
                    b <= mul_out;
                    state <= WORK_4;
                end else begin
                    mul_start <= 0;
                end
            end
            WORK_4:
            begin
                b <= b + 1;
                state <= WORK_5;
            end
            WORK_5:
            begin
                b <= b << s;
                state <= WORK_6;
            end
            WORK_6:
            begin
                if(arg >= b) begin
                    arg <= arg - b;
                    y <= y + 1;
                end
                state <= WORK_7;
            end
            WORK_7:
            begin
                s <= s - 3;
                state <= WORK_INIT;
            end
        endcase
    end
    end
endmodule
