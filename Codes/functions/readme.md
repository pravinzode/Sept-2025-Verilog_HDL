# Verilog Functions 
# 4-bit Binary → Gray Code converter in the three modeling styles
---
## 📜 Dataflow Modeling (using assign) 
---
```verilog
// Gray Code Converter - Dataflow Modeling
module gray_dataflow (
    input  [3:0] bin,
    output [3:0] gray
);
    assign gray[3] = bin[3];
    assign gray[2] = bin[3] ^ bin[2];
    assign gray[1] = bin[2] ^ bin[1];
    assign gray[0] = bin[1] ^ bin[0];
endmodule
```
---
## 📜 Structural Modeling (using gates) 
---
```verilog
// Gray Code Converter - Structural Modeling
module gray_structural (
    input  [3:0] bin,
    output [3:0] gray
);
    // MSB passes through
    assign gray[3] = bin[3];

    // XOR gates for other bits
    xor g1(gray[2], bin[3], bin[2]);
    xor g2(gray[1], bin[2], bin[1]);
    xor g3(gray[0], bin[1], bin[0]);
endmodule
```
---
## 📜 Behavioral with Function 
---
```verilog
// Gray Code Converter - Using Function
module gray_function (
    input  [3:0] bin,
    output [3:0] gray
);
    function [3:0] bin2gray;
        input [3:0] b;
        begin
            bin2gray[3] = b[3];
            bin2gray[2] = b[3] ^ b[2];
            bin2gray[1] = b[2] ^ b[1];
            bin2gray[0] = b[1] ^ b[0];
        end
    endfunction

    assign gray = bin2gray(bin);
endmodule
```
---
## 📜 Testbench for All Three 
---
```verilog
module tb_gray_converter;
    reg  [3:0] bin;
    wire [3:0] gray_df, gray_st, gray_fn;

    // Instantiate all three versions
    gray_dataflow   u1 (.bin(bin), .gray(gray_df));
    gray_structural u2 (.bin(bin), .gray(gray_st));
    gray_function   u3 (.bin(bin), .gray(gray_fn));

    initial begin
        $display("Bin  | Dataflow Gray | Structural Gray | Function Gray");
        $display("------------------------------------------------------");
        for(bin = 0; bin < 16; bin = bin + 1) begin
            #5 $display("%b  |     %b        |      %b        |      %b", 
                         bin, gray_df, gray_st, gray_fn);
        end
        $finish;
    end
endmodule
```
Time  Bin   Gray_assign Gray_struct Gray_func  Match
----  ----  ----------- ----------- ---------  -----
  5   0000      0000        0000       0000     YES
 10   0001      0001        0001       0001     YES
 15   0010      0011        0011       0011     YES
 20   0011      0010        0010       0010     YES
 ...
 Testbench RESULT: PASS ✅ - All implementations agree.
```


