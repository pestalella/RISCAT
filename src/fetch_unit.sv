`ifndef __FETCH_UNIT_SV__
`define __FETCH_UNIT_SV__

`include "pipeline_stage_registers.sv"

module fetch_unit(
	input logic clk,
	input logic reset_n,
	input logic [31:0] pc,
	input logic [31:0] rd_ram_data,

	output logic [31:0] rd_ram_addr,
	output IF_ID if_id_reg
	);

	always_ff @(posedge clk or negedge reset_n) begin
		if (!reset_n) begin
				rd_ram_addr <= '{default:0};
				fetched_inst_r <= '{default:0};
				if_id_reg <= '{default:0};
		end else begin
				rd_ram_addr <= pc;
				fetched_inst_r <= rd_ram_data;
				if_id_reg.pc <= pc;
		end
	end

endmodule

`endif

