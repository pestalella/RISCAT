`include "uvm_macros.svh"

`timescale 1ns/1ns

package mem_pkg;

  import uvm_pkg::*;

	`include "mem_transaction.sv"
	typedef uvm_sequencer #(mem_transaction) mem_sequencer;
	`include "mem_driver.sv"
	`include "mem_monitor.sv"
	`include "mem_agent.sv"
	`include "mem_sequence.sv"
	`include "mem_scoreboard.sv"
	`include "mem_env.sv"
  `include "mem_test.sv"

endpackage: mem_pkg
