`ifndef __ALU_SV__
`define __ALU_SV__

`include "alu_enums.svh"
`include "pipeline_stage_registers.sv"

module alu_stage(
	input logic clk,
	input logic reset_n,

	input ID_EX id_ex_reg,
	input logic [31:0] regfile_rd0_data,
	input logic [31:0] regfile_rd1_data,

	output bit result_ready,
	output logic [31:0] alu_result
);

	always @(posedge clk or negedge reset_n) begin
		if (!reset_n) begin
			alu_result <= '0;
			result_ready <= 0;
		end else begin
			if (id_ex_reg.alu_op == ALU_NONE) begin
				alu_result <= '0;
				result_ready <= 0;
			end else if (id_ex_reg.alu_op == ALU_ADD) begin
				alu_result <=  id_ex_reg.input_a_is_immediate? id_ex_reg.inst_imm + regfile_rd1_data : 0;
				result_ready <= 1;
			end else begin
				alu_result <= 'hdeadbeef;
				result_ready <= 0;
			end
		end
	end

endmodule

`endif
