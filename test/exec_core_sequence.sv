`ifndef __EXEC_CORE_SEQUENCE_SV__
`define __EXEC_CORE_SEQUENCE_SV__

class exec_core_sequence extends uvm_sequence #(exec_core_transaction);

	`uvm_object_utils(exec_core_sequence)

	function new (string name = "");
		super.new(name);
	endfunction

	task do_alu_items;
		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 1; req.rs1 == 0; req.imm == 10;})
		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 2; req.rs1 == 1; req.imm == 10;})
		repeat(10)
		begin
			`uvm_do_with(req, { req.cmd == CMD_ADDI;})
		end
		repeat(1)
		begin
			`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 1; req.rs1 == 0; req.imm == 10;})
			`uvm_do_with(req, { req.cmd == CMD_SLTI; req.rd == 31; req.rs1 == 1; req.imm == 11;})  // r31 = 1
			`uvm_do_with(req, { req.cmd == CMD_SLTI; req.rd == 30; req.rs1 == 1; req.imm == 9;})  // r30 = 0
			`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 2; req.rs1 == 0; req.imm == 12'b111111111111;})
			`uvm_do_with(req, { req.cmd == CMD_SLTI; req.rd == 29; req.rs1 == 2; req.imm == 0;})  // r29 = 1
		end

		repeat(1)
		begin
			`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 1; req.rs1 == 0; req.imm == 10;})
			`uvm_do_with(req, { req.cmd == CMD_SLTIU; req.rd == 31; req.rs1 == 1; req.imm == 11;})  // r31 = 1
			`uvm_do_with(req, { req.cmd == CMD_SLTIU; req.rd == 30; req.rs1 == 1; req.imm == 9;})  // r30 = 0
			`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 2; req.rs1 == 0; req.imm == 12'b111111111111;})
			`uvm_do_with(req, { req.cmd == CMD_SLTIU; req.rd == 29; req.rs1 == 2; req.imm == 0;})  // r29 = 0
		end

		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 1; req.rs1 == 0; req.imm == 'b101010101010;})
		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 2; req.rs1 == 0; req.imm == 'b111111000000;})
		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 3; req.rs1 == 0; req.imm == 'b000000111111;})
		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 4; req.rs1 == 0; req.imm == 'b111111111111;})
		`uvm_do_with(req, { req.cmd == CMD_ANDI; req.rd == 10; req.rs1 == 1; req.imm == 'b111111111111;})
		`uvm_do_with(req, { req.cmd == CMD_ANDI; req.rd == 11; req.rs1 == 2; req.imm == 'b111111111111;})
		`uvm_do_with(req, { req.cmd == CMD_ANDI; req.rd == 12; req.rs1 == 3; req.imm == 'b111111111111;})
		`uvm_do_with(req, { req.cmd == CMD_ANDI; req.rd == 13; req.rs1 == 4; req.imm == 'b111111111111;})
		`uvm_do_with(req, { req.cmd == CMD_ANDI; req.rd == 20; req.rs1 == 1; req.imm == 'b010101010101;})
		`uvm_do_with(req, { req.cmd == CMD_ANDI; req.rd == 21; req.rs1 == 2; req.imm == 'b000000000000;})
		`uvm_do_with(req, { req.cmd == CMD_ANDI; req.rd == 22; req.rs1 == 3; req.imm == 'b101010101010;})
		`uvm_do_with(req, { req.cmd == CMD_ANDI; req.rd == 23; req.rs1 == 4; req.imm == 'b001100110011;})
		`uvm_do_with(req, { req.cmd == CMD_XORI; req.rd == 10; req.rs1 == 1; req.imm == 'b111111111111;})
		`uvm_do_with(req, { req.cmd == CMD_XORI; req.rd == 11; req.rs1 == 2; req.imm == 'b111111111111;})
		`uvm_do_with(req, { req.cmd == CMD_XORI; req.rd == 12; req.rs1 == 3; req.imm == 'b111111111111;})
		`uvm_do_with(req, { req.cmd == CMD_XORI; req.rd == 13; req.rs1 == 4; req.imm == 'b111111111111;})
		`uvm_do_with(req, { req.cmd == CMD_XORI; req.rd == 20; req.rs1 == 1; req.imm == 'b010101010101;})
		`uvm_do_with(req, { req.cmd == CMD_XORI; req.rd == 21; req.rs1 == 2; req.imm == 'b000000000000;})
		`uvm_do_with(req, { req.cmd == CMD_XORI; req.rd == 22; req.rs1 == 3; req.imm == 'b101010101010;})
		`uvm_do_with(req, { req.cmd == CMD_XORI; req.rd == 23; req.rs1 == 4; req.imm == 'b001100110011;})
		`uvm_do_with(req, { req.cmd == CMD_ORI; req.rd == 10; req.rs1 == 1; req.imm == 'b111111111111;})
		`uvm_do_with(req, { req.cmd == CMD_ORI; req.rd == 11; req.rs1 == 2; req.imm == 'b111111111111;})
		`uvm_do_with(req, { req.cmd == CMD_ORI; req.rd == 12; req.rs1 == 3; req.imm == 'b111111111111;})
		`uvm_do_with(req, { req.cmd == CMD_ORI; req.rd == 13; req.rs1 == 4; req.imm == 'b111111111111;})
		`uvm_do_with(req, { req.cmd == CMD_ORI; req.rd == 20; req.rs1 == 1; req.imm == 'b010101010101;})
		`uvm_do_with(req, { req.cmd == CMD_ORI; req.rd == 21; req.rs1 == 2; req.imm == 'b000000000000;})
		`uvm_do_with(req, { req.cmd == CMD_ORI; req.rd == 22; req.rs1 == 3; req.imm == 'b101010101010;})
		`uvm_do_with(req, { req.cmd == CMD_ORI; req.rd == 23; req.rs1 == 4; req.imm == 'b001100110011;})

		`uvm_do_with(req, { req.cmd == CMD_RESET; })
		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 1; req.rs1 == 0; req.imm == 10;})
		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 2; req.rs1 == 0; req.imm == 'b111111110110;})  // -10
		`uvm_do_with(req, { req.cmd == CMD_ADD; req.rd == 3; req.rs1 == 1; req.rs2 == 1;})
		`uvm_do_with(req, { req.cmd == CMD_ADD; req.rd == 4; req.rs1 == 2; req.rs2 == 2;})

		repeat(10)
		begin
			`uvm_do_with(req, { req.cmd == CMD_ADD;})
		end

		`uvm_do_with(req, { req.cmd == CMD_RESET; })
		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 1; req.rs1 == 0; req.imm == 10;})
		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 2; req.rs1 == 0; req.imm == 'b111111110110;})  // -10
		`uvm_do_with(req, { req.cmd == CMD_SUB; req.rd == 3; req.rs1 == 1; req.rs2 == 1;})
		`uvm_do_with(req, { req.cmd == CMD_SUB; req.rd == 4; req.rs1 == 1; req.rs2 == 3;})
		`uvm_do_with(req, { req.cmd == CMD_SUB; req.rd == 4; req.rs1 == 1; req.rs2 == 2;})

		repeat(100)
		begin
			`uvm_do_with(req, { req.cmd == CMD_SUB;})
		end

		repeat(10)
		begin
			`uvm_do_with(req, { req.cmd == CMD_SLT;})
		end
		repeat(10)
		begin
			`uvm_do_with(req, { req.cmd == CMD_SLTU;})
		end


		`uvm_do_with(req, { req.cmd == CMD_RESET; })
		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 1; req.rs1 == 0; req.imm == 10;})
		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 2; req.rs1 == 0; req.imm == 1;})
		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 3; req.rs1 == 0; req.imm == 30;})
		`uvm_do_with(req, { req.cmd == CMD_SLL; req.rd == 10; req.rs1 == 1; req.rs2 == 2;})
		`uvm_do_with(req, { req.cmd == CMD_SLL; req.rd == 11; req.rs1 == 10; req.rs2 == 3;})

		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 1; req.rs1 == 0; req.imm == 10;})
		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 2; req.rs1 == 0; req.imm == 1;})
		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 3; req.rs1 == 0; req.imm == 20;})
		`uvm_do_with(req, { req.cmd == CMD_SRL; req.rd == 10; req.rs1 == 1; req.rs2 == 2;})
		`uvm_do_with(req, { req.cmd == CMD_SLL; req.rd == 11; req.rs1 == 10; req.rs2 == 3;})
		`uvm_do_with(req, { req.cmd == CMD_SRL; req.rd == 12; req.rs1 == 11; req.rs2 == 1;})
		`uvm_do_with(req, { req.cmd == CMD_SRL; req.rd == 13; req.rs1 == 12; req.rs2 == 3;})


		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 1; req.rs1 == 0; req.imm == 'b111111110110;})  // -10
		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 2; req.rs1 == 0; req.imm == 1;})
		`uvm_do_with(req, { req.cmd == CMD_SLL; req.rd == 3; req.rs1 == 1; req.rs2 == 2;})
		`uvm_do_with(req, { req.cmd == CMD_SRA; req.rd == 4; req.rs1 == 3; req.rs2 == 2;})

		`uvm_do_with(req, { req.cmd == CMD_RESET; })
		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 1; req.rs1 == 0; req.imm == 10;})
		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 2; req.rs1 == 0; req.imm == 1;})
		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 3; req.rs1 == 0; req.imm == 30;})
		`uvm_do_with(req, { req.cmd == CMD_SLLI; req.rd == 10; req.rs1 == 1; req.shamt == 2;})
		`uvm_do_with(req, { req.cmd == CMD_SLLI; req.rd == 11; req.rs1 == 10; req.shamt == 3;})

		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 1; req.rs1 == 0; req.imm == 10;})
		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 2; req.rs1 == 0; req.imm == 1;})
		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 3; req.rs1 == 0; req.imm == 20;})
		`uvm_do_with(req, { req.cmd == CMD_SRLI; req.rd == 10; req.rs1 == 1; req.shamt == 2;})
		`uvm_do_with(req, { req.cmd == CMD_SLLI; req.rd == 11; req.rs1 == 10; req.shamt == 3;})
		`uvm_do_with(req, { req.cmd == CMD_SRLI; req.rd == 12; req.rs1 == 11; req.shamt == 1;})
		`uvm_do_with(req, { req.cmd == CMD_SRLI; req.rd == 13; req.rs1 == 12; req.shamt == 3;})


		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 1; req.rs1 == 0; req.imm == 'b111111110110;})  // -10
		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 2; req.rs1 == 0; req.imm == 1;})
		`uvm_do_with(req, { req.cmd == CMD_SLLI; req.rd == 3; req.rs1 == 1; req.shamt == 2;})
		`uvm_do_with(req, { req.cmd == CMD_SRAI; req.rd == 4; req.rs1 == 3; req.shamt == 2;})
	endtask

	task body;
		`uvm_info(get_type_name(), "Sequence start", UVM_MEDIUM)
		// Perform an initial RESET to clean up the cpu state
		`uvm_do_with(req, { req.cmd == CMD_RESET; })

//		do_alu_items();

		// `uvm_do_with(req, { req.cmd == CMD_JAL; req.jump_offset == 256;})
		// `uvm_do_with(req, { req.cmd == CMD_JAL; req.jump_offset == 256;})
		// `uvm_do_with(req, { req.cmd == CMD_JAL; req.jump_offset == 256;})

		// repeat(1000)
		// begin
		// 		`uvm_do_with(req, { req.cmd != CMD_RESET;})
		// end

		#400;  // Wait 400 clock cycles to let the program run


		//////////////////////////////////////////////////
		// Epilogue to drain all the `previous intructions
		//////////////////////////////////////////////////
		// repeat(10)
		// begin
		// 	`uvm_do_with(req, { req.cmd == CMD_ADDI; req.rd == 0; req.rs1 == 0; req.imm == 0;})
		// end

	endtask: body

endclass: exec_core_sequence

`endif
