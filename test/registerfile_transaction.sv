typedef enum {RESET, READA, READB, READAB, WRITE} regfile_cmd;

class registerfile_transaction extends uvm_sequence_item;


	rand regfile_cmd cmd;
	rand bit [4:0] rd0_addr;
	rand bit [31:0] rd0_data;
	rand bit [4:0] rd1_addr;
	rand bit [31:0] rd1_data;

	rand bit [4:0] wr_addr;
	rand bit [31:0] wr_data;

	function new (string name = "");
		super.new(name);
	endfunction

	`uvm_object_utils_begin(registerfile_transaction)
		`uvm_field_enum(regfile_cmd, cmd, UVM_DEFAULT)
		`uvm_field_int(rd0_addr, UVM_DEFAULT)
		`uvm_field_int(rd0_data, UVM_DEFAULT)
		`uvm_field_int(rd1_addr, UVM_DEFAULT)
		`uvm_field_int(rd1_data, UVM_DEFAULT)
		`uvm_field_int(wr_addr, UVM_DEFAULT)
		`uvm_field_int(wr_data, UVM_DEFAULT)
	`uvm_object_utils_end

endclass: registerfile_transaction
