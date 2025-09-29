# Verilog Functions 
## 4-bit Binary → Gray Code converter in the three modeling styles
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
// Notes:
//Dataflow (assign) — concise, maps directly to combinational logic.
//Structural (gate-level) — explicit XOR gate instantiations.
//Function — modular, reusable, same hardware but nicer when logic is reused.
```
---
## 📜 Function Calling Function 
## Cube function using Square function 
---
```verilog
module Cube_Function_Example;

    function [7:0] square;
        input [3:0] a;
        begin
            square = a * a; // Return value is assigned to the function name
        end
    endfunction
    
    function [15:0] cube;
        input [3:0] b;
        reg [7:0] b_sq;
        begin
            // CALLING FUNCTION 2 INSIDE FUNCTION 1
           // b_sq = square(b);
            
            cube = square(b) * b; // b^3 = b^2 * b
        end
    endfunction
    
    // Test the function
    initial begin
        $display("The cube of 2 is: %0d", cube(4'd2)); // Output: The cube of 3 is: 27
        $display("The cube of 3 is: %0d", cube(6'd3)); // Output: The cube of 5 is: 125
        $display("The cube of 4 is: %0d", cube(4'd4)); // Output: The cube of 3 is: 27
        $display("The cube of 5 is: %0d", cube(4'd5)); // Output: The cube of 3 is: 27
        $display("The cube of 6 is: %0d", cube(4'd6)); // Output: The cube of 3 is: 27
        $display("The cube of 7 is: %0d", cube(4'd7)); // Output: The cube of 3 is: 27
    end
endmodule
```
