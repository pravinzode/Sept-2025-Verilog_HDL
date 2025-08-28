# Basic Codes  

This repository contains simple Verilog examples for beginners.  
Each section has its own code snippet for quick copy-paste usage.  

---

## 📜 Hello World  
```verilog
// File: hello_world.v
module hello_world;
  initial begin
    $display("Hello World\n");
  end
endmodule
📜 Integer Declaration and Display
verilog
Copy code
// File: integer_display.v
module integer_display;
  int a;   // integer variable (SystemVerilog)

  initial begin
    a = 10;  
    $display("Value of a = %0d", a);
  end
endmodule
📜 Multiple Variables Example
verilog
Copy code
// File: multi_var.v
module multi_var;
  int x, y, sum;

  initial begin
    x = 5;
    y = 15;
    sum = x + y;
    $display("x = %0d, y = %0d, sum = %0d", x, y, sum);
  end
endmodule
📜 String Display Example
verilog
Copy code
// File: string_example.v
module string_example;
  string name;

  initial begin
    name = "CDAC Pune";
    $display("Hello from %s", name);
  end
endmodule
📜 Custom Message Example
verilog
Copy code
// File: custom_message.v
module custom_message;
  int roll_no;
  string student;

  initial begin
    roll_no = 101;
    student = "Pravin Zode";
    $display("Student: %s | Roll No: %0d", student, roll_no);
  end
endmodule# Basic Codes  

This repository contains simple Verilog examples for beginners.  
Each section has its own code snippet for quick copy-paste usage.  

---

## 📜 Hello World  
```verilog
// File: hello_world.v
module hello_world;
  initial begin
    $display("Hello World\n");
  end
endmodule
📜 Integer Declaration and Display
verilog
Copy code
// File: integer_display.v
module integer_display;
  int a;   // integer variable (SystemVerilog)

  initial begin
    a = 10;  
    $display("Value of a = %0d", a);
  end
endmodule
📜 Multiple Variables Example
verilog
Copy code
// File: multi_var.v
module multi_var;
  int x, y, sum;

  initial begin
    x = 5;
    y = 15;
    sum = x + y;
    $display("x = %0d, y = %0d, sum = %0d", x, y, sum);
  end
endmodule
📜 String Display Example
verilog
Copy code
// File: string_example.v
module string_example;
  string name;

  initial begin
    name = "CDAC Pune";
    $display("Hello from %s", name);
  end
endmodule
📜 Custom Message Example
verilog
Copy code
// File: custom_message.v
module custom_message;
  int roll_no;
  string student;

  initial begin
    roll_no = 101;
    student = "Pravin Zode";
    $display("Student: %s | Roll No: %0d", student, roll_no);
  end
endmodule# Basic Codes  

This repository contains simple Verilog examples for beginners.  
Each section has its own code snippet for quick copy-paste usage.  

---

## 📜 Hello World  
```verilog
// File: hello_world.v
module hello_world;
  initial begin
    $display("Hello World\n");
  end
endmodule
📜 Integer Declaration and Display
verilog
Copy code
// File: integer_display.v
module integer_display;
  int a;   // integer variable (SystemVerilog)

  initial begin
    a = 10;  
    $display("Value of a = %0d", a);
  end
endmodule
📜 Multiple Variables Example
verilog
Copy code
// File: multi_var.v
module multi_var;
  int x, y, sum;

  initial begin
    x = 5;
    y = 15;
    sum = x + y;
    $display("x = %0d, y = %0d, sum = %0d", x, y, sum);
  end
endmodule
📜 String Display Example
verilog
Copy code
// File: string_example.v
module string_example;
  string name;

  initial begin
    name = "CDAC Pune";
    $display("Hello from %s", name);
  end
endmodule
📜 Custom Message Example
verilog
Copy code
// File: custom_message.v
module custom_message;
  int roll_no;
  string student;

  initial begin
    roll_no = 101;
    student = "Pravin Zode";
    $display("Student: %s | Roll No: %0d", student, roll_no);
  end
endmodule
