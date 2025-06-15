`ifndef __ALU_SV__
`define __ALU_SV__

`include "alu_enums.svh"
`include "pipeline_stage_registers.sv"

module alu_stage(
	input logic clk,
	input logic reset_n,

	input ID_EX id_ex_reg,
	input	logic [31:0] alu_reg_input_a,
	input logic [31:0] alu_reg_input_b,

	output 	EX_WB ex_wb_reg
);

	always @(posedge clk or negedge reset_n) begin
		if (!reset_n) begin
			ex_wb_reg <= '{default:0};
			ex_wb_reg.alu_result <= '0;
			ex_wb_reg.alu_result_ready <= 0;
		end else begin
			ex_wb_reg.alu_result = 'hdeadbeef;
			ex_wb_reg.alu_result_ready = 0;
			if (id_ex_reg.alu_op == ALU_NONE) begin
				ex_wb_reg.alu_result <= '0;
				ex_wb_reg.alu_result_ready <= 0;
			end else begin
				if (id_ex_reg.alu_op == ALU_ADDI) begin
					ex_wb_reg.alu_result <= id_ex_reg.inst_imm + alu_reg_input_b;
				end else if (id_ex_reg.alu_op == ALU_SLTI) begin
					ex_wb_reg.alu_result <= (signed'(alu_reg_input_b) < signed'(id_ex_reg.inst_imm_sgn))? 1 : 0;
				end else if (id_ex_reg.alu_op == ALU_SLTIU) begin
					ex_wb_reg.alu_result <= (alu_reg_input_b < id_ex_reg.inst_imm_sgn)? 1 : 0;
				end else if (id_ex_reg.alu_op == ALU_XORI) begin
					ex_wb_reg.alu_result <= alu_reg_input_b ^ id_ex_reg.inst_imm_sgn;
				end else if (id_ex_reg.alu_op == ALU_ORI) begin
					ex_wb_reg.alu_result <= alu_reg_input_b | id_ex_reg.inst_imm_sgn;
				end else if (id_ex_reg.alu_op == ALU_ANDI) begin
					ex_wb_reg.alu_result <= alu_reg_input_b & id_ex_reg.inst_imm_sgn;
				end
				ex_wb_reg.alu_result_ready <= 1;
				ex_wb_reg.reg_wr_addr <= id_ex_reg.reg_wr_addr;
				ex_wb_reg.reg_wr_en <= id_ex_reg.reg_wr_en;

			end
		end
	end

endmodule

`endif
