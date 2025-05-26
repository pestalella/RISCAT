`timescale 1ns / 1ns

	typedef enum {READ, WRITE} mem_cmd;

	class mem_transaction extends uvm_sequence_item;

		rand mem_cmd cmd;
		rand bit [3:0] addr;
		rand bit [7:0] data;

		function new (string name = "");
			super.new(name);
		endfunction

		`uvm_object_utils_begin(mem_transaction)
			`uvm_field_enum(mem_cmd, cmd, UVM_DEFAULT)
			`uvm_field_int(addr, UVM_DEFAULT)
			`uvm_field_int(data, UVM_DEFAULT)
		`uvm_object_utils_end

	endclass: mem_transaction
