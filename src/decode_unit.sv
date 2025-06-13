`ifndef __DECODE_UNIT_SV__
`define __DECODE_UNIT_SV__

`include "alu_enums.svh"
`include "pipeline_stage_registers.sv"

module decode_unit(
	input logic clk,
	input logic reset_n,
	input IF_ID if_id_reg,
	output ID_EX id_ex_reg
);

	logic is_reg_imm_inst;
	logic [2:0] inst_f3;

	logic is_addi;
	logic is_slti;
	logic is_sltiu;
	logic is_xori;
	logic is_ori;
	logic is_andi;

	assign is_reg_imm_inst = if_id_reg.fetched_inst[6:0] == 7'b0010011;
	assign inst_f3 = if_id_reg.fetched_inst[14:12];

	assign is_addi  = is_reg_imm_inst && (inst_f3 == 'b000);
	assign is_slti  = is_reg_imm_inst && (inst_f3 == 'b010);
	assign is_sltiu = is_reg_imm_inst && (inst_f3 == 'b011);
	assign is_xori  = is_reg_imm_inst && (inst_f3 == 'b100);
	assign is_ori   = is_reg_imm_inst && (inst_f3 == 'b110);
	assign is_andi  = is_reg_imm_inst && (inst_f3 == 'b111);

	logic [4:0] next_rd0_addr;
	logic [4:0] next_rd1_addr;

	always @(posedge clk or negedge reset_n) begin
		if (!reset_n) begin
			id_ex_reg <= '{default:0};
			next_rd0_addr <= '{default:0};
			next_rd1_addr <= '{default:0};
		end else begin
			next_rd0_addr <= 0;
			next_rd1_addr <= is_reg_imm_inst? if_id_reg.fetched_inst[19:15] : 0;

			id_ex_reg.raw_hazard_0 <= (id_ex_reg.reg_wr_addr != 0 && id_ex_reg.reg_wr_addr == next_rd0_addr);
			id_ex_reg.raw_hazard_1 <= (id_ex_reg.reg_wr_addr != 0 && id_ex_reg.reg_wr_addr == next_rd1_addr);

			id_ex_reg.pc <= if_id_reg.pc;
			id_ex_reg.reg_rd0_addr <= next_rd0_addr;
			id_ex_reg.reg_rd1_addr <= is_reg_imm_inst? if_id_reg.fetched_inst[19:15] : 0;
			id_ex_reg.reg_wr_addr <= is_reg_imm_inst? if_id_reg.fetched_inst[11:7] : 0;
			id_ex_reg.reg_rd0_en <= 0;
			id_ex_reg.reg_rd1_en <= is_reg_imm_inst;
			id_ex_reg.reg_wr_en <= is_reg_imm_inst;
			id_ex_reg.input_a_is_immediate <= is_reg_imm_inst;
			id_ex_reg.inst_imm <= is_reg_imm_inst? {{20{if_id_reg.fetched_inst[31]}}, if_id_reg.fetched_inst[31:20]} : 32'b0;
			id_ex_reg.inst_imm_sgn <= is_reg_imm_inst? {{20{if_id_reg.fetched_inst[31]}}, if_id_reg.fetched_inst[31:20]} : 0;
			id_ex_reg.alu_op <= is_addi? ALU_ADDI : (
													is_slti? ALU_SLTI : (
													is_sltiu? ALU_SLTIU : (
													is_xori? ALU_XORI : (
													is_ori? ALU_ORI : (
													is_andi? ALU_ANDI :
													ALU_NONE
													)))));
		end
	end
endmodule

`endif
