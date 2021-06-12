module main_tb(

    );
    
    reg[7:0] a = 15;
    reg[7:0] b = 1;
    reg clk;
    reg rst;
    reg start;
    wire[4:0] out;
    wire [2:0] busy;
    wire done;
    main main_1(
        .a_i(a),
        .b_i(b),
        .clk_i(clk),
        .rst_i(rst),
        .start_i(start),
        .busy_o(busy),
        .res_o(out)
    );
    integer i;
    integer a_test = 0;
    integer b_test = 0;
    integer expected = 0;
    integer sqrt = 0;
    integer cbrt = 0;
    initial begin
    
    for(a_test = 0; a_test < 250; a_test=a_test+10) begin
    
        clk = 1; rst = 1; #1
        clk = 0; #1 clk = 1;
        a = a_test;
        b_test = b_test + 10;
        b = b_test;
        if (b_test == 0) begin
            cbrt = 0;
        end else if(b_test < 8) begin
            cbrt = 1;
        end else if(b_test < 27) begin
             cbrt = 2;
        end else if(b_test < 64) begin
            cbrt = 3;
        end else if(b_test < 125) begin
            cbrt = 4;
        end else if(b_test < 216) begin
            cbrt = 5;
        end else begin
            cbrt = 6;
        end
        a_test = cbrt + a_test; 
        if (a_test == 0) begin
            sqrt = 0;
        end else if(a_test < 4) begin
            sqrt = 1;
        end else if(a_test < 9) begin
            sqrt= 2;
        end else if(a_test < 16) begin
            sqrt = 3;
        end else if(a_test < 25) begin
            sqrt = 4;
        end else if(a_test < 36) begin
            sqrt = 5;
        end else if(a_test < 49) begin
            sqrt = 6;
        end else if(a_test < 64) begin
            sqrt = 7;
        end else if(a_test < 81) begin
            sqrt = 8;
        end else if(a_test < 100) begin
            sqrt = 9;
        end else if(a_test < 121) begin
            sqrt = 10;
        end else if(a_test < 144) begin
            sqrt = 11;
        end else if(a_test < 169) begin
            sqrt = 12;
        end else if(a_test < 196) begin
            sqrt = 13;
        end else if(a_test < 225) begin
            sqrt = 14;
        end else  begin
            sqrt = 15;
        end  
        expected = sqrt;
        #1 clk = 0; rst = 0;
        #1 clk = 1; start = 1;#1 clk = 0; start = 0;
        for(i = 0; i < 250; i=i+1)begin
            #1 clk = 1; #1 clk = 0;
            if(done==1) begin
             i = 251;
            end
        end
        $display("a=%0d, b=%0d, result=%0d, ok=%b", a, b_test, out, out == expected);
    end
    $display("end of tests");
    end
endmodule
