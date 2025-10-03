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
```
---
## 📜 Memory Design (Dual Port RAM) 
```verilog
`timescale 1ns/1ps
//Dual port RAM module design.

module dual_port(
    input [7:0] data_a, data_b, //data inputs a & b
    input [5:0] addr_a, addr_b, //address inputs
    input we_a, we_b, // input wire enables for a and b
    input clk, // input clock
    output reg [7:0] q_a, q_b
);

reg [7:0] ram [63:0]; // 8 X 64 bit RAM

always @(posedge clk)
begin
    if(we_a)
        ram[addr_a] <= data_a;
    else
	q_a <= ram[addr_a];
end

always @(posedge clk)
begin
    if(we_b)
	ram[addr_b]<= data_b;
    else
	q_b <= ram[addr_b];
end
endmodule

//Dual Post RAM Testbench.

module dual_port_tb;
    reg [7:0] data_a, data_b;
    reg [5:0] addr_a, addr_b;
    reg we_a, we_b;
    reg clk;
    wire [7:0] q_a, q_b;

    dual_port uut (data_a, data_b, addr_a, addr_b, we_a, we_b, clk, q_a, q_b);

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(1, dual_port_tb);
        clk = 1'b1;
        forever #5 clk = ~clk;
    end

    initial begin

        addr_a = 6'd01;
        addr_b = 6'd02;
        we_a = 1'b1;
        we_b = 1'b1;

        data_a = 8'h10;
        data_b = 8'h20;
        #10; // Clock edge at time 10: Writes occur

        addr_a = 6'd03;
        addr_b = 6'd04;

        data_a = 8'h30;
        data_b = 8'h40;
        #10; // Clock edge at time 20: Writes occur

        we_a = 1'b0;
        addr_a = 6'd01;
        #10; // Clock edge at time 30: Read to q_a should occur
         // Small delay to observe q_a after the edge
        $display("Time = %0t, q_a = %h", $time, q_a);

        we_b = 1'b0;
        addr_b = 6'd02;
        #10; // Clock edge at time 40: Read to q_b should occur
          // Small delay to observe q_b after the edge
        $display("Time = %0t, q_b = %h", $time, q_b);

    end

    initial begin
        #100 $finish;
    end

endmodule
```
