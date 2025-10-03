# Finite State Machine with Datapath (FSMD)
## Multiplier ( Repetative Addition ) 
![FSMD Multiplier Architecture]([images/FSMD_Multiplier_Architecture.PNG](https://github.com/pravinzode/Sept-2025-Verilog_HDL/blob/main/images/FSMD_Multiplier_Architecture.PNG))
---
## 📜 Multiplier Modules 
```verilog
`timescale 1ns/1ps
// ============================================
// MODULE 1: ADDER REGISTER
// This register stores the running sum during multiplication
// It can be cleared or updated based on control signals
// ============================================
module adder_reg (
    input clk,              // Clock signal
    input reset,            // Reset signal (clears register)
    input en,               // Enable signal (allows update)
    input clear,            // Clear signal (resets to 0)
    input [7:0] d,          // Data input (8 bits)
    output reg [7:0] q      // Data output (8 bits)
);

// This always block runs on every clock edge or reset
always @(posedge clk or posedge reset) begin
    if (reset)              // If reset is HIGH
        q <= 8'b00000000;   // Clear output to 0
    else if (clear)         // If clear is HIGH
        q <= 8'b00000000;   // Clear output to 0
    else if (en)            // If enable is HIGH
        q <= d;             // Store input data to output
    // If none of the above, q keeps its old value
end

endmodule

// ============================================
// MODULE 2: OUTPUT REGISTER
// This register stores the final result of multiplication
// ============================================
module out_reg (
    input clk,              // Clock signal
    input reset,            // Reset signal
    input en,               // Enable signal
    input [7:0] d,          // Data input (8 bits)
    output reg [7:0] q      // Data output (8 bits)
);

// This always block runs on every clock edge or reset
always @(posedge clk or posedge reset) begin
    if (reset)              // If reset is HIGH
        q <= 8'b00000000;   // Clear output to 0
    else if (en)            // If enable is HIGH
        q <= d;             // Store input data to output
end

endmodule

// ============================================
// MODULE 3: DOWN COUNTER
// This counter counts down from a starting value
// Used to track how many times we need to add
// ============================================
module down_counter (
    input clk,              // Clock signal
    input reset,            // Reset signal
    input load,             // Load signal (loads new value)
    input dec,              // Decrement signal (count down by 1)
    input [3:0] d,          // Data input (4 bits)
    output zero_tick,       // Output: HIGH when counter reaches 0
    output [3:0] q          // Current counter value
);

// Internal register to store counter value
reg [3:0] counter;

// This always block runs on every clock edge or reset
always @(posedge clk or posedge reset) begin
    if (reset)              // If reset is HIGH
        counter <= 4'b0000; // Clear counter to 0
    else if (load)          // If load is HIGH
        counter <= d;       // Load new value into counter
    else if (dec)           // If decrement is HIGH
        counter <= counter - 1; // Count down by 1
    // Otherwise counter keeps its value
end

// Output assignments
assign q = counter;                         // Output current counter value
assign zero_tick = (counter == 4'b0000);    // Output 1 when counter is 0

endmodule

// ============================================
// MODULE 4: FSM (Finite State Machine)
// This is the "brain" that controls the multiplication process
// It has 2 states: Load state and Multiply state
// ============================================
module fsm (
    input clk,              // Clock signal
    input reset,            // Reset signal
    input zero_tick,        // Input: HIGH when counter reaches 0
    output reg load,        // Output: Load counter
    output reg dec,         // Output: Decrement counter
    output reg clear_AR,    // Output: Clear adder register
    output reg update_AR,   // Output: Update adder register
    output reg update_OR    // Output: Update output register
);

// Define the two states
parameter LOAD_STATE = 1'b0;      // State 0: Load the counter
parameter MULTIPLY_STATE = 1'b1;   // State 1: Perform multiplication

// State register
reg current_state;

// State register update (sequential logic)
always @(posedge clk or posedge reset) begin
    if (reset)
        current_state <= LOAD_STATE;    // Start in LOAD_STATE after reset
    else begin
        // State transitions
        case (current_state)
            LOAD_STATE:
                current_state <= MULTIPLY_STATE;    // Move to multiply state
                
            MULTIPLY_STATE:
                if (zero_tick)                      // If counter is 0
                    current_state <= LOAD_STATE;    // Go back to load state
                else
                    current_state <= MULTIPLY_STATE; // Stay in multiply state
        endcase
    end
end

// Output logic (combinational logic)
// This determines what control signals to send based on current state
always @(*) begin
    // Default: all outputs LOW
    load = 1'b0;
    dec = 1'b0;
    clear_AR = 1'b0;
    update_AR = 1'b0;
    update_OR = 1'b0;
    
    case (current_state)
        LOAD_STATE: begin
            // In load state: load the counter with multiplier value
            load = 1'b1;                // Load counter
        end
        
        MULTIPLY_STATE: begin
            if (zero_tick) begin
                // Counter reached 0: multiplication done
                update_OR = 1'b1;       // Save result to output register
                clear_AR = 1'b1;        // Clear adder register for next operation
                load = 1'b1;            // Prepare to load counter again
            end else begin
                // Counter not 0: keep multiplying
                update_AR = 1'b1;       // Update adder register with new sum
                dec = 1'b1;             // Decrement counter
            end
        end
    endcase
end

endmodule

// ============================================
// MODULE 5: MULTIPLIER (TOP MODULE)
// This connects all the modules together
// Multiplies In_A × In_B using repeated addition
// Example: 3 × 4 = 3+3+3+3 = 12
// ============================================
module multiplier (
    input clk,              // Clock signal
    input reset,            // Reset signal
    input [3:0] In_A,       // First number (multiplicand)
    input [3:0] In_B,       // Second number (multiplier)
    output [7:0] OR_Out     // Result of multiplication (8 bits)
);

// Internal wires to connect modules
wire [7:0] adder_result;    // Result from adder
wire [7:0] AR_out;          // Output from adder register
wire load;                  // Control signal: load counter
wire dec;                   // Control signal: decrement counter
wire zero_tick;             // Status signal: counter is zero
wire clear_AR;              // Control signal: clear adder register
wire update_AR;             // Control signal: update adder register
wire update_OR;             // Control signal: update output register

// COMPONENT 1: Down Counter
// Counts how many times we need to add (initialized with In_B)
down_counter counter (
    .clk(clk),
    .reset(reset),
    .load(load),
    .d(In_B),               // Load with multiplier value
    .dec(dec),
    .zero_tick(zero_tick),
    .q()                    // We don't need counter output
);

// COMPONENT 2: Adder
// Adds In_A to the current sum stored in AR_out
assign adder_result = AR_out + {4'b0000, In_A};  // Extend In_A to 8 bits and add

// COMPONENT 3: Adder Register
// Stores the running sum during multiplication
adder_reg adder_register (
    .clk(clk),
    .reset(reset),
    .en(update_AR),
    .clear(clear_AR),
    .d(adder_result),       // Input: new sum from adder
    .q(AR_out)              // Output: current sum
);

// COMPONENT 4: Output Register
// Stores the final multiplication result
out_reg output_register (
    .clk(clk),
    .reset(reset),
    .en(update_OR),
    .d(AR_out),             // Input: final sum from adder register
    .q(OR_Out)              // Output: final result
);

// COMPONENT 5: FSM Control Unit
// Controls the entire multiplication process
fsm control_unit (
    .clk(clk),
    .reset(reset),
    .zero_tick(zero_tick),
    .load(load),
    .dec(dec),
    .clear_AR(clear_AR),
    .update_AR(update_AR),
    .update_OR(update_OR)
);

endmodule

// ============================================
// HOW IT WORKS (Example: 3 × 4 = 12)
// ============================================
// 1. Counter loads 4 (In_B)
// 2. Adder register starts at 0
// 3. FSM enters multiply state:
//    - Add 3 to register: 0 + 3 = 3
//    - Counter: 4 → 3
//    - Add 3 again: 3 + 3 = 6
//    - Counter: 3 → 2
//    - Add 3 again: 6 + 3 = 9
//    - Counter: 2 → 1
//    - Add 3 again: 9 + 3 = 12
//    - Counter: 1 → 0
// 4. Counter reaches 0, result (12) saved to output
// ============================================
```
---
## 📜 FSMD Multiplier Testbench 
```verilog
`timescale 1ns/1ps
module multiplier_tb;
reg clk;                
reg reset;              
reg [3:0] In_A;         // First input (multiplicand)
reg [3:0] In_B;         // Second input (multiplier)
wire [7:0] OR_Out;      // Output result (from multiplier)

multiplier DUT (
    .clk(clk),
    .reset(reset),
    .In_A(In_A),
    .In_B(In_B),
    .OR_Out(OR_Out)
);

initial begin
    clk = 0;
    forever #5 clk = ~clk; 
end

initial begin
    $display("========================================");
    $display("  MULTIPLIER TESTBENCH");
    $display("========================================");
    $display("Time\t In_A\t In_B\t Result\t Expected");
    $display("----------------------------------------");
    
    // Initialize all inputs
    reset = 1;          // Start with reset active
    In_A = 4'd0;
    In_B = 4'd0;
    
    // Wait for 20ns then release reset
    #20;
    reset = 0;
    #10;
    
    // ============================================
    // TEST CASE 1: 3 × 4 = 12
    // ============================================
    In_A = 4'd3;
    In_B = 4'd4;
    #100;               // Wait for multiplication to complete
    $display("%0t\t %d\t %d\t %d\t %d", $time, In_A, In_B, OR_Out, 12);
    
    // Small delay between tests
    #20;
    
    // ============================================
    // TEST CASE 2: 5 × 6 = 30
    // ============================================
    In_A = 4'd5;
    In_B = 4'd6;
    #120;               // Wait for multiplication to complete
    $display("%0t\t %d\t %d\t %d\t %d", $time, In_A, In_B, OR_Out, 30);
    
    #20;
    
    // ============================================
    // TEST CASE 3: 7 × 8 = 56
    // ============================================
    In_A = 4'd7;
    In_B = 4'd8;
    #140;               // Wait for multiplication to complete
    $display("%0t\t %d\t %d\t %d\t %d", $time, In_A, In_B, OR_Out, 56);
    
    #20;
    
    // ============================================
    // TEST CASE 4: 0 × 5 = 0 (edge case)
    // ============================================
    In_A = 4'd0;
    In_B = 4'd5;
    #100;               // Wait for multiplication to complete
    $display("%0t\t %d\t %d\t %d\t %d", $time, In_A, In_B, OR_Out, 0);
    
    #20;
    
    // ============================================
    // TEST CASE 5: 9 × 0 = 0 (edge case)
    // ============================================
    In_A = 4'd9;
    In_B = 4'd0;
    #100;               // Wait for multiplication to complete
    $display("%0t\t %d\t %d\t %d\t %d", $time, In_A, In_B, OR_Out, 0);
    
    #20;
    
    // ============================================
    // TEST CASE 6: 15 × 15 = 225 (maximum values)
    // ============================================
    In_A = 4'd15;
    In_B = 4'd15;
    #200;               // Wait longer for more additions
    $display("%0t\t %d\t %d\t %d\t %d", $time, In_A, In_B, OR_Out, 225);
    
    #20;
    
    // ============================================
    // TEST CASE 7: 1 × 12 = 12
    // ============================================
    In_A = 4'd1;
    In_B = 4'd12;
    #140;
    $display("%0t\t %d\t %d\t %d\t %d", $time, In_A, In_B, OR_Out, 12);
    
    #20;
    
    // ============================================
    // TEST CASE 8: Test reset functionality
    // ============================================
    In_A = 4'd6;
    In_B = 4'd7;
    #50;                // Start multiplication
    reset = 1;          // Apply reset in middle of operation
    #10;
    reset = 0;
    #10;
    // After reset, output should be 0
    $display("%0t\t Reset Test - Output after reset: %d (Expected: 0)", $time, OR_Out);
    
    #50;
    
    // ============================================
    // End of simulation
    // ============================================
    $display("----------------------------------------");
    $display("All tests completed!");
    $display("========================================");
    $finish;            // End simulation
end

initial begin
    $dumpfile("multiplier_tb.vcd");    // VCD filename
    $dumpvars(0, multiplier_tb);       // Dump all signals in testbench
end

endmodule
```
