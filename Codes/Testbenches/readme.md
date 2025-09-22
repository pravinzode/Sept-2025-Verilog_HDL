# Testbenches 

---
## 📜 AND_Gate Testbench
`timescale 1ns/1ps

module and_gate_tb;

    // Testbench signals
    reg a, b;
    wire y;

    // Instantiate the AND gate
    and_gate uut (
        .a(a),
        .b(b),
        .y(y)
    );

    // Stimulus
    initial begin
        $display("Time\t a b | y");
        $monitor("%0t\t %b %b | %b", $time, a, b, y);

        // Apply test vectors
        a = 0; b = 0; #10;
        a = 0; b = 1; #10;
        a = 1; b = 0; #10;
        a = 1; b = 1; #10;

        $display("Test completed");
        $finish;
    end

endmodule
```
// Code for AND Gate using data flow model 
module and_gate(
    input a,
    input b,
    output y
);
    assign y = a & b;
endmodule

//---- Testbench for AND_Gate

```

---
## 📜 Self Checking Testbench
```
//-----Design unit------------------------------------------------------- 
module and2 (
    input  wire a,
    input  wire b,
    output wire y
);
    assign y = a & b;
endmodule
//-------Testbench--------------------------------------------------------
`timescale 1ns/1ps

module tb_and2;
  reg a, b;
  wire y;
  integer pass_count = 0, fail_count = 0;

  // Instantiate DUT
  and2 dut (.a(a), .b(b), .y(y));

  initial begin
    $display("\n--- Self-checking Testbench for AND gate ---\n");
    $display("a b | DUT y | Expected | Result");
    $display("--------------------------------");

    // Test all input combinations
    a=0; b=0; #1; check_result;
    a=0; b=1; #1; check_result;
    a=1; b=0; #1; check_result;
    a=1; b=1; #1; check_result;

    $display("\nSummary: PASS=%0d, FAIL=%0d\n", pass_count, fail_count);
    $finish;
  end

  task check_result;
    if (y === (a & b)) begin
      $display("%b %b |   %b   |    %b     | PASS", a, b, y, (a & b));
      pass_count = pass_count + 1;
    end else begin
      $display("%b %b |   %b   |    %b     | FAIL", a, b, y, (a & b));
      fail_count = fail_count + 1;
    end
  endtask
endmodule

```
