package FIFO_coverage_pkg;
	import FIFO_shared_pkg::*;
	import uvm_pkg::*;
	`include "uvm_macros.svh";
	import FIFO_sequence_item_pkg::*;

	class FIFO_coverage extends uvm_component;
		`uvm_component_utils(FIFO_coverage)
		uvm_analysis_export #(FIFO_seq_item) cov_export;
		uvm_tlm_analysis_fifo #(FIFO_seq_item) cov_fifo;
		FIFO_seq_item seq_item_cov;

		// Covergroup
		covergroup fifo_cvr;
			// Cover points
			full_cp: coverpoint seq_item_cov.full;
			empty_cp: coverpoint seq_item_cov.empty;
			wr_en_cp: coverpoint seq_item_cov.wr_en;
			rd_en_cp: coverpoint seq_item_cov.rd_en;
			wr_ack_cp: coverpoint seq_item_cov.wr_ack;
			overflow_cp: coverpoint seq_item_cov.overflow;
			underflow_cp: coverpoint seq_item_cov.underflow;
			almostfull_cp: coverpoint seq_item_cov.almostfull;
			almostempty_cp: coverpoint seq_item_cov.almostempty;

			// Crosses
			cross wr_en_cp, rd_en_cp, full_cp{
				ignore_bins Write1_Read1_Full = binsof(wr_en_cp) intersect{1} && binsof(rd_en_cp) intersect{1} 
				&& binsof(full_cp) intersect{1};

				ignore_bins Write0_Read1_Full = binsof(wr_en_cp) intersect{0} && binsof(rd_en_cp) intersect{1} 
				&& binsof(full_cp) intersect{1};
			}
			cross wr_en_cp, rd_en_cp, overflow_cp {
				ignore_bins Write0_Read1_Overflow = binsof(wr_en_cp) intersect{0} && binsof(rd_en_cp) intersect{1} 
				&& binsof(overflow_cp) intersect{1};

				ignore_bins Write0_Read0_Overflow = binsof(wr_en_cp) intersect{0} && binsof(rd_en_cp) intersect{0} 
				&& binsof(overflow_cp) intersect{1};
			}
			cross wr_en_cp, rd_en_cp, underflow_cp {
				ignore_bins Write1_Read0_Underflow = binsof(wr_en_cp) intersect{1} && binsof(rd_en_cp) intersect{0} 
				&& binsof(underflow_cp) intersect{1};

				ignore_bins Write0_Read0_Underflow = binsof(wr_en_cp) intersect{0} && binsof(rd_en_cp) intersect{0} 
				&& binsof(underflow_cp) intersect{1};

				ignore_bins Write1_Read1_Underflow = binsof(wr_en_cp) intersect{1} && binsof(rd_en_cp) intersect{1} 
				&& binsof(underflow_cp) intersect{1};
			}
			cross wr_en_cp, rd_en_cp, wr_ack_cp {
				ignore_bins Write0_Read1_wrack = binsof(wr_en_cp) intersect{0} && binsof(rd_en_cp) intersect{1} 
				&& binsof(wr_ack_cp) intersect{1};

				ignore_bins Write0_Read0_wrack = binsof(wr_en_cp) intersect{0} && binsof(rd_en_cp) intersect{0} 
				&& binsof(wr_ack_cp) intersect{1};
			}
			cross wr_en_cp, rd_en_cp, empty_cp {
				ignore_bins Write1_Read1_Empty = binsof(wr_en_cp) intersect{1} && binsof(rd_en_cp) intersect{1} 
				&& binsof(empty_cp) intersect{1};

				ignore_bins Write1_Read0_Empty = binsof(wr_en_cp) intersect{1} && binsof(rd_en_cp) intersect{0} 
				&& binsof(empty_cp) intersect{1};
			}
			cross wr_en_cp, rd_en_cp, almostempty_cp {
				ignore_bins Write1_Read1_Almostempty = binsof(wr_en_cp) intersect{1} && binsof(rd_en_cp) intersect{1} 
				&& binsof(almostempty_cp) intersect{1};

				ignore_bins Write1_Read0_Almostempt = binsof(wr_en_cp) intersect{0} && binsof(rd_en_cp) intersect{0} 
				&& binsof(almostempty_cp) intersect{1};
			}
			cross wr_en_cp, rd_en_cp, almostfull_cp;
		endgroup 

		function new(string name = "FIFO_coverage", uvm_component parent = null);
			super.new(name, parent);
			fifo_cvr = new();
		endfunction 

		function void build_phase(uvm_phase phase);
			super.build_phase(phase);
			cov_export = new("cov_export", this);
			cov_fifo = new("cov_fifo", this);
		endfunction 

		function void connect_phase(uvm_phase phase);
			super.connect_phase(phase);
			cov_export.connect(cov_fifo.analysis_export);
		endfunction

		task run_phase(uvm_phase phase);
			super.run_phase(phase);
			forever begin
				cov_fifo.get(seq_item_cov);
				fifo_cvr.sample();
			end
		endtask : run_phase
	endclass : FIFO_coverage
endpackage : FIFO_coverage_pkg