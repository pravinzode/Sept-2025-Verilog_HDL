# Timing Checks ( $setup , $hold, $setuphold, $width ) 
---
## 📜 $setup  
```verilog
// Filename: dff_module.v
module dff_module (
  input wire clk,
  input wire d,
  output reg q

);
reg notifier;
 // Notifier for timing violations
  specify
    // Setup time check: d must be stable 2 time units before posedge clk
    //$setup(data_event, reference_event, limit, notifier);
    $setup( d,posedge clk,2,notifier);
  endspecify
  always @(posedge clk) begin
    q <= d;
  end

  // Timing specification
 

endmodule

// Filename: testbench.v
module setup_tb;
  reg clk;
  reg d;
  wire q;


  // Instantiate the D flip-flop module
  dff_module dff1 (
    .clk(clk),
    .d(d),
    .q(q)
    //.notifier(notifier)
  );
  
  // Clock generation: 10 time unit period (5 units high, 5 units low)
  always@(dff1.notifier)begin
    $display("Timing Violation %0t\t%b",$time,dff1.notifier);
  end
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Stimulus and test cases
  initial begin
    // Initialize inputs
    d = 0;

    // Dump variables for waveform
    $dumpfile("dff.vcd");
    $dumpvars(0, setup_tb);

    // Test 1: Normal operation (no setup violation)
    #10 d = 1;  // Change d well before posedge clk (at time 15)
    #10 d = 0;  // Change d well before posedge clk (at time 25)

    // Test 2: Setup violation (change d too close to posedge clk)
    #4 d = 1;   // Change d at time 28 (2 units before posedge at time 30)
    #7 d = 0;   // Change d at time 35 (no violation)

    // Test 3: Another normal operation
    #10 d = 1;  // Change d at time 45 (well before posedge at 50)
    #10 d = 0;  // Change d at time 55

    // Test 4: Another setup violation
    #1 d = 1;   // Change d at time 56 (1 unit before posedge at 57)
    #10 d = 0;  // Change d at time 66

    // Run simulation for a bit longer
    #20 $finish;
  end

  // Monitor signals and timing violations
  initial begin
    $monitor("Time=%0t clk=%b d=%b q=%b notifier=%b ", $time, clk, d, q, dff1.notifier);
  end
endmodule
```
---
## 📜 $hold  
```verilog
// Filename: dff_module.v
module dff_module (
  input wire clk,
  input wire d,
  output reg q

);
reg notifier;
 // Notifier for timing violations
  specify
    // Setup time check: d must be stable 2 time units before posedge clk
    //$hold(reference_event, data_event, limit[, notifier]);
    $hold(posedge clk,d,2,notifier);
  endspecify
  always @(posedge clk) begin
    q <= d;
  end

  // Timing specification
 

endmodule

// Filename: testbench.v
module hold_tb;
  reg clk;
  reg d;
  wire q;


  // Instantiate the D flip-flop module
  dff_module dff1 (
    .clk(clk),
    .d(d),
    .q(q)
    //.notifier(notifier)
  );
  
  // Clock generation: 10 time unit period (5 units high, 5 units low)
  always@(dff1.notifier)begin
    $display("Timing Violation %0t\t%b",$time,dff1.notifier);
  end
  initial begin
    clk = 0;
    forever #5 clk = ~clk;
  end

  // Stimulus and test cases
  initial begin
    // Initialize inputs
    d = 0;

    // Dump variables for waveform
    $dumpfile("dff.vcd");
    $dumpvars(0, hold_tb);

    // Test 1: Normal operation (no setup violation)
    #10 d = 1;  // Change d well before posedge clk (at time 15)
    #10 d = 0;  // Change d well before posedge clk (at time 25)

    // Test 2: Setup violation (change d too close to posedge clk)
    #6 d = 1;   // Change d at time 28 (2 units before posedge at time 30)
    #7 d = 0;   // Change d at time 35 (no violation)

    // Test 3: Another normal operation
    #10 d = 1;  // Change d at time 45 (well before posedge at 50)
    #10 d = 0;  // Change d at time 55

    // Test 4: Another setup violation
    #1 d = 1;   // Change d at time 56 (1 unit before posedge at 57)
    #10 d = 0;  // Change d at time 66

    // Run simulation for a bit longer
    #20 $finish;
  end

  // Monitor signals and timing violations
  initial begin
    $monitor("Time=%0t clk=%b d=%b q=%b notifier=%b ", $time, clk, d, q, dff1.notifier);
  end
endmodule
```
---
## 📜 $setuphold 
```verilog
---
