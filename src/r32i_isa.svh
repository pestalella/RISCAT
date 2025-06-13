`ifndef R32I_ISA_SVH
`define R32I_ISA_SVH

typedef enum {ADDI, SLTI, SLTIU, XORI, ORI, ANDI} instruction;

class reg_imm_instruction;
	instruction op;
	rand bit[11:0] imm;
	rand bit[4:0] src;
	bit[2:0] inst_sel;
	rand bit[4:0] dst;
	bit [6:0] opcode;

	function new(instruction inst);
		op = inst;
		opcode = 7'b0010011;
		if (inst == ADDI) begin
			inst_sel = 3'b000;
		end else if (inst == SLTI) begin
			inst_sel = 3'b010;
		end else if (inst == SLTIU) begin
			inst_sel = 3'b011;
		end else if (inst == XORI) begin
			inst_sel = 3'b100;
		end else if (inst == ORI) begin
			inst_sel = 3'b110;
		end else if (inst == ANDI) begin
			inst_sel = 3'b111;
		end
	endfunction

	function string sprint();
		return $sformatf("%s r%1d, r%1d, %1d", op.name, dst, src,  signed'({{20{imm[11]}}, imm[11:0]}));

		// return $sformatf(
		// 	"------------------------------\n- Instruction -\n------------------------------\n  opcode:\t%07b\n  sel:\t%03b\n  src:\t%d\n  dest:\t%d\n  imm:\t%d\n------------------------------",
		// 	opcode, inst_sel, src, dest,  imm);
	endfunction

	function bit[31:0] encoded();
		return {>>{imm, src, inst_sel, dst, opcode}};
	endfunction
endclass

`endif
