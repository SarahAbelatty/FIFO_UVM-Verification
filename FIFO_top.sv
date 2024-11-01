import FIFO_test_pkg::*;
import uvm_pkg::*;
`include "uvm_macros.svh";

module FIFO_top ();
	bit clk;

	// Clock generation 
	initial begin
		clk = 0;
		forever 
			#2 clk = ~clk;
	end

	// Instentiate the interface
	FIFO_if FIFO_IF(clk);
	
	// Instentiate the DUT module
	FIFO DUT(FIFO_IF);

	// bind the SVA
	bind FIFO FIFO_SVA SVA (FIFO_IF);

	initial begin
		uvm_config_db#(virtual FIFO_if)::set(null, "uvm_test_top", "FIFO_CFG", FIFO_IF);
		run_test("FIFO_test");
	end

endmodule 

