# Memory Design

---
## 📜 Memory Design (Asynchronous ROM (Read Only Memory) 4x4) 
```verilog
`timescale 1ns/1ps

module rom4x4_async (
    output reg [3:0] data_out,
    input wire [1:0] address
);

    always @ (address) begin
        case (address)
            2'b00 : data_out = 4'b1110; // 14
            2'b01 : data_out = 4'b0010; // 2
            2'b10 : data_out = 4'b1111; // 15
            2'b11 : data_out = 4'b0100; // 4
            default: data_out = 4'bxxxx; // undefined
        endcase
    end
endmodule
// Testbench
`timescale 1ns/1ps

module tb_rom4x4_async;
    reg [1:0] address;
    wire [3:0] data_out;

    // Instantiate DUT
    rom4x4_async dut (
        .data_out(data_out),
        .address(address)
    );

    initial begin
        // Dump waveforms
        $dumpfile("rom4x4_async.vcd");
        $dumpvars(0, tb_rom4x4_async);

        $monitor("Time=%0t | Address=%b | Data_out=%b",
                  $time, address, data_out);

        // Test all addresses
        address = 2'b00; #5;
        address = 2'b01; #5;
        address = 2'b10; #5;
        address = 2'b11; #5;

        // Try an invalid address (not used here since it's 2-bit only)
        address = 2'bxx; #5;

        $finish;
    end
endmodule
```
---
## 📜 Memory Design (Synchronous ROM 4x4) 
```verilog
module rom_4x4_sync (
    output reg [3:0] data_out,
    input wire [1:0] address,
    input wire clock
);

always @(posedge clock) begin
    case (address)
        2'b00: data_out = 4'b1110;
        2'b01: data_out = 4'b0010;
        2'b10: data_out = 4'b1111;
        2'b11: data_out = 4'b0100;
        default: data_out = 4'bxxxx;
    endcase
end

endmodule
// Testbench for this
`timescale 1ns/1ps

module tb_rom_4x4_sync;

reg [1:0] address;
reg clock;
wire [3:0] data_out;

// Instantiate the ROM module
rom_4x4_sync UUT (
    .data_out(data_out),
    .address(address),
    .clock(clock)
);

// Clock generation: 10ns period
initial clock = 0;
always #5 clock = ~clock;

// Test stimulus
initial begin
    // Display header
    $display("Time\tClock\tAddress\tData_out");
    $monitor("%0dns\t%b\t%b\t%b", $time, clock, address, data_out);

    // Initialize address
    address = 2'b00;
    #10 address = 2'b01;
    #10 address = 2'b10;
    #10 address = 2'b11;
    #10 address = 2'b00;

    #20 $finish; // End simulation
end

endmodule
```

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

