`ifndef __EXEC_CORE_SEQUENCE_SV__
`define __EXEC_CORE_SEQUENCE_SV__

class exec_core_sequence extends uvm_sequence #(exec_core_transaction);

	`uvm_object_utils(exec_core_sequence)

	function new (string name = "");
		super.new(name);
	endfunction

	task body;

		`uvm_info(get_type_name(), "Sequence start", UVM_MEDIUM)
		// Perform an initial RESET to clean up the cpu state
		`uvm_do_with(req, { req.cmd == CMD_RESET; })

		repeat(10000)
		begin
				`uvm_do_with(req, { req.cmd == CMD_ADDI; src == 0;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 0; dst == 2; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 2; dst == 3; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 3; dst == 4; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 4; dst == 5; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 5; dst == 6; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 6; dst == 7; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 7; dst == 8; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 8; dst == 9; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 9; dst == 10; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 10; dst == 11; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 11; dst == 12; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 12; dst == 13; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 13; dst == 14; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 14; dst == 15; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 15; dst == 16; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 16; dst == 17; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 17; dst == 18; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 18; dst == 19; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 19; dst == 20; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 20; dst == 21; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 21; dst == 22; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 22; dst == 23; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 23; dst == 24; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 24; dst == 25; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 25; dst == 26; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 26; dst == 27; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 27; dst == 28; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 28; dst == 29; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 29; dst == 30; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 30; dst == 31; imm < 10;})
			// `uvm_do_with(req, { req.cmd == CMD_ADDI; src == 31; dst == 1; imm < 10;})
		end
	endtask: body

endclass: exec_core_sequence

`endif
