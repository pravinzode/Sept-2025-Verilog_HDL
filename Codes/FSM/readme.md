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

  // Instantiate the DUT (Device Under Test)
  moore_detector dut (
    .x(x),
    .rst(rst),
    .clk(clk),
    .z(z)
  );

  // Clock generation: 10 ns period
  initial clk = 0;
  always #5 clk = ~clk;  

  // Apply stimulus
  initial begin
    // Initialize
    rst = 1; x = 0;
    #12;                // keep reset active for >1 clock
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

