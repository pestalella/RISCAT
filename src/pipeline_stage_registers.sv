`ifndef __PIPELINE_STAGE_REGISTERS__
`define __PIPELINE_STAGE_REGISTERS__

`include "alu_enums.svh"

typedef struct packed {
	logic [31:0] pc;
	logic [31:0] fetched_inst;
} IF_ID;


typedef struct packed {
	logic [31:0] pc;
	logic [4:0] reg_rs1_addr;
	logic [4:0] reg_rs2_addr;
	logic [4:0] reg_wr_addr;
	logic reg_rs1_en;
	logic reg_rs2_en;
	logic reg_wr_en;

	logic [31:0] inst_imm;
	logic [31:0] inst_imm_sgn;
	logic [4:0] shamt;

	alu_command_t alu_op;
} ID_EX;


typedef struct packed {
	logic [31:0] pc;
	logic reg_wr_en;
	logic [4:0] reg_wr_addr;
	logic alu_result_ready;
  logic [31:0] alu_result;
} EX_WB;

`endif
