# Generate Statement Codes
---
## 📜 4-bit AND using for_generate
```verilog
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
