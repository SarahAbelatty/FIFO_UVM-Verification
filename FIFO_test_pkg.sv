package FIFO_test_pkg;
	import uvm_pkg::*;
	import FIFO_shared_pkg::*;
	import FIFO_env_pkg::*;
	import FIFO_config_pkg::*;
	import FIFO_read_seq_pkg::*;
	import FIFO_write_read_seq_pkg::*;
	import FIFO_write_seq_pkg::*;
	import FIFO_reset_seq_pkg::*;
	import FIFO_write_read_empty_seq_pkg::*;
	`include "uvm_macros.svh";

	class FIFO_test extends  uvm_test;
		`uvm_component_utils(FIFO_test)

		FIFO_env FIFO_env_comp; // Handle of the FIFO environment
		virtual FIFO_if FIFO_test_vif; // Declare virtual interface
		FIFO_config FIFO_config_obj_test;
		FIFO_read_seq read_seq;
		FIFO_write_read_seq write_read_seq;
		FIFO_write_seq write_seq;
		FIFO_reset_seq reset_seq;
		FIFO_write_read_empty_seq wr_rd_empty;

		function new(string name = "FIFO_test", uvm_component parent = null);
			super.new(name, parent);
		endfunction 

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			FIFO_env_comp = FIFO_env::type_id::create("FIFO_env_comp", this);
			FIFO_config_obj_test = FIFO_config::type_id::create("FIFO_config_obj_test");
			read_seq = FIFO_read_seq::type_id::create("read_seq");
			reset_seq = FIFO_reset_seq::type_id::create("reset_seq");
			write_seq = FIFO_write_seq::type_id::create("write_seq");
			write_read_seq = FIFO_write_read_seq::type_id::create("write_read_seq");
			wr_rd_empty = FIFO_write_read_empty_seq::type_id::create("wr_rd_empty");

			// Retrieve virtual interface from config DB
			uvm_config_db#(virtual FIFO_if)::get(this, "", "FIFO_CFG", FIFO_config_obj_test.FIFO_config_vif);
			// Set the virtual interface to all components
			uvm_config_db#(FIFO_config)::set(this, "*", "FIFO_CFG", FIFO_config_obj_test);
		endfunction 

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			phase.raise_objection(this);
			// reset sequence
			`uvm_info("run_phase", "Reset asserted", UVM_LOW)
			reset_seq.start(FIFO_env_comp.agt.sqr);
			`uvm_info("run_phase", "Reset deasserted", UVM_LOW)

			// write sequence 
			`uvm_info("run_phase", "write asserted", UVM_LOW)
			write_seq.start(FIFO_env_comp.agt.sqr);
			`uvm_info("run_phase", "write deasserted", UVM_LOW)

			// read sequence
			`uvm_info("run_phase", "read asserted", UVM_LOW)
			read_seq.start(FIFO_env_comp.agt.sqr);
			`uvm_info("run_phase", "read Deasserted", UVM_LOW)

			// write read empty sequance
			`uvm_info("run_phase", "write read empty asserted", UVM_LOW)
			wr_rd_empty.start(FIFO_env_comp.agt.sqr);
			`uvm_info("run_phase", "write read empty asserted", UVM_LOW)

			// write read sequence 
			`uvm_info("run_phase", "write read asserted", UVM_LOW)
			write_read_seq.start(FIFO_env_comp.agt.sqr);
			`uvm_info("run_phase", "write read deasserted", UVM_LOW)

			// reset sequence
			`uvm_info("run_phase", "Reset asserted", UVM_LOW)
			reset_seq.start(FIFO_env_comp.agt.sqr);
			`uvm_info("run_phase", "Reset deasserted", UVM_LOW)
			phase.drop_objection(this);
			
			test_finished = 1;
		endtask : run_phase
		
	endclass : FIFO_test
	
endpackage 



