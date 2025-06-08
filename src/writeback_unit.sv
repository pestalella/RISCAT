`ifndef __WRITEBACK_STAGE_SV__
`define __WRITEBACK_STAGE_SV__

// `include "alu_enums.svh"
// `include "pipeline_stage_registers.sv"

module writeback_unit(
	input logic clk,
	input logic reset_n,

	input bit result_ready,
	input logic [31:0] alu_result,
	input logic [4:0] wr_addr,

	output logic reg_wr_en,
	output logic [4:0] reg_wr_addr,
	output logic [31:0] reg_wr_data
);

	always @(posedge clk or negedge reset_n) begin
		if (!reset_n) begin
			reg_wr_en <= 0;
			reg_wr_addr <= 0;
			reg_wr_data <= 0;
		end else begin
			if (result_ready) begin
				reg_wr_en <= 1;
				reg_wr_addr <= wr_addr;
				reg_wr_data <= alu_result;
			end
		end
	end

endmodule

`endif
