////////////////////////////////////////////////////////////////////////////////
// Author: Kareem Waseem
// Course: Digital Verification using SV & UVM
//
// Description: FIFO Design 
// 
////////////////////////////////////////////////////////////////////////////////
module FIFO(FIFO_if.DUT FIFO_IF);

logic [FIFO_IF.FIFO_WIDTH-1:0] data_in;
logic clk, rst_n, wr_en, rd_en;
logic [FIFO_IF.FIFO_WIDTH-1:0] data_out; 
logic wr_ack, overflow, underflow;
logic full, empty, almostfull, almostempty;
 
assign data_in = FIFO_IF.data_in;
assign clk = FIFO_IF.clk;
assign FIFO_IF.data_out = data_out;
assign rst_n = FIFO_IF.rst_n;
assign wr_en = FIFO_IF.wr_en;
assign rd_en = FIFO_IF.rd_en;
assign FIFO_IF.wr_ack = wr_ack;
assign FIFO_IF.overflow = overflow;
assign FIFO_IF.underflow = underflow;
assign FIFO_IF.full = full;
assign FIFO_IF.empty = empty;
assign FIFO_IF.almostfull = almostfull;
assign FIFO_IF.almostempty = almostempty;

reg [FIFO_IF.FIFO_WIDTH-1:0] mem [FIFO_IF.FIFO_DEPTH-1:0];

reg [FIFO_IF.max_fifo_addr-1:0] wr_ptr, rd_ptr;
reg [FIFO_IF.max_fifo_addr:0] count;

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		wr_ptr <= 0;
		// Bug detected: sequential output neaded to be zero when reset asserted 
		wr_ack <= 0;
		// Bug detected: sequential output neaded to be zero when reset asserted 
		overflow <= 0;
	end
	else if (wr_en && count < FIFO_IF.FIFO_DEPTH) begin
		mem[wr_ptr] <= data_in;
		wr_ack <= 1;
		wr_ptr <= wr_ptr + 1;
		overflow <= 0;
	end
	else begin 
		wr_ack <= 0; 
		if (full & wr_en)
			overflow <= 1;
		else
			overflow <= 0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		rd_ptr <= 0;
		// Bug detected: sequential output neaded to be zero when reset asserted 
		underflow <= 0;
	end
	else if (rd_en && count != 0) begin
		data_out <= mem[rd_ptr];
		rd_ptr <= rd_ptr + 1;
		underflow <= 0;
	end
	else begin 
		// Bug detected: sequential output underflow needed to be triggered with clk
		if (empty & rd_en)
			underflow <= 1;
		else
			underflow <= 0;
	end
end

always @(posedge clk or negedge rst_n) begin
	if (!rst_n) begin
		count <= 0;
	end
	else begin
		if	( ({wr_en, rd_en} == 2'b10) && !full) 
			count <= count + 1;
		else if ( ({wr_en, rd_en} == 2'b01) && !empty)
			count <= count - 1;
		// Bug detected: uncover case for If rd_en && wr_en high & FIFO empty,writing take place 
		else if (({wr_en, rd_en} == 2'b11) && empty)
			count <= count + 1;
		// Bug detected: uncover case for If rd_en && wr_en high & FIFO full,reading take place 
		else if (({wr_en, rd_en} == 2'b11) && full) 
			count <= count - 1;
	end
end

assign full = (count == FIFO_IF.FIFO_DEPTH)? 1 : 0;
assign empty = (count == 0)? 1 : 0;
// Bug detected: almostfull high when fifo has one place empty 
assign almostfull = (count == FIFO_IF.FIFO_DEPTH-1)? 1 : 0; 
assign almostempty = (count == 1)? 1 : 0;
endmodule

