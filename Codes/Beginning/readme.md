# Basic Codes  
---
## 📜 Hello World  
```verilog
// File: hello_world.v
module hello_world;
  initial begin
    $display("Hello World\n");
  end
endmodule
#
--- 
## 📜 Integer Declaration and Display
```verilog
Copy code
// File: integer_display.v
module integer_display;
  int a;   // integer variable (SystemVerilog)

  initial begin
    a = 10;  
    $display("Value of a = %0d", a);
  end
endmodule
---
