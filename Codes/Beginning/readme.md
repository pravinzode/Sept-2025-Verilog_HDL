# Hello World in Verilog/SystemVerilog  

This example illustrates a **basic Verilog/SystemVerilog program**.  
It demonstrates how to declare variables, assign values, and display output using `$display`.  

---

## 📂 File  
- `hello_world.v`  

---

## 📜 Code  
```verilog
// File: hello_world.v
module hello_world;
  int a;   // integer variable (SystemVerilog)

  initial begin
    a = 10;  
    $display("My first program\t Hello World\nCDAC");
    $display("a = %0d", a);
  end
endmodule
 
