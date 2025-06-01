`ifndef __ALU_SV__
`define __ALU_SV__

`include "alu_enums.svh"

module alu_stage(
	input logic clk,
	input logic reset_n,
	input logic [11:0] immediate,
	input logic [31:0] regfile_rd0_data,
	input logic [31:0] regfile_rd1_data,
	input logic input_a_is_immediate,
	input alu_command_t alu_op,
	output bit result_ready,
	output logic [31:0] alu_result
);

	always @(posedge clk) begin
		if (!reset_n) begin
			alu_result <= '0;
			result_ready <= 0;
		end else begin
			if (alu_op == ALU_NONE) begin
				alu_result <= '0;
				result_ready <= 0;
			end else if (alu_op == ALU_ADD) begin
				alu_result <=  input_a_is_immediate? immediate + regfile_rd1_data : 0;
				result_ready <= 1;
			end else begin
				alu_result <= 'hdeadbeef;
				result_ready <= 0;
			end
		end
	end

endmodule


`endif
