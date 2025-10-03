# Memory Design

---
## 📜 Memory Design (4x4 Read/Write Asychronous) 
```verilog
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

// Testbench for above memory
`timescale 1ns/1ps

module tb_rw4x4_async;
    // Testbench signals
    reg [1:0] address;
    reg WE;
    reg [3:0] data_in;
    wire [3:0] data_out;

    // Instantiate DUT
    rw4x4_async dut (
        .data_out(data_out),
        .address(address),
        .WE(WE),
        .data_in(data_in)
    );

    initial begin
        // Dump waveforms for GTKWave
        $dumpfile("rw4x4_async.vcd");
        $dumpvars(0, tb_rw4x4_async);

        $monitor("Time=%0t | WE=%b | Addr=%b | Data_in=%b | Data_out=%b",
                  $time, WE, address, data_in, data_out);

        // Initial values
        WE = 0; address = 0; data_in = 0;

        #5;
        // Write operations
        WE = 1; address = 2'b00; data_in = 4'b1010; #5;
        WE = 1; address = 2'b01; data_in = 4'b1100; #5;
        WE = 1; address = 2'b10; data_in = 4'b1111; #5;
        WE = 1; address = 2'b11; data_in = 4'b0011; #5;

        // Read operations
        WE = 0; address = 2'b00; #5;
        WE = 0; address = 2'b01; #5;
        WE = 0; address = 2'b10; #5;
        WE = 0; address = 2'b11; #5;

        $finish;
    end
endmodule

