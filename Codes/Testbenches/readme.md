# Testbenches 

---
## 📜 $display and $monitor difference 
```verilog
`timescale 1ns/1ps

module display_monitor_example;

    reg a, b;
    wire y;

    // Simple AND operation
    assign y = a & b;

    initial begin
        // Using $display
        $display("Using $display:");
        a = 0; b = 0; #5;
      $display("Display Time=%0t, a=%b, b=%b, y=%b", $time, a, b, y);

        a = 0; b = 1; #5;
      $display("Display Time=%0t, a=%b, b=%b, y=%b", $time, a, b, y);

        a = 1; b = 0; #5;
      $display("Display Time=%0t, a=%b, b=%b, y=%b", $time, a, b, y);

        a = 1; b = 1; #5;
      $display("Display Time=%0t, a=%b, b=%b, y=%b", $time, a, b, y);
    end

    initial begin
        // Using $monitor
        $monitor("Using $monitor: Time=%0t, a=%b, b=%b, y=%b", $time, a, b, y);
    end

endmodule

```
---
## 📜 AND_Gate Testbench
```verilog
// Code for AND Gate using data flow model 
module and_gate(
    input a,
    input b,
    output y
);
    assign y = a & b;
endmodule

//---- Testbench for AND_Gate

`timescale 1ns/1ps
module and_gate_tb;
    // Testbench signals
    reg a, b;
    wire y;

    // Instantiate the AND gate
    and_gate uut (.a(a),.b(b),.y(y));

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
---
## 📜 AND_Gate Testbench using for_loop  
```verilog
`timescale 1ns/1ps

module and_gate_tb;

    reg a, b;
    wire y;

    integer i; // loop variable

    // Instantiate the AND gate
    and_gate uut (
        .a(a),
        .b(b),
        .y(y)
    );

    initial begin
        $display("Time\t a b | y");
        $monitor("%0t\t %b %b | %b", $time, a, b, y);

        // Test all possible combinations using a for loop
        for (i = 0; i < 4; i = i + 1) begin
            {a, b} = i;  // assign loop index to inputs a and b
            #10;          // wait for 10 time units
        end

        $display("All test cases completed");
        $finish;
    end

endmodule
//-------------Explanation------------------------------------------------
//integer i; → loop variable from 0 to 3 (since 2 inputs → 4 combinations).
//{a, b} = i; → assigns the binary value of i to a and b.
//i = 0 → 00
//i = 1 → 01
//i = 2 → 10
//i = 3 → 11
//#10; → wait 10 time units between each input change.
//$monitor → prints output automatically whenever a, b, or y changes.
```
---
## 📜 Self Checking Testbench
```verilog
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
---
```
## 📜 Testbench using File read and write 
```verilog
`timescale 1ns / 1ps

module proc_8bitcomp(input [7:0]a,b , output reg e,l,g);
always@(*) begin
       if (a ==b) begin  
            e=1'b1; l = 1'b0; g = 1'b0;
       end  
       else if (a > b) begin  
            e=1'b0; l = 1'b0; g = 1'b1;
       end   
       if (a < b) begin  
            e=1'b0; l = 1'b1; g = 1'b0;
       end  
end
endmodule
//--- Testbench-----------------------------------------------------------
`timescale 1s / 1ms
//module proc_8bitcomp(input [7:0]a,b , output reg e,l,g);
module tb_proc8comp;
reg  [7:0]a,b;
wire e,l,g;
proc_8bitcomp DUT(a,b,e,l,g);
integer i,j,file_handle;
initial begin
//$monitor(" %0t  a=%d, b=%d, e=%b l=%b g=%b ",$time, a,b,e,l,g);
file_handle = $fopen("results.xls", "w");
        if (file_handle == 0) begin
            $display("Error: Could not open output file.");
        end
        $fdisplay(file_handle, "Time\tA\tB\tA>B\tA<B\tA=B");
end     
initial begin 
for(i = 0; i<256; i = i+1) begin 
#10;
    for(j = 0; j <256; j = j+1) begin
    #10; 
            a = i;
            b = j;
             $fdisplay(file_handle, "%0t\t%d\t%d\t%b\t%b\t%b", $time, a, b, g, l, e);
      end    
 end     
// Close the file
  $fclose(file_handle);
  $finish;   
end
endmodule
```
