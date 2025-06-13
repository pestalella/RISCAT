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

		repeat(10)
		begin
				`uvm_do_with(req, { req.cmd == CMD_ADDI;})
		end
		repeat(1)
		begin
				`uvm_do_with(req, { req.cmd == CMD_ADDI; req.dst == 1; req.src == 0; req.imm == 10;})
				`uvm_do_with(req, { req.cmd == CMD_SLTI; req.dst == 31; req.src == 1; req.imm == 11;})  // r31 = 1
				`uvm_do_with(req, { req.cmd == CMD_SLTI; req.dst == 30; req.src == 1; req.imm == 9;})  // r30 = 0
				`uvm_do_with(req, { req.cmd == CMD_ADDI; req.dst == 2; req.src == 0; req.imm == 12'b111111111111;})
				`uvm_do_with(req, { req.cmd == CMD_SLTI; req.dst == 29; req.src == 2; req.imm == 0;})  // r29 = 1
		end

		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.dst == 0; req.src == 0; req.imm == 0;})
		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.dst == 0; req.src == 0; req.imm == 0;})
		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.dst == 0; req.src == 0; req.imm == 0;})
		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.dst == 0; req.src == 0; req.imm == 0;})
		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.dst == 0; req.src == 0; req.imm == 0;})
		`uvm_do_with(req, { req.cmd == CMD_ADDI; req.dst == 0; req.src == 0; req.imm == 0;})

	endtask: body

endclass: exec_core_sequence

`endif
