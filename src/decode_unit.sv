`include "alu_enums.svh"

module decode_unit(
	input logic clk,
	input logic reset_n,
	input	logic [31:0] fetched_inst,

	output logic [4:0] reg_rd0_addr,
	output logic [4:0] reg_rd1_addr,
	output logic [4:0] reg_wr_addr,
	output logic reg_rd0_en,
	output logic reg_rd1_en,
	output logic reg_wr_en,
	output logic input_a_is_immediate,
	output logic [11:0] inst_imm,
	output alu_command_t alu_op
);

	bit is_reg_imm_inst;
	bit [2:0] inst_f3;

	bit is_addi;
	bit is_slti;
	bit is_sltiu;
	bit is_xori;
	bit is_ori;
	bit is_andi;

	assign is_reg_imm_inst = fetched_inst[6:0] == 7'b0010011;
	assign inst_f3 = fetched_inst[14:12];

	assign is_addi  = is_reg_imm_inst && (inst_f3 == 'b000);
	assign is_slti  = is_reg_imm_inst && (inst_f3 == 'b010);
	assign is_sltiu = is_reg_imm_inst && (inst_f3 == 'b011);
	assign is_xori  = is_reg_imm_inst && (inst_f3 == 'b100);
	assign is_ori   = is_reg_imm_inst && (inst_f3 == 'b110);
	assign is_andi  = is_reg_imm_inst && (inst_f3 == 'b111);

	always @(posedge clk) begin
		if (!reset_n) begin
			reg_rd0_addr <= 0;
			reg_rd1_addr <= 0;
			reg_wr_addr <= 0;
			reg_rd0_en <= 0;
			reg_rd1_en <= 0;
			reg_wr_en <= 0;
			input_a_is_immediate <= 0;
			inst_imm <= 0;
			alu_op <= ALU_NONE;
		end else begin
			reg_rd0_addr <= 0;
			reg_rd1_addr <= is_reg_imm_inst? fetched_inst[19:15] : 0;
			reg_wr_addr <= is_reg_imm_inst? fetched_inst[11:7] : 0;
			reg_rd0_en <= 0;
			reg_rd1_en <= is_reg_imm_inst;
			reg_wr_en <= is_reg_imm_inst;
			input_a_is_immediate <= is_reg_imm_inst;
			inst_imm <= is_reg_imm_inst? fetched_inst[31:20] : 0;
			alu_op <= is_addi? ALU_ADD : (
								is_slti? ALU_SLT : (
								is_sltiu? ALU_SLTU : (
								is_xori? ALU_XOR : (
								is_ori? ALU_OR : (
								is_andi? ALU_AND :
								ALU_NONE
								)))));
		end
	end
endmodule

