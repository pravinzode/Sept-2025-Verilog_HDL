# Generate Statement Codes
---
## 📜 4-bit AND using for_generate
```
module and4bit (
    input  [3:0] a,
    input  [3:0] b,
    output [3:0] y
);
    genvar i;
    generate
        for (i = 0; i < 4; i = i + 1) begin : and_loop
            assign y[i] = a[i] & b[i];
        end
    endgenerate
endmodule
```
---
## 📜 N-bit Ripple Carry Adder using for_generate
```
module ripple_adder #(parameter N = 4) (
    input  [N-1:0] a, b,
    input          cin,
    output [N-1:0] sum,
    output         cout
);
    wire [N:0] c;  // carry chain
    assign c[0] = cin;

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : adder_stage
            full_adder fa (
                .a(a[i]),
                .b(b[i]),
                .cin(c[i]),
                .sum(sum[i]),
                .cout(c[i+1])
            );
        end
    endgenerate

    assign cout = c[N];
endmodule
```
---
## 📜 Conditional Generate (use if and case inside generate blocks)
```verilog
module mux #(parameter USE_AND = 1) (
    input a, b,
    output y
);
    generate
        if (USE_AND) begin
            assign y = a & b;   // behaves like AND
        end else begin
            assign y = a | b;   // behaves like OR
        end
    endgenerate
endmodule
```
