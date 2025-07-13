`ifndef __PIPELINE_STAGE_REGISTERS__
`define __PIPELINE_STAGE_REGISTERS__

`include "alu_enums.svh"

typedef struct packed {
	logic [15:0] pc;
	logic [31:0] fetched_inst;
	logic do_not_execute;
} IF_ID;


typedef struct packed {
	logic [15:0] pc;
	logic [4:0] rs1_addr;
	logic [4:0] rs2_addr;
	logic [4:0] reg_wr_addr;
	logic rs1_rd_en;
	logic rs2_rd_en;
	logic rd_wr_en;

	logic [31:0] inst_imm;
	logic [31:0] inst_imm_sgn;
	logic [4:0] shamt;

	alu_command_t alu_op;

	logic [20:1] jump_offset;
	logic [31:0] jump_return_addr;
	logic is_jump;

	logic do_not_execute;
} ID_EX;


typedef struct packed {
	logic [15:0] pc;
	logic rd_wr_en;
	logic [4:0] reg_wr_addr;
	logic alu_result_ready;
	logic [31:0] alu_result;

	logic do_not_execute;
} EX_WB;

`endif
