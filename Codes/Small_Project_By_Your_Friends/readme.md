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

