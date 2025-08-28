# Basic Codes  

---

## 📂 File  
- `hello_world.v`  

---

## 📜 Integer Declaration and print value   
```verilog
// File: hello_world.v
module hello_world;
  int a;   // integer variable (SystemVerilog)
  initial begin
  a = 10;  
  $display("My first program display program \n");
  $display("a = %0d", a);
  end
endmodule
 
