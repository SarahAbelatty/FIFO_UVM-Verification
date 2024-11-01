package FIFO_mysequencer_pkg;
	import FIFO_sequence_item_pkg::*;
	import uvm_pkg::*;
	import FIFO_shared_pkg::*;
	`include "uvm_macros.svh";
	
	class FIFO_mysequencer extends  uvm_sequencer #(FIFO_seq_item);
		`uvm_component_utils(FIFO_mysequencer)

		function new(string name = "FIFO_mysequencer", uvm_component parent = null);
			super.new(name, parent);
		endfunction
	endclass : FIFO_mysequencer
	
endpackage : FIFO_mysequencer_pkg


