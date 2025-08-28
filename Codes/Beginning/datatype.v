module testbench;
  integer  	int_a; 				// Integer variable
  real 		real_b; 			// Real variable
  time 		time_c; 			// Time variable

  initial begin
    int_a 	= 32'hcafe_1234; 	// Assign an integer value
    real_b 	= 0.1234567; 		// Assign a floating point value

    #20; 						// Advance simulation time by 20 units
    time_c 	= $time; 			// Assign current simulation time

    // Now print all variables using $display system task
    $display ("int_a 	= 0x%0h", int_a);
    $display ("real_b 	= %0.5f", real_b);
    $display ("time_c 	= %0t", time_c);
  end
endmodule