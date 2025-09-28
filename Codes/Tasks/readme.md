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

