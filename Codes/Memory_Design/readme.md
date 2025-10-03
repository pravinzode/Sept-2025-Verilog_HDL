# Memory Design
---
## 📜 Memory Design 
`verilog
`timescale 1ns/1ps

module rw4x4_async (
    output reg [3:0] data_out,
    input wire [1:0] address,
    input wire WE,
    input wire [3:0] data_in
);

    // 4x4 memory array (4 locations, each 4 bits wide)
    reg [3:0] RW [0:3];

    always @ (address or WE or data_in) begin
        if (WE) begin
            // Write operation
            RW[address] = data_in;
        end else begin
            // Read operation
            data_out = RW[address];
        end
    end
endmodule
