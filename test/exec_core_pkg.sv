`timescale 1ns / 1ps

`include "uvm_macros.svh"

package exec_core_pkg;

	import uvm_pkg::*;

	`include "exec_core_transaction.sv"
	typedef uvm_sequencer #(exec_core_transaction) exec_core_sequencer;
	`include "exec_core_driver.sv"
	`include "exec_core_monitor.sv"
	`include "exec_core_agent.sv"
	`include "exec_core_sequence.sv"
	`include "exec_core_scoreboard.sv"
	`include "exec_core_env.sv"
	`include "exec_core_tests.sv"

endpackage: exec_core_pkg
