`ifndef ALU_ENUMS_SVH
`define ALU_ENUMS_SVH

typedef enum bit[3:0] {
	ALU_NONE,
	ALU_ADDI,
	ALU_SLTI,
	ALU_SLTIU,
	ALU_XORI,
	ALU_ORI,
	ALU_ANDI
} alu_command_t;

`endif
