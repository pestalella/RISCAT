`ifndef R32I_ISA_SVH
`define R32I_ISA_SVH

typedef enum {
	// ALU intructions
	ADDI,
	SLTI,
	SLTIU,
	XORI,
	ORI,
	ANDI,
	SLLI,
	SRLI,
	SRAI,
	ADD,
	SUB,
	SLL,
	SLT,
	SLTU,
	XOR,
	SRL,
	SRA,
	OR,
	AND,
	// Jumps
	JAL
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
	rand bit [11:0] imm;
	rand bit [4:0] rs1;
	rand bit [4:0] rd;
	rand bit [4:0] shamt;

	function new(instruction inst);
		super.new(inst);

		opcode = 7'b0010011;
		if (inst == ADDI) begin
			funct3 = 3'b000;
		end else if (inst == SLLI) begin
			funct3 = 3'b001;
		end else if (inst == SLTI) begin
			funct3 = 3'b010;
		end else if (inst == SLTIU) begin
			funct3 = 3'b011;
		end else if (inst == XORI) begin
			funct3 = 3'b100;
		end else if (inst == SRLI) begin
			funct3 = 3'b101;
		end else if (inst == SRAI) begin
			funct3 = 3'b101;
		end else if (inst == ORI) begin
			funct3 = 3'b110;
		end else if (inst == ANDI) begin
			funct3 = 3'b111;
		end
	endfunction

	function string sprint();
		if (op == SLLI || op == SRLI || op == SRAI)
			return $sformatf("%s r%1d, r%1d, %1d", op.name, rd, rs1,  shamt);
		else
			return $sformatf("%s r%1d, r%1d, %1d", op.name, rd, rs1,  signed'({{20{imm[11]}}, imm[11:0]}));
	endfunction

	function bit[31:0] encoded();
		if (op == SLLI || op == SRLI)
			return {>>{7'b0000000, shamt, rs1, funct3, rd, opcode}};
		else  if (op == SRAI)
			return {>>{7'b0100000, shamt, rs1, funct3, rd, opcode}};
		else
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

class jal_inst extends riscv_instruction;
	rand bit[20:1] jump_offset;
	rand bit[4:0] rd;

	constraint sane_jumps { jump_offset[1] == 0; }
	constraint short_jumps { jump_offset < 64; }

	function new(instruction inst);
		super.new(inst);
		opcode = 7'b1101111;
	endfunction
	function string sprint();
		return $sformatf("JAL r%1d, %1d", rd, signed'(jump_offset));
	endfunction

	function bit[31:0] encoded();
		$display("JAL x%0d, %0d", rd, jump_offset);
		return {>>{{jump_offset[20], jump_offset[10:1], jump_offset[11], jump_offset[19:12]}, rd, opcode}};
	endfunction
endclass

class jalr_inst extends riscv_instruction;
	rand bit[11:0] imm;
	rand bit[4:0] rs1;
	rand bit[4:0] rd;
	function new(instruction inst);
		super.new(inst);
		opcode = 7'b1100111;
	endfunction
endclass

`endif
