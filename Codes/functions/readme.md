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
