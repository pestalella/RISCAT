`ifndef ALU_ENUMS_SVH
`define ALU_ENUMS_SVH

typedef enum bit[3:0] {
	ALU_NONE,
	ALU_ADD,
	ALU_SUB,
	ALU_SLT,
	ALU_SLTU,
	ALU_XOR,
	ALU_OR,
	ALU_AND,
	ALU_SHL,
	ALU_SHR
} alu_command_t;

`endif
