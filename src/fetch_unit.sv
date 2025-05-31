module fetch_stage0(
	input logic clk,
	input logic reset_n,
//	input logic fetch_en,
	input logic [31:0] pc,

//	output logic fetch_started,
//	output logic rd_ram_en,
	output logic [31:0] rd_ram_addr
	);

	always @(posedge clk) begin
		if (!reset_n) begin
//				rd_ram_en <= 0;
//				fetch_started <= 0;
		end else begin
//			if (fetch_en) begin
			rd_ram_addr <= pc;
//			rd_ram_en <= 1;
//				fetch_started <= 1;
			// end else begin
			// 	rd_ram_en <= 0;
			// 	fetch_started <= 0;
			// end
		end
	end

endmodule


module fetch_stage1(
	input logic clk,
	input logic reset_n,
//	input logic fetch_started,
	input logic [31:0] rd_ram_data,

//	output logic fetch_en,
//	output logic fetch_completed,
	output logic [31:0] fetched_inst
	);

	logic [31:0] fetched_inst_r;
	assign fetched_inst = fetched_inst_r;

	always @(posedge clk) begin
		if (!reset_n) begin
				fetched_inst_r <= 0;
//				fetch_completed <= 0;
		end else begin
//			if (fetch_started) begin
				fetched_inst_r <= rd_ram_data;
				// fetch_completed <= 1;
				// fetch_en <= 0;
			// end else begin
			// 	fetch_completed <= 0;
			// end
		end
	end

endmodule
