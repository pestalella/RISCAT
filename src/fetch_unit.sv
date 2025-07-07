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
	output IF_ID if_id_r
);
	assign rd_ram_addr =  ~reset_n ? '{default:0} : pc;

	always_ff @(posedge clk or negedge reset_n) begin
		if (~reset_n) begin
			if_id_r <= '{default:0};
			jump_was_fetched <= 0;
		end else if (jump_was_fetched) begin
			// Inject a NOP if the previous instruction was a jump
			if_id_r.pc <= if_id_r.pc;
			if_id_r.fetched_inst <= '{default:0};
			if_id_r.do_not_execute <= 1;
			jump_was_fetched <= 0;
		end else begin
			if_id_r.pc <= rd_ram_addr;
			if_id_r.fetched_inst <= rd_ram_data;
			jump_was_fetched <= rd_ram_data[6:0] == 7'b1101111;
		end
	end

endmodule

`endif

