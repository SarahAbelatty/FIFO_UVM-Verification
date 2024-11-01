module FIFO_SVA (FIFO_if.DUT FIFO_IF);

	always_comb begin
		if (!FIFO_IF.rst_n) 
			reset_assertion: assert final ((!FIFO_IF.wr_ack) && (!FIFO_IF.overflow) &&
			 (!FIFO_IF.underflow) && (!FIFO.count) && (!FIFO.rd_ptr) && (!FIFO.wr_ptr));
			reset_cover: cover final ((!FIFO_IF.wr_ack) && (!FIFO_IF.overflow) && 
				(!FIFO_IF.underflow) && (!FIFO.count) && (!FIFO.rd_ptr) && (!FIFO.wr_ptr));
	end

	always_comb begin
		if((FIFO_IF.rst_n)&&(FIFO.count == FIFO_IF.FIFO_DEPTH))
			full_assertion: assert final (FIFO_IF.full);
			full_cover: cover final (FIFO_IF.full);
	end

	always_comb begin
		if((FIFO_IF.rst_n)&&(FIFO.count == 0))
			empty_assertion: assert final (FIFO_IF.empty);
			empty_cover: cover final (FIFO_IF.empty);
	end

	always_comb begin
		if((FIFO_IF.rst_n)&&(FIFO.count == FIFO_IF.FIFO_DEPTH-1))
			almostfull_assertion: assert final (FIFO_IF.almostfull);
			almostfull_cover: cover final (FIFO_IF.almostfull);
	end

	always_comb begin
		if((FIFO_IF.rst_n)&&(FIFO.count == 1))
		almostempty_assertion: assert final (FIFO_IF.almostempty);
		almostempty_cover: cover final (FIFO_IF.almostempty);
	end

	property p1;
		@(posedge FIFO_IF.clk) disable iff(!FIFO_IF.rst_n)
		(FIFO_IF.wr_en && !FIFO_IF.full) |=> (((FIFO_IF.wr_ack) && (FIFO.wr_ptr == $past(FIFO.wr_ptr)+1)) || 
							 ((!FIFO.wr_ptr) && $past(FIFO.wr_ptr)+1 == 8));
	endproperty

	property p2;
		@(posedge FIFO_IF.clk) disable iff(!FIFO_IF.rst_n)
		(FIFO_IF.wr_en && FIFO_IF.full) |=> (FIFO_IF.overflow);
	endproperty

	property p3;
		@(posedge FIFO_IF.clk) disable iff(!FIFO_IF.rst_n)
		(FIFO_IF.rd_en && !FIFO_IF.empty) |=> ((FIFO.rd_ptr == $past(FIFO.rd_ptr)+1) || 
			((!FIFO.rd_ptr) && $past(FIFO.rd_ptr)+1 == 8));
	endproperty

	property p4;
		@(posedge FIFO_IF.clk) disable iff(!FIFO_IF.rst_n)
		(FIFO_IF.rd_en && FIFO_IF.empty) |=> (FIFO_IF.underflow);
	endproperty

	property p5;
		@(posedge FIFO_IF.clk) disable iff(!FIFO_IF.rst_n)
		(({FIFO_IF.wr_en, FIFO_IF.rd_en} == 2'b10) && !FIFO_IF.full)  |=> (FIFO.count == $past(FIFO.count) + 1);
	endproperty

	property p6;
		@(posedge FIFO_IF.clk) disable iff(!FIFO_IF.rst_n)
		(({FIFO_IF.wr_en, FIFO_IF.rd_en} == 2'b01) && !FIFO_IF.empty) |=> (FIFO.count == $past(FIFO.count) - 1);
	endproperty

		property p7;
		@(posedge FIFO_IF.clk) disable iff(!FIFO_IF.rst_n)
		(({FIFO_IF.wr_en, FIFO_IF.rd_en} == 2'b11) && FIFO_IF.full)  |=> (FIFO.count == $past(FIFO.count) - 1);
	endproperty

	property p8;
		@(posedge FIFO_IF.clk) disable iff(!FIFO_IF.rst_n)
		(({FIFO_IF.wr_en, FIFO_IF.rd_en} == 2'b11) && FIFO_IF.empty) |=> (FIFO.count == $past(FIFO.count) + 1);
	endproperty


	write_assertion: assert property(p1);
	write_cover: cover property(p1);

	overflow_assertion: assert property(p2);
	overflow_cover: cover property(p2);

	read_assertion: assert property(p3);
	read_cover: cover property(p3);

	underflow_assertion: assert property(p4);
	underflow_cover: cover property(p4);

	write_notfull_assertion: assert property(p5);
	write_notfull_cover: cover property(p5);

	read_notempty_assertion: assert property(p6);
	read_notempty_cover: cover property(p6);

	write_read_full_assertion: assert property(p7);
	write_read_full_cover: cover property(p7);

	write_read_empty_assertion: assert property(p8);
	write_read_empty_cover: cover property(p8);

endmodule : FIFO_SVA