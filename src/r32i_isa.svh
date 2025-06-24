`ifndef R32I_ISA_SVH
`define R32I_ISA_SVH

typedef enum {
	ADDI,
	SLTI,
	SLTIU,
	XORI,
	ORI,
	ANDI,
	ADD,
	SUB,
	SLL,
	SLT,
	SLTU,
	XOR,
	SRL,
	SRA,
	OR,
	AND
} instruction;

class riscv_instruction;
	instruction op;
	bit[2:0] funct3;
	bit [6:0] opcode;

	function new(instruction inst);
		op = inst;
	endfunction
endclass

class reg_imm_inst extends riscv_instruction;
	rand bit[11:0] imm;
	rand bit[4:0] rs1;
	rand bit[4:0] rd;

	function new(instruction inst);
		super.new(inst);

		opcode = 7'b0010011;
		if (inst == ADDI) begin
			funct3 = 3'b000;
		end else if (inst == SLTI) begin
			funct3 = 3'b010;
		end else if (inst == SLTIU) begin
			funct3 = 3'b011;
		end else if (inst == XORI) begin
			funct3 = 3'b100;
		end else if (inst == ORI) begin
			funct3 = 3'b110;
		end else if (inst == ANDI) begin
			funct3 = 3'b111;
		end
	endfunction

	function string sprint();
		return $sformatf("%s r%1d, r%1d, %1d", op.name, rd, rs1,  signed'({{20{imm[11]}}, imm[11:0]}));
	endfunction

	function bit[31:0] encoded();
		return {>>{imm, rs1, funct3, rd, opcode}};
	endfunction
endclass

class reg_reg_inst extends riscv_instruction;
	bit [6:0] funct7;
	rand bit[4:0] rs1;
	rand bit[4:0] rs2;
	rand bit[4:0] rd;

	function new(instruction inst);
		super.new(inst);
		opcode = 7'b0110011;
		funct7 = 7'b0000000;
		if (inst == ADD) begin
			funct3 = 3'b000;
		end if (inst == SUB) begin
			funct3 = 3'b000;
			funct7 = 7'b0100000;
		end else if (inst == SLL) begin
			funct3 = 3'b001;
		end else if (inst == SLT) begin
			funct3 = 3'b010;
		end else if (inst == SLTU) begin
			funct3 = 3'b011;
		end else if (inst == XOR) begin
			funct3 = 3'b100;
		end else if (inst == SRL) begin
			funct3 = 3'b101;
		end else if (inst == SRA) begin
			funct3 = 3'b101;
			funct7 = 7'b0100000;
		end else if (inst == OR) begin
			funct3 = 3'b110;
		end else if (inst == AND) begin
			funct3 = 3'b111;
		end
	endfunction

	function string sprint();
		return $sformatf("%s r%1d, r%1d, r%1d", op.name, rd, rs1, rs2);
	endfunction

	function bit[31:0] encoded();
		return {>>{funct7, rs2, rs1, funct3, rd, opcode}};
	endfunction
endclass

`endif
