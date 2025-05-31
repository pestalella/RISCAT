`ifndef R32I_ISA_SVH
`define R32I_ISA_SVH

typedef enum {ADDI} instruction;

class reg_imm_instruction;
	rand bit[11:0] imm;
	rand bit[4:0] src;
	bit[2:0] inst_sel;
	rand bit[4:0] dest;
	bit [6:0] opcode;

	function new(instruction inst);
		if (inst == ADDI) begin
			// randomize(imm);
			// randomize(src);
			// randomize(dest);
			imm = 12'b101010101010;
			src = 1;
			dest = 1;
			inst_sel = 3'b000;
			opcode = 7'b0010011;
		end
	endfunction

	function bit[31:0] encoded();
		return {>>{imm, src, inst_sel, dest, opcode}};
	endfunction
endclass

`endif
