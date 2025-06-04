`ifndef __FETCH_UNIT_SV__
`define __FETCH_UNIT_SV__

module fetch_stage(
	input logic clk,
	input logic reset_n,
	input logic [31:0] pc,
	input logic [31:0] rd_ram_data,

	output logic [31:0] rd_ram_addr,
	output logic [31:0] fetched_inst
	);

	logic [31:0] fetched_inst_r;
	assign fetched_inst = fetched_inst_r;

	always @(posedge clk or negedge reset_n) begin
		if (!reset_n) begin
				fetched_inst_r <= 0;
		end else begin
				rd_ram_addr <= pc;
				fetched_inst_r <= rd_ram_data;
		end
	end

endmodule

`endif

