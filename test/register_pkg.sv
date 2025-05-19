`include "uvm_macros.svh"

`timescale 1ns/1ns

package register_pkg;

	import uvm_pkg::*;

	`include "registerfile_transaction.sv"
	typedef uvm_sequencer #(registerfile_transaction) registerfile_sequencer;
	`include "registerfile_driver.sv"
	`include "registerfile_monitor.sv"
	`include "registerfile_agent.sv"
	`include "registerfile_sequence.sv"
	`include "registerfile_scoreboard.sv"
	`include "registerfile_env.sv"
	`include "registerfile_test.sv"

endpackage: register_pkg
