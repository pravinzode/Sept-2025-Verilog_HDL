# Finite State Machines 
## Moore Sequential State Machines 
---
## 📜 Moore 101 Detector ( overlapping allowed) 
---
```verilog
`timescale 1ns/100ps
module moore_detector (
    input x, rst, clk,
    output z
);
  // State encoding
  localparam [1:0]
    reset  = 0,
    got1   = 1,
    got10  = 2,
    got101 = 3;

  reg [1:0] current;

  // State transition
  always @(posedge clk) begin
    if (rst)
      current <= reset;
    else begin
      case (current)
        reset:  current <= (x == 1'b1) ? got1   : reset;
        got1:   current <= (x == 1'b0) ? got10  : got1;
        got10:  current <= (x == 1'b1) ? got101 : reset;
        got101: current <= (x == 1'b1) ? got1   : got10;
        default: current <= reset;
      endcase
    end
  end

  // Output logic (Moore: depends only on state)
  assign z = (current == got101) ? 1'b1 : 1'b0;

endmodule

// Testbench for Moore sequence detector

`timescale 1ns/100ps
module tb_moore_detector;

  reg clk, rst, x;
  wire z;
  wire [1:0]current;   

  // Instantiate the DUT (Device Under Test)
  moore_detector dut (
    .x(x),
    .rst(rst),
    .clk(clk),
    .z(z)
  );
   assign current=dut.current 
  // Clock generation: 10 ns period
  initial clk = 0;
  always #5 clk = ~clk;  

  // Apply stimulus
  initial begin
    // Initialize
    rst = 1; x = 0;
    #8;                // keep reset active for >1 clock
    rst = 0;            // release reset

    // Apply input sequence: 1010101
    // Expected detection at every "101"
    x = 1; #10;   // input = 1
    x = 0; #10;   // input = 0
    x = 1; #10;   // input = 1 -> sequence "101" detected here
    x = 0; #10;   // input = 0
    x = 1; #10;   // input = 1 -> another "101"
    x = 1; #10;   // input = 1
    x = 0; #10;   // input = 0 -> new "10"
    x = 1; #10;   // input = 1 -> sequence "101" again

    #20;
    $finish;
  end

  // Monitor outputs
  initial begin
    $monitor("Time=%0t | x=%b | rst=%b | state=%0d | z=%b",
              $time, x, rst, dut.current, z);
  end

endmodule
```
---
## 📜 Moore 101/110 Detector ( overlapping allowed) 
---
```verilog
`timescale 1ns/100ps

// State definitions using macros
`define reset   3'b000
`define got1    3'b001
`define got10   3'b010
`define got11   3'b011
`define got101  3'b100
`define got110  3'b101

module moore_detector_101_110 (
    input x, rst, clk,
    output z
);
  reg [2:0] current;

  // State transition
  always @(posedge clk or posedge rst) begin
    if (rst)
      current <= `reset;
    else begin
      case (current)
        `reset:   current <= (x==1'b1) ? `got1   : `reset;
        `got1:    current <= (x==1'b0) ? `got10  : `got11;
        `got10:   current <= (x==1'b1) ? `got101 : `reset;
        `got11:   current <= (x==1'b1) ? `got11  : `got110;
        `got101:  current <= (x==1'b1) ? `got11  : `got10;
        `got110:  current <= (x==1'b1) ? `got101 : `reset;
        default:  current <= `reset;
      endcase
    end
  end

  // Moore output logic
  assign z = (current == `got101 || current == `got110);

endmodule

// Testbench for 101 and 110 Moore sequence detector
`timescale 1ns/100ps
module tb_moore_detector_101_110;

  reg clk, rst, x;
  wire z;

  // Instantiate DUT
  moore_detector3 dut (
    .x(x),
    .rst(rst),
    .clk(clk),
    .z(z)
  );

  // Clock generation: 10 ns period
  initial clk = 0;
  always #5 clk = ~clk;

  // Stimulus
  initial begin
    // Reset sequence
    rst = 1; x = 0;
    #8; 
    rst = 0;

    // Apply inputs: check both "101" and "110"
    // Expected z=1 when "101" or "110" occurs
    x = 1; #10;   // got1
    x = 0; #10;   // got10
    x = 1; #10;   // got101 -> detect "101" 
    x = 1; #10;   // got11
    x = 0; #10;   // got110 -> detect "110" 
    x = 1; #10;   // got101 -> detect "101" 
    x = 0; #10;   // got10
    x = 1; #10;   // got101 -> detect "101" 
    x = 0; #10;   // reset

    #30;
    $finish;
  end

  // Monitor signals
  initial begin
    $monitor("Time=%0t | x=%b | rst=%b | state=%0d | z=%b",
              $time, x, rst, dut.current, z);
  end

endmodule
```
---
## 📜 Mealy 101 Detector ( overlapping allowed) 
---
```verilog
`timescale 1ns/100ps

module mealy_101 (
    input x,
    input rst,
    input clk,
    output z
);

    // State encoding
    localparam [1:0] 
        RESET  = 2'b00, // 0 0
        GOT1   = 2'b01, // 0 1
        GOT10  = 2'b10; // 1 0

    reg [1:0] current;

    // State transitions
    always @(posedge clk) begin
        if (rst)
            current <= RESET;
        else
            case (current)
                RESET:  current <= (x==1'b1) ? GOT1 : RESET;
                GOT1:   current <= (x==1'b0) ? GOT10 : GOT1;
                GOT10:  current <= (x==1'b1) ? GOT1 : RESET;
                default: current <= RESET;
            endcase
    end

    // Output logic (Mealy)
    assign z = (current == GOT10 && x==1'b1) ? 1'b1 : 1'b0;

endmodule
// testbench for Mealy 101 detector
`timescale 1ns/100ps

module tb_mealy_detector2;

    reg clk, rst, x;
    wire z;

    // Instantiate DUT
    mealy_detector2 UUT (
        .x(x),
        .rst(rst),
        .clk(clk),
        .z(z)
    );

    // Clock generation
    initial clk = 0;
    always #5 clk = ~clk; // 10ns period

    // Test stimulus
    initial begin
        // Initialize
        rst = 1; x = 0;
        #10; 
        rst = 0;

        // Apply sequence: 1 0 1 1 0 1 0 1
        x = 1; #10;
        x = 0; #10;
        x = 1; #10;
        x = 1; #10;
        x = 0; #10;
        x = 1; #10;
        x = 0; #10;
        x = 1; #10;

        #20 $finish;
    end

    // Monitor signals
    initial begin
        $display("Time\tclk\trst\tx\tz");
        $monitor("%0dns\t%b\t%b\t%b\t%b", $time, clk, rst, x, z);
    end

endmodule
```
---
## 📜 Mealy 1010 Detector ( overlapping allowed) 
---
```verilog
module mealy_fsm_1010 (
    input din,
    input clk,
    input reset,
    output reg y
);

reg [1:0] cst, nst;

parameter S0 = 2'b00,
          S1 = 2'b01,
          S2 = 2'b10,
          S3 = 2'b11;

// Next state and output logic (Mealy FSM)
always @(*) begin
    case (cst)
        S0: if (din) begin
                nst = S1; y = 1'b0;
            end else begin
                nst = S0; y = 1'b0;
            end
        S1: if (~din) begin
                nst = S2; y = 1'b0;
            end else begin
                nst = S1; y = 1'b0;
            end
        S2: if (din) begin
                nst = S3; y = 1'b0;
            end else begin
                nst = S0; y = 1'b0;
            end
        S3: if (~din) begin
                nst = S0; y = 1'b1;   // Output asserted on this transition
            end else begin
                nst = S1; y = 1'b0;
            end
        default: begin
            nst = S0; y = 1'b0;
        end
    endcase
end

// State transition
always @(posedge clk or posedge reset) begin
    if (reset)
        cst <= S0;
    else
        cst <= nst;
end

endmodule

//----Testbench for 1010 Mealy Sequence Detector
`timescale 1ns/1ps
module tb_mealy_fsm_1010;

reg din, clk, reset;
wire y;

// Instantiate DUT
melfsm uut (
    .din(din),
    .clk(clk),
    .reset(reset),
    .y(y)
);

// Clock generation
always #5 clk = ~clk;

initial begin
    // Monitor signals
    $monitor("Time=%0t | din=%b | state=%b | y=%b", $time, din, uut.cst, y);

    // Initialize
    clk = 0;
    reset = 1; din = 0;
    #8 reset = 0;

    // Apply input sequence to test FSM
    // Sequence: 1 → 0 → 1 → 0 should generate y=1 at the end
    #10 din = 1;
    #10 din = 0;
    #10 din = 1;
    #10 din = 0;  // Here output y should become 1

    // More random sequences
    #10 din = 1;
    #10 din = 1;
    #10 din = 0;
    #10 din = 1;
    #10 din = 0;

    #20 $finish;
end

endmodule
```
