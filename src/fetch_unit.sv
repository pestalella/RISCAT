`ifndef __FETCH_UNIT_SV__
`define __FETCH_UNIT_SV__

`include "pipeline_stage_registers.sv"

module fetch_unit(
	input logic clk,
	input logic reset_n,
	input logic [15:0] pc,
	input logic [31:0] rd_ram_data,

	output logic jump_was_fetched,
	output logic [15:0] rd_ram_addr,
	output IF_ID if_id_reg
);

	always_ff @(posedge clk or negedge reset_n) begin
		if (!reset_n) begin
			if_id_reg <= '{default:0};
			rd_ram_addr <= '{default:0};
			jump_was_fetched <= 0;
		end else if (jump_was_fetched) begin
			// Inject a NOP if the previous instruction was a jump
			if_id_reg.pc <= if_id_reg.pc;
			rd_ram_addr <= pc;
			if_id_reg.fetched_inst <= rd_ram_data;
			if_id_reg.do_not_execute <= 1;
			jump_was_fetched <= 0;
		end else begin
			if_id_reg.pc <= rd_ram_addr;
			rd_ram_addr <= pc;
			if_id_reg.fetched_inst <= rd_ram_data;
			jump_was_fetched <= rd_ram_data[6:0] == 7'b1101111;
		end
	end

endmodule

`endif

