`ifndef __DECODE_UNIT_SV__
`define __DECODE_UNIT_SV__

`include "alu_enums.svh"
`include "pipeline_stage_registers.sv"

module decode_unit(
	input logic clk,
	input logic reset_n,
	input IF_ID if_id_r,
	output ID_EX id_ex_r
);

	logic is_reg_imm_inst;
	logic [2:0] inst_f3;
	logic [6:0] inst_f7;

	logic is_addi;
	logic is_slti;
	logic is_sltiu;
	logic is_xori;
	logic is_ori;
	logic is_andi;
	logic is_slli;
	logic is_srli;
	logic is_srai;

	logic is_add;
	logic is_sub;
	logic is_sll;
	logic is_slt;
	logic is_sltu;
	logic is_xor;
	logic is_srl;
	logic is_sra;
	logic is_or;
	logic is_and;

	logic is_jal;

	assign is_reg_imm_inst = if_id_r.fetched_inst[6:0] == 7'b0010011;
	assign is_reg_reg_inst = if_id_r.fetched_inst[6:0] == 7'b0110011;
	assign inst_f3 = if_id_r.fetched_inst[14:12];
	assign inst_f7 = if_id_r.fetched_inst[31:25];

	assign is_addi  = is_reg_imm_inst && (inst_f3 == 'b000);
	assign is_slli  = is_reg_imm_inst && (inst_f3 == 'b001);
	assign is_slti  = is_reg_imm_inst && (inst_f3 == 'b010);
	assign is_sltiu = is_reg_imm_inst && (inst_f3 == 'b011);
	assign is_xori  = is_reg_imm_inst && (inst_f3 == 'b100);
	assign is_srli =  is_reg_imm_inst && (inst_f3 == 'b101);
	assign is_srai =  is_reg_imm_inst && (inst_f7 == 'b0100000) && (inst_f3 == 'b101);
	assign is_ori   = is_reg_imm_inst && (inst_f3 == 'b110);
	assign is_andi  = is_reg_imm_inst && (inst_f3 == 'b111);

	assign is_add  = is_reg_reg_inst && (inst_f7 == 'b0000000) && (inst_f3 == 'b000);
	assign is_sub  = is_reg_reg_inst && (inst_f7 == 'b0100000) && (inst_f3 == 'b000);
	assign is_sll  = is_reg_reg_inst && (inst_f7 == 'b0000000) && (inst_f3 == 'b001);
	assign is_slt  = is_reg_reg_inst && (inst_f7 == 'b0000000) && (inst_f3 == 'b010);
	assign is_sltu = is_reg_reg_inst && (inst_f7 == 'b0000000) && (inst_f3 == 'b011);
	assign is_xor  = is_reg_reg_inst && (inst_f7 == 'b0000000) && (inst_f3 == 'b100);
	assign is_srl  = is_reg_reg_inst && (inst_f7 == 'b0000000) && (inst_f3 == 'b101);
	assign is_sra  = is_reg_reg_inst && (inst_f7 == 'b0100000) && (inst_f3 == 'b101);
	assign is_or   = is_reg_reg_inst && (inst_f7 == 'b0000000) && (inst_f3 == 'b110);
	assign is_and  = is_reg_reg_inst && (inst_f7 == 'b0000000) && (inst_f3 == 'b111);

	assign is_jal = if_id_r.fetched_inst[6:0] == 7'b1101111;

	logic [4:0] next_rd0_addr;
	logic [4:0] next_rd1_addr;

	always_ff @(posedge clk or negedge reset_n) begin
		if (!reset_n) begin
			id_ex_r <= '{default:0};
			next_rd0_addr <= '{default:0};
			next_rd1_addr <= '{default:0};
		end else begin
			next_rd0_addr <= if_id_r.fetched_inst[19:15];  // All the instructions with rs1 get the address from those bits
			next_rd1_addr <= is_reg_reg_inst? if_id_r.fetched_inst[24:20] : 0;

			id_ex_r.reg_rs1_addr <= if_id_r.fetched_inst[19:15];
			id_ex_r.reg_rs2_addr <= is_reg_reg_inst? if_id_r.fetched_inst[24:20] : 0;
			id_ex_r.reg_wr_addr <= if_id_r.fetched_inst[11:7];
			id_ex_r.reg_rs1_en <= is_reg_imm_inst | is_reg_reg_inst;
			id_ex_r.reg_rs2_en <= is_reg_reg_inst;
			id_ex_r.reg_wr_en <= is_reg_imm_inst | is_reg_reg_inst;
			id_ex_r.inst_imm <= is_reg_imm_inst? {{20{if_id_r.fetched_inst[31]}}, if_id_r.fetched_inst[31:20]} : 32'b0;
			id_ex_r.inst_imm_sgn <= is_reg_imm_inst? {{20{if_id_r.fetched_inst[31]}}, if_id_r.fetched_inst[31:20]} : 0;
			id_ex_r.shamt <= if_id_r.fetched_inst[24:20];
			id_ex_r.alu_op <= if_id_r.do_not_execute? ALU_NONE: (
								is_addi?  ALU_ADDI : (
								is_slti?  ALU_SLTI : (
								is_sltiu? ALU_SLTIU : (
								is_slli?  ALU_SLLI : (
								is_srli?  ALU_SRLI : (
								is_srai?  ALU_SRAI : (
								is_xori?  ALU_XORI : (
								is_ori?   ALU_ORI : (
								is_andi?  ALU_ANDI : (

								is_add?   ALU_ADD : (
								is_sub?   ALU_SUB : (
								is_sll?   ALU_SLL : (
								is_slt?   ALU_SLT : (
								is_sltu?  ALU_SLTU : (
								is_xor?   ALU_XOR : (
								is_srl?   ALU_SRL : (
								is_sra?   ALU_SRA : (
								is_or?    ALU_OR : (
								is_and?   ALU_AND : ALU_NONE
				)))))))))))))))))));

			id_ex_r.is_jump = is_jal;
			id_ex_r.pc <= if_id_r.pc;
			id_ex_r.jump_offset <= {
				if_id_r.fetched_inst[31],
				if_id_r.fetched_inst[19:12],
				if_id_r.fetched_inst[20],
				if_id_r.fetched_inst[30:21]
			};
			id_ex_r.do_not_execute = if_id_r.do_not_execute;
		end
	end
endmodule

`endif
