# Projects

---
## 📜 GCD Calculator ( Kaushal and Mayuresh) 
```verilog
`timescale 1ns / 1ps
// gcd_calculator_fsmd.v
module gcd_calculator_fsmd #(parameter WIDTH = 8) (
    input wire clk, rst, start,         // Start computation (active high)
    input wire [WIDTH-1:0] A_in, [WIDTH-1:0] B_in,
    output reg [WIDTH-1:0] gcd_out, done);            // Indicates GCD is ready

    // Internal Registers for A and B
    reg [WIDTH-1:0] A_reg;
    reg [WIDTH-1:0] B_reg;

    // FSM States
    parameter IDLE  = 2'b00;
    parameter LOAD  = 2'b01;
    parameter CALC  = 2'b10;
    parameter DONE  = 2'b11;

    reg [1:0] current_state, next_state;

    // ------------------------------------------------------------------
    // State Register (Sequential Logic)
    // ------------------------------------------------------------------
    always @(posedge clk or posedge rst) begin
        if (rst)
            current_state <= IDLE;
        else
            current_state <= next_state;
    end

    // ------------------------------------------------------------------
    // Next State Logic (Combinational Logic)
    // ------------------------------------------------------------------
    always @(*) begin
        next_state = current_state; // Default is self-loop

        case (current_state)
            IDLE: begin
                if (start)
                    next_state = LOAD;
            end
            LOAD: begin
                // Load takes one cycle, then go to CALC
                next_state = CALC;
            end
            CALC: begin
                if (A_reg == B_reg)
                    next_state = DONE;
                else
                    next_state = CALC; // Stay in CALC
            end
            DONE: begin
                if (~start)
                    next_state = IDLE; // Wait for start to de-assert
                else
                    next_state = DONE; // Stay done until reset or start=0
            end
            default: next_state = IDLE;
        endcase
    end

    // ------------------------------------------------------------------
    // Datapath & Output Logic (Sequential/Combinational)
    // ------------------------------------------------------------------

    // Data Registers Update (Datapath - Sequential Logic)
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A_reg <= 0;
            B_reg <= 0;
        end else begin
            case (current_state)
                LOAD: begin
                    A_reg <= A_in;
                    B_reg <= B_in;
                end
                CALC: begin
                    if (A_reg > B_reg) begin
                        A_reg <= A_reg - B_reg; // A = A - B
                        B_reg <= B_reg;
                    end
                    else if (B_reg > A_reg) begin
                        A_reg <= A_reg;
                        B_reg <= B_reg - A_reg; // B = B - A
                    end
                    // If A_reg == B_reg, no action (stay same)
                end
                DONE: begin
                    // Hold the result
                end
                default: begin
                    A_reg <= A_reg;
                    B_reg <= B_reg;
                end
            endcase
        end
    end

    // Output Logic
    always @(current_state or A_reg) begin
        // Default values
        done = 0;
        gcd_out = 0;

        case (current_state)
            DONE: begin
                done = 1;
                gcd_out = A_reg; // A_reg == B_reg in DONE state
            end
            default: begin
                done = 0;
                gcd_out = 0;
            end
        endcase
    end

endmodule

// tb_gcd_calculator_fsmd.v

module tb_gcd_calculator_fsmd;

    // Parameters
    localparam WIDTH = 8;
    localparam CLK_PERIOD = 10; // 10ns period = 100MHz

    // Signals
    reg clk;
    reg rst;
    reg start;
    reg [WIDTH-1:0] A_in;
    reg [WIDTH-1:0] B_in;
    wire [WIDTH-1:0] gcd_out;
    wire done;

    // Instantiate the DUT (Device Under Test)
    gcd_calculator_fsmd #(.WIDTH(WIDTH)) DUT (
        .clk(clk),
        .rst(rst),
        .start(start),
        .A_in(A_in),
        .B_in(B_in),
        .gcd_out(gcd_out),
        .done(done)
    );

    // Clock Generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Test Sequence
    initial begin
        // Initialize inputs
        rst = 1;
        start = 0;
        A_in = 0;
        B_in = 0;
        
        // Reset Phase
        # (2 * CLK_PERIOD);
        rst = 0;
        # (CLK_PERIOD);

//        // Test 1: GCD(84, 60) -> Expected: 12
//        $display("--- Starting Test 1: GCD(84, 60) ---");
//        A_in = 84;
//        B_in = 60;
//        start = 1;
//        # (CLK_PERIOD); // Load inputs on the next clock edge
//        start = 0;
        
//        // Wait for 'done' signal
//        wait (done);
//        $display("GCD(84, 60) is %d (Expected: 12) at time %t", gcd_out, $time);

//        // Reset system to be ready for next test
//        # (2 * CLK_PERIOD);
//        start = 0;
//        # (2 * CLK_PERIOD);
        
        // Test 2: GCD(25, 15) -> Expected: 5
        $display("--- Starting Test 2: GCD(134,94) ---");
        A_in = 98;
        B_in = 49;
        start = 1;
        # (CLK_PERIOD); // Load inputs
        start = 0;
        
        // Wait for 'done' signal
        wait (done);
        $display("GCD(97,67) is %d (Expected: 1 as both are prime numbers) at time %t", gcd_out, $time);

        // End Simulation
        # (2 * CLK_PERIOD);
        $finish;
    end

    // Monitor internal signals for debugging (optional)
    initial begin
        $monitor("Time=%t, State=%d, A_reg=%d, B_reg=%d, gcd_out=%d, done=%b", $time, DUT.current_state, DUT.A_reg, DUT.B_reg, gcd_out, done);
    end

endmodule
```
---
## 📜 Selection Sort  ( Sumedh ) 
```verilog
`timescale 1ns / 1ps

module selection_sort_self( input [3:0] a_in,b_in,c_in,d_in , input clk,rst , output [3:0] a_out,b_out,c_out,d_out,output done );

localparam [2:0]
    s0 = 3'd0,
    s1 = 3'd1,
    s2 = 3'd2,
    s3 = 3'd3,
    s4 = 3'd4,
    s5 = 3'd5;
    
    reg [2:0] current;
    reg [3:0] w,x,y,z;
    reg [3:0] temp;
    reg compa;
    reg done_x;
    
    always@(posedge clk)
        if(rst)
            begin
                current = s0;
                w = a_in;
                x = b_in;
                y = c_in;
                z = d_in;
                done_x =0;
                compa = 0;
                $display("In reset -> Time = %0t | current = %d | done_x = %d | compa = %d | w = %d | x = %d | y = %d | z = %d |",$time,current,done_x,compa,w,x,y,z);                   
         
            end  
        else
            case(current)
                s0 : //done
                    begin
                        current = s1;
                        done_x = 0;
                        compa = (w>x) ? 1'b1 : 1'b0;
                        if(compa)
                            begin
                                // SWAP //
                                temp = w;
                                w = x;
                                x = temp;
                                
                                y = y;
                                z = z;
                            end      
                        else
                            begin
                                w = w;
                                x = x;
                                y = y;
                                z = z;
                            end  
                        $display("In s0 -> Time = %0t | current = %d | done_x = %d | compa = %d | w = %d | x = %d | y = %d | z = %d |",$time,current,done_x,compa,w,x,y,z);                   
                    end
                s1 : //notdone
                    begin
                        current = s2; done_x <= 0;
                        compa = (w>y) ? 1'b1 : 1'b0;
                        if(compa)
                            begin
                                // SWAP //
                                temp = w;
                                w = y;
                                y = temp;
                                
                                x = x;
                                z = z;
                            end   
                        else
                            begin
                                w = w;
                                x = x;
                                y = y;
                                z = z;
                            end
                        $display("In s1 -> current = %d | done_x = %d | compa = %d | w = %d | x = %d | y = %d | z = %d |",current,done_x,compa,w,x,y,z);                           
                    end
                s2 : //done
                    begin
                        current = s3; done_x <= 0;
                        compa = (w>z) ? 1'b1 : 1'b0;
                        if(compa)
                            begin
                                temp = w;
                                w = z;
                                z = temp;
                                
//                                x <= x;
//                                y <= y;                
                            end  
//                        else
//                            begin
//                                w <= w;
//                                x <= x;
//                                y <= y;
//                                z <= z;
//                            end                         
                        $display("In s2 -> current = %d | done_x = %d | compa = %d | w = %d | x = %d | y = %d | z = %d |",current,done_x,compa,w,x,y,z);
                    end
                s3 : //done
                    begin
                        current = s4; done_x <= 0;
                        compa = (x>y) ? 1'b1 : 1'b0;
                        if(compa)
                            begin
                                // SWAP //
                                temp = x;
                                x = y;
                                y = temp;
                                
//                                w <= w;
//                                z <= z;
                            end         
//                        else
//                            begin
//                                w <= w;
//                                x <= x;
//                                y <= y;
//                                z <= z;
//                            end                  
                        $display("In s3 -> current = %d | done_x = %d | compa = %d | w = %d | x = %d | y = %d | z = %d |",current,done_x,compa,w,x,y,z);
                    end
                s4 : //done
                    begin
                        current = s5; done_x <= 0;
                        compa = (x>z) ? 1'b1 : 1'b0;
                        if(compa)
                            begin
                                temp = x;
                                x = z;
                                z = temp;
//                                w <= w;
//                                y <= y;
                            end   
//                         else
//                            begin
//                                w <= w;
//                                x <= x;
//                                y <= y;
//                                z <= z;
//                            end 
                         $display("In s4 -> current = %d | done_x = %d | compa = %d | w = %d | x = %d | y = %d | z = %d |",current,done_x,compa,w,x,y,z);              
                    end
                s5 : //notdone
                    begin
                        current = s0; 
                        done_x = 1;
                        compa = (y>z) ? 1'b1 : 1'b0;
                        if(compa)
                            begin
                                // SWAP // 
                                temp = y;
                                y = z;
                                z = temp;
                                
//                                w <= w;
//                                x <= x;
                            end   
//                         else
//                            begin
//                                w <= w;
//                                x <= x;
//                                y <= y;
//                                z <= z;
//                            end 
                          $display("In s5 -> current = %d | done_x = %d | compa = %d | w = %d | x = %d | y = %d | z = %d |",current,done_x,compa,w,x,y,z);                        
                    end
            endcase
    assign a_out = w;
    assign b_out = x;
    assign c_out = y;
    assign d_out = z;
    assign done = done_x;

endmodule

// TB

module selection_sort_self_tb;

reg [3:0] a_in,b_in,c_in,d_in ; 
reg clk,rst; 
wire [3:0] a_out,b_out,c_out,d_out;
wire done;

selection_sort_self DUT(a_in,b_in,c_in,d_in,clk,rst,a_out,b_out,c_out,d_out,done);

initial begin
    a_in=15;
    b_in=13;
    c_in=8;
    d_in=9;
    clk=1;
    rst=1;
    #10;
    rst = 0;
    //$monitor("Time = %0t | a_in = %d | b_in = %d | c_in = %d | d_in = %d ||||| w = %d | x = %d | y = %d | z = %d | done = %d |",$time,a_in,b_in,c_in,d_in,DUT.w,DUT.x,DUT.y,DUT.z,done);
    #60 $finish;
    $display("============================================================");
    $display(" | a_out = %d | b_out = %d | c_out = %d | d_out = %d | ",a_out,b_out,c_out,d_out);
    $display("============================================================");
end

always #5 clk = ~clk;
//lways #15 rst = ~rst;

endmodule
```

---
## 📜 Bubble Sort ( Nisarg and Shravani) 
```verilog
module bubble_sort_fsmd #(
    parameter N = 4,            // Array size
    parameter DATA_WIDTH = 8,   // Data width
    parameter STATE_WIDTH = 4,   // State encoding width
    parameter [STATE_WIDTH-1:0] IDLE = 0,
    parameter [STATE_WIDTH-1:0] RUN  = 1,
    parameter [STATE_WIDTH-1:0] DONE = 2
    ) (
    input wire clk,             // Clock input
    input wire rst,             // Active-high reset
    input wire start,           // Start sorting
    input wire [DATA_WIDTH-1:0] data_in,  // Input data for loading
    input wire load,            // Load new data signal  
    input wire [1:0] load_addr, // Address for loading data
    output reg done,            // Sorting complete
    output wire [DATA_WIDTH-1:0] array_0, // Array elements as individual ports
    output wire [DATA_WIDTH-1:0] array_1,
    output wire [DATA_WIDTH-1:0] array_2, 
    output wire [DATA_WIDTH-1:0] array_3
);

    // State encoding

    
     reg [DATA_WIDTH-1:0] array [0:N-1];
     
    assign array_0 = array[0];
    assign array_1 = array[1];
    assign array_2 = array[2];
    assign array_3 = array[3];

    // Registers
    reg [STATE_WIDTH-1:0] state;
    reg [1:0] i, j; // Loop indices
    reg swapped;     // Optimization: detect early completion

    // Synthesizable array initialization and loading
    integer k;
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            // Initialize array to known values on reset
            for (k = 0; k < N; k = k + 1) begin
                array[k] <= {DATA_WIDTH{1'b0}}; // Or other default values
            end
            state <= IDLE;
            done <= 0;
            i <= 0;
            j <= 0;
            swapped <= 0;
        end else begin
            // Data loading functionality
            if (load) begin
                array[load_addr] <= data_in;
            end
            
            // Main state machine
            case (state)
                IDLE: begin
                    done <= 0;
                    swapped <= 0;
                    if (start) begin
                        i <= 0;
                        j <= 0;
                        state <= RUN;
                    end
                end
                
                RUN: begin
                    if (j < N-1-i) begin
                        // Compare and swap using only non-blocking assignments
                        if (array[j] > array[j+1]) begin
                            // Swap elements - all non-blocking for synthesis
                            array[j] <= array[j+1];
                            array[j+1] <= array[j];
                            swapped <= 1;
                        end
                        j <= j + 1;
                    end else begin
                        // End of inner loop
                        if (i < N-2 && swapped) begin
                            i <= i + 1;
                            j <= 0;
                            swapped <= 0; // Reset for next pass
                        end else begin
                            // Sorting complete (either finished or no swaps occurred)
                            done <= 1;
                            state <= DONE;
                        end
                    end
                end
                
                DONE: begin
                    done <= 1;
                    // Wait for reset or new start
                    if (start) begin
                        state <= IDLE;
                    end
                end
                
                default: state <= IDLE;
            endcase
        end
    end

endmodule
// Testbench 
module bubble_sort_fsmd_tb;

    // Parameters
    parameter CLK_PERIOD = 10;
    parameter N = 4;
    parameter DATA_WIDTH = 8;

    // Testbench Signals
    reg clk;
    reg rst;
    reg start;
    reg [DATA_WIDTH-1:0] data_in;
    reg load;
    reg [1:0] load_addr;
    wire done;
    wire [DATA_WIDTH-1:0] array_0, array_1, array_2, array_3;
    
    // Internal array for verification
    reg [DATA_WIDTH-1:0] expected_array_0, expected_array_1, expected_array_2, expected_array_3;

    // Instantiate DUT
    bubble_sort_fsmd dut (
        .clk(clk),
        .rst(rst),
        .start(start),
        .data_in(data_in),
        .load(load),
        .load_addr(load_addr),
        .done(done),
        .array_0(array_0),
        .array_1(array_1),
        .array_2(array_2),
        .array_3(array_3)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #(CLK_PERIOD/2) clk = ~clk;
    end

    // Main test sequence
    initial begin
        // Initialize
        rst = 1;
        start = 0;
        load = 0;
        data_in = 0;
        load_addr = 0;
        
        // Reset
        #(CLK_PERIOD * 2);
        rst = 0;
        #(CLK_PERIOD * 2);
        
        // Test Case 1: Basic sorting
        $display("=== Test Case 1: Basic Sorting ===");
        
        // Load array [64, 34, 25, 12]
        load_element(0, 8'd64);
        load_element(1, 8'd34);
        load_element(2, 8'd25);
        load_element(3, 8'd12);
        
        // Set expected result [12, 25, 34, 64]
        expected_array_0 = 8'd12;
        expected_array_1 = 8'd25;
        expected_array_2 = 8'd34;
        expected_array_3 = 8'd64;
        
        start_sort();
        verify_sorted_array();
        
        #(CLK_PERIOD * 5);
        
        // Test Case 2: Already sorted
        $display("=== Test Case 2: Already Sorted Array ===");
        
        load_element(0, 8'd10);
        load_element(1, 8'd20);
        load_element(2, 8'd30);
        load_element(3, 8'd40);
        
        expected_array_0 = 8'd10;
        expected_array_1 = 8'd20;
        expected_array_2 = 8'd30;
        expected_array_3 = 8'd40;
        
        start_sort();
        verify_sorted_array();
        
        // Test Case 3: Reverse sorted
        $display("=== Test Case 3: Reverse Sorted Array ===");
        
        load_element(0, 8'd40);
        load_element(1, 8'd30);
        load_element(2, 8'd20);
        load_element(3, 8'd10);
        
        expected_array_0 = 8'd10;
        expected_array_1 = 8'd20;
        expected_array_2 = 8'd30;
        expected_array_3 = 8'd40;
        
        start_sort();
        verify_sorted_array();
        
        $display("=== ALL TESTS PASSED ===");
        $finish;
    end

    // Task to load a single element
    task load_element;
        input [1:0] addr;
        input [DATA_WIDTH-1:0] data;
        begin
            @(posedge clk);
            load_addr = addr;
            data_in = data;
            load = 1;
            @(posedge clk);
            load = 0;
            #(CLK_PERIOD);
        end
    endtask

    // Task to start sorting process
    task start_sort;
        begin
            $display("Starting sort operation...");
            @(posedge clk);
            start = 1;
            @(posedge clk);
            start = 0;
            
            // Wait for completion
            wait_for_done();
            
            #(CLK_PERIOD * 2);
        end
    endtask

    // Wait for done signal with timeout
    task wait_for_done;
        integer timeout;
        begin
            timeout = 0;
            while (done === 1'b0 && timeout < 100) begin
                @(posedge clk);
                timeout = timeout + 1;
            end
            
            if (timeout >= 100) begin
                $display("ERROR: Sort operation timed out!");
                $finish;
            end else begin
                $display("Sort completed in %0d cycles", timeout);
            end
        end
    endtask

    // Task to verify sorted array
    task verify_sorted_array;
        begin
            @(posedge clk);
            
            $display("Expected: [%0d, %0d, %0d, %0d]", 
                     expected_array_0, expected_array_1, expected_array_2, expected_array_3);
            $display("Received: [%0d, %0d, %0d, %0d]", array_0, array_1, array_2, array_3);
            
            // Verify each element
            if (array_0 !== expected_array_0 || 
                array_1 !== expected_array_1 || 
                array_2 !== expected_array_2 || 
                array_3 !== expected_array_3) begin
                $display("ERROR: Array sorting failed!");
                $finish;
            end else begin
                $display("PASS: Array correctly sorted");
            end
            
            // Check if array is in ascending order
            if (array_0 > array_1 || array_1 > array_2 || array_2 > array_3) begin
                $display("ERROR: Array is not in ascending order!");
                $finish;
            end
            
            $display("");
        end
    endtask

    // Monitor to track simulation progress
    always @(posedge clk) begin
        if (start === 1'b1) begin
            $display("Time %0t: Sort started", $time);
        end
        if (done === 1'b1) begin
            $display("Time %0t: Sort completed", $time);
        end
    end

    // Waveform dumping
    initial begin
        $dumpfile("bubble_sort_fsmd_tb.vcd");
        $dumpvars(0, bubble_sort_fsmd_tb);
    end
endmodule
```
---
## 📜 Parametrized Barrel Shifter ( Vamshi) 
```verilog
`timescale 1ns / 1ps

module mux2x1(y, a, b, s);
    output y;
    input a, b, s;
    assign y = s ? b: a;
endmodule
//Barrel shift left
module BarrelShifter#(parameter width = 16,
select = $clog2(width))(
output [width-1:0]y,
input [select-1:0]s,
input [width -1:0]w
    );
    wire [width - 1:0] L[select - 1 : 0];
   genvar b, i, j;
   generate 
      for (b = 0; b <= width - 1; b = b + 1) begin : G1
         mux2x1 s2(L[0][b], w[b], w[(b+(2**(select-1)))%width], s[select-1]);
      end
   
     for( j = 0; j < select-1; j = j+1)begin : Upper
         for (i = 0; i < width; i = i + 1) begin : Lower   
            mux2x1 s1(L[j+1][i], L[j][i], L[j][(i+(2**(select -j-2)))%width], s[select -j-2]);
         end
    end
    assign y = L[select-1];
   endgenerate
         
endmodule
```

