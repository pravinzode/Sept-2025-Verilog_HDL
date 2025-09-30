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
    //$setuphold(reference_event, data_event, setup_limit, hold_limit[, notifier]);
    $setuphold(posedge clk,d,2,2,notifier);
  endspecify
  always @(posedge clk) begin
    q <= d;
  end

  // Timing specification
 

endmodule

// Filename: testbench.v
module setup_hold_tb;
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
    $dumpvars(0, setup_hold_tb);

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
---
## 📜 $width
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
    //$width(<signal to check>,size)
    $width(posedge d,5);
  endspecify
  always @(posedge clk) begin
    q <= d;
  end

  // Timing specification
 

endmodule

// Filename: testbench.v
module width_tb;
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
    $dumpvars(0, width_tb);

    // Test 1: Normal operation (no setup violation)
    #10 d = 1;  // Change d well before posedge clk (at time 15)
    #10 d = 0;  // Change d well before posedge clk (at time 25)

    // Test 2: Setup violation (change d too close to posedge clk)
    #6 d = 1;   // Change d at time 28 (2 units before posedge at time 30)
    #1 d = 0;   // Change d at time 35 (no violation)

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
## 📜 $setup and $hold in one module 
```verilog
module dff_module(
input wire clk,
input wire d,
output reg q
);
reg setupVoilation;
reg holdVoilation;

specify
(d => q) = 1;
$setup(d, posedge clk, 2, setupVoilation);
$hold( posedge clk,d , 2, holdVoilation);
endspecify

always @(posedge clk) begin
q <= d;
end

endmodule

module tb_setup;
reg clk;
reg d;
wire q;

dff_module dff1(clk, d, q);

always @ (dff1.setupVoilation) begin
$display("Setup Timing Voilation %0t \t %b",$time, dff1.setupVoilation);
end

always @ (dff1.holdVoilation) begin
$display("Hold Timing Voilation %0t \t %b",$time, dff1.holdVoilation);
end

initial begin
clk = 0;
forever #5 clk = ~clk;
end

initial begin
d = 0;
$display("-------------Start Simulation--------------");
#4 d = 1;
#12 d = 0;

#6 d = 1;
#12 d = 0;

#3 d = 1;
#9 d = 0;

#4 d = 1;
#10 d = 0;

#20 $finish;
$display("-------------End Simulation--------------");
end

initial begin
$monitor("Time::%0t \t clk::%b \t d::%b \t q::%b \t Setup Time Voilation::%b \t Hold Time Voilation::%b", $time, clk, d, q, dff1.setupVoilation, dff1.holdVoilation );
end
endmodule
```
---
## 📜 $recovery ( Similar to $setup used for Asynchronous timing check notification )  
```verilog
// Filename: dff_module.v
module dff_module (
  input wire clk,
  input wire d,reset,
  output reg q

);
reg notifier;
 // Notifier for timing violations
  specify
    // Setup time check: d must be stable 2 time units before posedge clk
    //$recovery(reference_event(control signals), data_event(usually clocks), limit[, notifier]);
    $recovery(reset,posedge clk,2,notifier);
  endspecify
  always @(posedge clk or posedge reset) begin
    if(reset)
        q = 1'b0;
    else
        q <= d;
  end

  // Timing specification
 

endmodule

// Filename: testbench.v
module recovery_tb;
  reg clk;
  reg d;
  reg reset;
  wire q;


  // Instantiate the D flip-flop module
  dff_module dff1 (
    .clk(clk),
    .d(d),
    .reset(reset),
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
    d = 1;
    reset = 0;
    
    #14 reset = 1;
    #1 reset = 0;
    // Dump variables for waveform
    $dumpfile("dff.vcd");
    $dumpvars(0, recovery_tb);

    // Test 1: Normal operation (no setup violation)
    #10 d = 1;  // Change d well before posedge clk (at time 15)
    #10 d = 0;  // Change d well before posedge clk (at time 25)

    // Test 2: Setup violation (change d too close to posedge clk)
    #6 d = 1;   // Change d at time 28 (2 units before posedge at time 30)
    #7 d = 0;   // Change d at time 35 (no violation)

    // Test 3: Another normal operation
    #13 d = 1;  // Change d at time 46 (well before posedge at 50)
    #10 d = 0;  // Change d at time 56

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
## 📜 $removal ( Similar to $hold used for Asynchronous timing check notification )  
```verilog
// Filename: dff_module.v
module dff_module (
  input wire clk,
  input wire d,reset,
  output reg q

);
reg notifier;
 // Notifier for timing violations
  specify
    // Setup time check: d must be stable 2 time units before posedge clk
    //$removal(reference_event(control signals), data_event(usually clocks), limit[, notifier]);
    $removal(reset,posedge clk,2,notifier);
  endspecify
  always @(posedge clk or posedge reset) begin
    if(reset)
        q = 1'b0;
    else
        q <= d;
  end

  // Timing specification
 

endmodule

// Filename: testbench.v
module removal_tb;
  reg clk;
  reg d;
  reg reset;
  wire q;


  // Instantiate the D flip-flop module
  dff_module dff1 (
    .clk(clk),
    .d(d),
    .reset(reset),
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
    d = 1;
    reset = 0;
    
    #15 reset = 1;
    #3 reset = 0;
    // Dump variables for waveform
    $dumpfile("dff.vcd");
    $dumpvars(0, removal_tb);

    // Test 1: Normal operation (no setup violation)
    #10 d = 1;  // Change d well before posedge clk (at time 15)
    #10 d = 0;  // Change d well before posedge clk (at time 25)

    // Test 2: Setup violation (change d too close to posedge clk)
    #6 d = 1;   // Change d at time 28 (2 units before posedge at time 30)
    #7 d = 0;   // Change d at time 35 (no violation)

    // Test 3: Another normal operation
    #13 d = 1;  // Change d at time 46 (well before posedge at 50)
    #10 d = 0;  // Change d at time 56

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

