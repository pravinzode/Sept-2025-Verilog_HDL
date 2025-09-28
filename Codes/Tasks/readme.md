# Verilog Task
## 4-bit Binary → Gray Code converter using Task 
---
## 📜 Binary → Gray Converter Using Task
---
```verilog
module bin2gray_task(
    input  [3:0] bin,
    output reg [3:0] gray
);
    // Task for conversion
    task bin_to_gray(input [3:0] b, output [3:0] g);
        begin
            g = b ^ (b >> 1);
        end
    endtask

    // Always block calling the task
    always @(*) begin
        bin_to_gray(bin, gray);
    end
endmodule
//---------------------------------------------------------------------------------
//Testbench for above program
`timescale 1ns/1ps
module tb_bin2gray_task;
    reg [3:0] bin;
    wire [3:0] gray;

    bin2gray_task uut (.bin(bin), .gray(gray));

    initial begin
        $dumpfile("tb_bin2gray_task.vcd");
        $dumpvars(0, tb_bin2gray_task);

        bin = 4'b0000; #10;
        bin = 4'b0001; #10;
        bin = 4'b0010; #10;
        bin = 4'b0101; #10;
        bin = 4'b1111; #10;

        $finish;
    end

    initial $monitor("time=%0t bin=%b gray=%b", $time, bin, gray);
endmodule
```
---
## 📜 Sum_Diff Task 
---
```verilog
module sum_diff_task(
    input  [3:0] a,
    input  [3:0] b,
    output reg [4:0] sum,
    output reg [4:0] diff
);

    // Task definition
    task compute;
        input  [3:0] x, y;
        output [4:0] s, d;
        begin
            s = x + y;
            d = x - y;
        end
    endtask

    // Call task inside always block
    always @(*) begin
        compute(a, b, sum, diff);
    end

endmodule

// Testbench for sum_diff_task

module tb_sum_diff_task;
    reg [3:0] a, b;
    wire [4:0] sum, diff;

    sum_diff_task uut (.a(a), .b(b), .sum(sum), .diff(diff));

    initial begin
        a = 4; b = 3; #10;
        a = 7; b = 2; #10;
        a = 9; b = 5; #10;
    end

    initial begin
        $monitor("time=%0t a=%d b=%d sum=%d diff=%d", $time, a, b, sum, diff);
    end
endmodule
```
---
## 📜 Square Task  
---
```verilog
module square_task(
    input  [3:0] num,
    output reg [7:0] result );

    // Task definition
    task compute_square;
        input [3:0] x;
        output [7:0] y;
        begin
            y = x * x;
        end
    endtask

    // Call task in combinational block
    always @(*) begin
        compute_square(num, result);
    end

endmodule

module tb_square_task;
    reg [3:0] num;
    wire [7:0] result;

    square_task uut (.num(num), .result(result));

    initial begin
        num = 3; #10;
        num = 5; #10;
        num = 8; #10;
    end

    initial begin
        $monitor("time=%0t num=%d square=%d", $time, num, result);
    end
endmodule
```
