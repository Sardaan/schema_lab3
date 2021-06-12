module main(
    input [7:0] a_i,
    input [7:0] b_i,
    input clk_i,
    input rst_i,
    input start_i,
    output [4:0] res_o,
    output [2:0]busy_o
    );
    localparam IDLE = 0;
    localparam WORK_CUBE1 = 1;
    localparam WORK_CUBE2 = 2;
    localparam SUM = 3;
    localparam WORK_SQUARE = 4;
    wire busy_cube;
    wire done_cube;
    wire done_square;
    wire busy_square;
    reg[7:0] a;
    reg[7:0] b;
    wire[2:0] b_cubed;
    reg[7:0] sum;
    reg rst_cube;
    reg rst_square;
    reg start_cube;
    reg start_square;
    reg [2:0]state;
    
    cube cube(
        .arg_i(b),
        .rst_i(rst_cube),
        .res(b_cubed),
        .busy_o(busy_cube),
        .start_i(start_cube),
        .clk_i(clk_i),
        .done_o(done_cube)
    );
    
    sqrt sqrt(
        .arg_i(sum),
        .rst_i(rst_square),
        .res(res_o),
        .busy_o(busy_square),
        .start_i(start_square),
        .clk_i(clk_i),
        .done_o(done_square)
    );
    
    assign busy_o = state;
    always @(posedge clk_i) begin
    if(rst_i) begin
    a <= 0;
    b <= 0;
    sum <= 0;
    rst_cube <= 1;
    rst_square <= 1;
    state <= IDLE;
    end else  begin 
        case(state)
            IDLE:
            if(start_i) begin
                a <= a_i;
                b <= b_i;
                state <= WORK_CUBE1;
                start_cube <= 1;
                rst_cube <= 0;
                rst_square <= 0;
            end
            WORK_CUBE1:
            begin
                start_cube <= 0;
                state <= WORK_CUBE2;
            end
            WORK_CUBE2:
            begin
                if(done_cube) begin
                    state <= SUM;
                end            
            end
            SUM:
            begin
                start_square <= 1;
                rst_square <= 0;
                sum <= b_cubed + a;
                state <= WORK_SQUARE;
            end
            WORK_SQUARE:
            begin
            start_square <= 0;
             if(done_square) begin
                state <= IDLE;
            end 
            end
        endcase
    end
    end
endmodule
