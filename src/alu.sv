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

	logic [31:0] sll_result;
	logic [31:0] srl_result;
	logic [31:0] sra_result;
;
	logic is_reg_imm_shift;
	logic [4:0] shift_amount;
	
	assign is_reg_imm_shift = id_ex_reg.alu_op == ALU_SLLI | id_ex_reg.alu_op == ALU_SRLI | id_ex_reg.alu_op == ALU_SRAI;
    assign shift_amount = is_reg_imm_shift ? id_ex_reg.shamt : alu_reg_input_b[4:0];

	shifter shifter_unit(
		.input_value(alu_reg_input_a),
		.amount(shift_amount),
		.logic_left_shift(sll_result),
		.logic_right_shift(srl_result),
		.arithmetic_right_shift(sra_result)
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
				// Reg-imm operations
				if (id_ex_reg.alu_op == ALU_ADDI) begin
					ex_wb_reg.alu_result <=  alu_reg_input_a + signed'(id_ex_reg.inst_imm_sgn);
				end else if (id_ex_reg.alu_op == ALU_SLTI) begin
					ex_wb_reg.alu_result <= (signed'(alu_reg_input_a) < signed'(id_ex_reg.inst_imm_sgn))? 1 : 0;
				end else if (id_ex_reg.alu_op == ALU_SLTIU) begin
					ex_wb_reg.alu_result <= (signed'(alu_reg_input_a) < id_ex_reg.inst_imm_sgn)? 1 : 0;
				end else if (id_ex_reg.alu_op == ALU_XORI) begin
					ex_wb_reg.alu_result <= signed'(alu_reg_input_a) ^ id_ex_reg.inst_imm_sgn;
				end else if (id_ex_reg.alu_op == ALU_ORI) begin
					ex_wb_reg.alu_result <= signed'(alu_reg_input_a) | id_ex_reg.inst_imm_sgn;
				end else if (id_ex_reg.alu_op == ALU_ANDI) begin
					ex_wb_reg.alu_result <= signed'(alu_reg_input_a) & id_ex_reg.inst_imm_sgn;
				end else if (id_ex_reg.alu_op == ALU_SLLI) begin
					ex_wb_reg.alu_result <= sll_result;
				end else if (id_ex_reg.alu_op == ALU_SRLI) begin
					ex_wb_reg.alu_result <= srl_result;
				end else if (id_ex_reg.alu_op == ALU_SRAI) begin
					ex_wb_reg.alu_result <= sra_result;

				// Reg-reg operations
				end else if (id_ex_reg.alu_op == ALU_ADD) begin
					ex_wb_reg.alu_result <= signed'(alu_reg_input_a) + signed'(alu_reg_input_b);
				end else if (id_ex_reg.alu_op == ALU_SUB) begin
					ex_wb_reg.alu_result <= signed'(alu_reg_input_a) - signed'(alu_reg_input_b);
				end else if (id_ex_reg.alu_op == ALU_SLT) begin
					ex_wb_reg.alu_result <= signed'(alu_reg_input_a) < signed'(alu_reg_input_b);
				end else if (id_ex_reg.alu_op == ALU_SLTU) begin
					ex_wb_reg.alu_result <= (alu_reg_input_a < alu_reg_input_b)? 1 : 0;
				end else if (id_ex_reg.alu_op == ALU_XOR) begin
					ex_wb_reg.alu_result <= alu_reg_input_a ^ alu_reg_input_b;
				end else if (id_ex_reg.alu_op == ALU_OR) begin
					ex_wb_reg.alu_result <= alu_reg_input_a | alu_reg_input_b;
				end else if (id_ex_reg.alu_op == ALU_AND) begin
					ex_wb_reg.alu_result <= alu_reg_input_a & alu_reg_input_b;
				end else if (id_ex_reg.alu_op == ALU_SLL) begin
					ex_wb_reg.alu_result <= sll_result;
				end else if (id_ex_reg.alu_op == ALU_SRL) begin
					ex_wb_reg.alu_result <= srl_result;
				end else if (id_ex_reg.alu_op == ALU_SRA) begin
					ex_wb_reg.alu_result <= sra_result;
				end
				ex_wb_reg.alu_result_ready <= 1;
				ex_wb_reg.reg_wr_addr <= id_ex_reg.reg_wr_addr;
				ex_wb_reg.reg_wr_en <= id_ex_reg.reg_wr_en;

			end
		end
	end

endmodule

module shifter(
	input logic [31:0] input_value,
	input logic [4:0] amount,
	output logic [31:0] logic_left_shift,
	output logic [31:0] logic_right_shift,
	output logic [31:0] arithmetic_right_shift
);

	logic [31:0] logic_left_shifted[0:31];
	logic [31:0] logic_right_shifted[0:31];
	logic [31:0] arith_right_shifted[0:31];

	assign logic_left_shifted[0] = input_value << 0;
	assign logic_left_shifted[1] = input_value << 1;
	assign logic_left_shifted[2] = input_value << 2;
	assign logic_left_shifted[3] = input_value << 3;
	assign logic_left_shifted[4] = input_value << 4;
	assign logic_left_shifted[5] = input_value << 5;
	assign logic_left_shifted[6] = input_value << 6;
	assign logic_left_shifted[7] = input_value << 7;
	assign logic_left_shifted[8] = input_value << 8;
	assign logic_left_shifted[9] = input_value << 9;
	assign logic_left_shifted[10] = input_value << 10;
	assign logic_left_shifted[11] = input_value << 11;
	assign logic_left_shifted[12] = input_value << 12;
	assign logic_left_shifted[13] = input_value << 13;
	assign logic_left_shifted[14] = input_value << 14;
	assign logic_left_shifted[15] = input_value << 15;
	assign logic_left_shifted[16] = input_value << 16;
	assign logic_left_shifted[17] = input_value << 17;
	assign logic_left_shifted[18] = input_value << 18;
	assign logic_left_shifted[19] = input_value << 19;
	assign logic_left_shifted[20] = input_value << 20;
	assign logic_left_shifted[21] = input_value << 21;
	assign logic_left_shifted[22] = input_value << 22;
	assign logic_left_shifted[23] = input_value << 23;
	assign logic_left_shifted[24] = input_value << 24;
	assign logic_left_shifted[25] = input_value << 25;
	assign logic_left_shifted[26] = input_value << 26;
	assign logic_left_shifted[27] = input_value << 27;
	assign logic_left_shifted[28] = input_value << 28;
	assign logic_left_shifted[29] = input_value << 29;
	assign logic_left_shifted[30] = input_value << 30;
	assign logic_left_shifted[31] = input_value << 31;

	assign logic_right_shifted[0] = input_value >> 0;
	assign logic_right_shifted[1] = input_value >> 1;
	assign logic_right_shifted[2] = input_value >> 2;
	assign logic_right_shifted[3] = input_value >> 3;
	assign logic_right_shifted[4] = input_value >> 4;
	assign logic_right_shifted[5] = input_value >> 5;
	assign logic_right_shifted[6] = input_value >> 6;
	assign logic_right_shifted[7] = input_value >> 7;
	assign logic_right_shifted[8] = input_value >> 8;
	assign logic_right_shifted[9] = input_value >> 9;
	assign logic_right_shifted[10] = input_value >> 10;
	assign logic_right_shifted[11] = input_value >> 11;
	assign logic_right_shifted[12] = input_value >> 12;
	assign logic_right_shifted[13] = input_value >> 13;
	assign logic_right_shifted[14] = input_value >> 14;
	assign logic_right_shifted[15] = input_value >> 15;
	assign logic_right_shifted[16] = input_value >> 16;
	assign logic_right_shifted[17] = input_value >> 17;
	assign logic_right_shifted[18] = input_value >> 18;
	assign logic_right_shifted[19] = input_value >> 19;
	assign logic_right_shifted[20] = input_value >> 20;
	assign logic_right_shifted[21] = input_value >> 21;
	assign logic_right_shifted[22] = input_value >> 22;
	assign logic_right_shifted[23] = input_value >> 23;
	assign logic_right_shifted[24] = input_value >> 24;
	assign logic_right_shifted[25] = input_value >> 25;
	assign logic_right_shifted[26] = input_value >> 26;
	assign logic_right_shifted[27] = input_value >> 27;
	assign logic_right_shifted[28] = input_value >> 28;
	assign logic_right_shifted[29] = input_value >> 29;
	assign logic_right_shifted[30] = input_value >> 30;
	assign logic_right_shifted[31] = input_value >> 31;

	assign arith_right_shifted[0] = input_value >>> 0;
	assign arith_right_shifted[1] = input_value >>> 1;
	assign arith_right_shifted[2] = input_value >>> 2;
	assign arith_right_shifted[3] = input_value >>> 3;
	assign arith_right_shifted[4] = input_value >>> 4;
	assign arith_right_shifted[5] = input_value >>> 5;
	assign arith_right_shifted[6] = input_value >>> 6;
	assign arith_right_shifted[7] = input_value >>> 7;
	assign arith_right_shifted[8] = input_value >>> 8;
	assign arith_right_shifted[9] = input_value >>> 9;
	assign arith_right_shifted[10] = input_value >>> 10;
	assign arith_right_shifted[11] = input_value >>> 11;
	assign arith_right_shifted[12] = input_value >>> 12;
	assign arith_right_shifted[13] = input_value >>> 13;
	assign arith_right_shifted[14] = input_value >>> 14;
	assign arith_right_shifted[15] = input_value >>> 15;
	assign arith_right_shifted[16] = input_value >>> 16;
	assign arith_right_shifted[17] = input_value >>> 17;
	assign arith_right_shifted[18] = input_value >>> 18;
	assign arith_right_shifted[19] = input_value >>> 19;
	assign arith_right_shifted[20] = input_value >>> 20;
	assign arith_right_shifted[21] = input_value >>> 21;
	assign arith_right_shifted[22] = input_value >>> 22;
	assign arith_right_shifted[23] = input_value >>> 23;
	assign arith_right_shifted[24] = input_value >>> 24;
	assign arith_right_shifted[25] = input_value >>> 25;
	assign arith_right_shifted[26] = input_value >>> 26;
	assign arith_right_shifted[27] = input_value >>> 27;
	assign arith_right_shifted[28] = input_value >>> 28;
	assign arith_right_shifted[29] = input_value >>> 29;
	assign arith_right_shifted[30] = input_value >>> 30;
	assign arith_right_shifted[31] = input_value >>> 31;

	assign logic_left_shift = logic_left_shifted[amount];
	assign logic_right_shift = logic_right_shifted[amount];
	assign arithmetic_right_shift = arith_right_shifted[amount];

endmodule

`endif
