
# Block Statements 
---
## 📜 Initial Block 
---
```verilog

module stimulus;

reg x,y, a,b, m;

initial
	m = 1'b0; //single statement; does not need to be grouped

initial
begin
	#5 a = 1'b1; //multiple statements; need to be grouped
	#25 b = 1'b0;
end

initial
begin
	#10 x = 1'b0;
	#25 y = 1'b1;
end

initial
	#50 $finish;

endmodule
```
---
## 📜 Disabling named block  
---
```verilog 
module find_true_bit;
//Illustration: Find the first bit with a value 1 in flag (vector variable)
reg [15:0] flag;
integer i; //integer to keep count
initial
begin
  flag = 16'b 0010_0000_0000_0000;
  i = 0;
  begin: block1 //The main block inside while is named block1
  	while(i < 16) 
		begin
     if (flag[i])
     begin
        $display("Encountered a TRUE bit at element number %d", i);
        disable block1; //disable block1 because you found true bit.
     end
     i = i + 1;
		end
  end
end
endmodule
```
---
## 📜 Fork-Join  
---
```verilog 
module tb_fork_join;
  initial begin
    $display("\n--- Basic fork..join demo ---");
    $display("time=%0t : before fork", $time);
    fork
      begin
        #5;
        $display("time=%0t : thread A finished (delay 5)", $time);
      end
      begin
        #2;
        $display("time=%0t : thread B finished (delay 2)", $time);
      end
      begin
        #8;
        $display("time=%0t : thread C finished (delay 8)", $time);
      end
    join
// Execution reaches here only after all forked threads complete
    $display("time=%0t : after join (all threads done)\n", $time);
    $finish;
  end
endmodule
//----Explanation------------------------------------------------------
// The three blocks inside fork run concurrently.
//The join waits for all threads to finish; control continues only after the longest (thread C, #8) completes.
