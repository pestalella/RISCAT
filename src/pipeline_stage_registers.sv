`ifndef __PIPELINE_STAGE_REGISTERS__
`define __PIPELINE_STAGE_REGISTERS__

typedef struct packed {
	logic [31:0] pc;
	logic [31:0] fetched_inst;
} IF_ID;


typedef struct packed {
	logic [31:0] pc;
	logic [4:0] reg_rd0_addr;
	logic [4:0] reg_rd1_addr;
	logic [4:0] reg_wr_addr;
	logic reg_rd0_en;
	logic reg_rd1_en;
	logic reg_wr_en;
	logic raw_hazard_0;
	logic raw_hazard_1;

	logic input_a_is_immediate;
	logic [31:0] inst_imm;
	logic [31:0] inst_imm_sgn;

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
