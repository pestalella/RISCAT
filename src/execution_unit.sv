
`include "alu_enums.svh"
`include "register32bit_file.sv"
`include "fetch_unit.sv"
`include "decode_unit.sv"
`include "alu.sv"
`include "pipeline_stage_registers.sv"

interface exec_unit_if(
	input logic clk,
	output logic reset_n
);

	wire rd_ram_en;
	logic [31:0] rd_ram_addr;
	logic [31:0] rd_ram_data;
	wire wr_ram_en;
	logic [31:0] wr_ram_addr;
	logic [31:0] wr_ram_data;

endinterface

module exec_unit (
		exec_unit_if exec_if
);

  logic [31:0] pc;

	wire [31:0] regfile_rd0_data;
	wire [31:0] regfile_rd1_data;
  wire [31:0] reg_wr_data;

  logic [31:0] alu_result;
 logic [31:0] reg_store_wr_data;

	// always read a new instruction
	assign exec_if.rd_ram_en = 1;

	regfile_if regfile_interface();
	logic alu_result_ready;

	register32bit_file registers(
		.reg_if(regfile_interface)
	);

	// Update program counter
	always @(posedge exec_if.clk) begin
			if (!exec_if.reset_n) begin
					pc  <= 0;
			end else begin
					pc  <= pc + 4;
			end
	end

	// Clear internal data on reset
  always @(posedge exec_if.clk) begin
    if (!exec_if.reset_n) begin
		end
	end

	logic fetch_started;
	logic fetch_completed;
	wire [31:0] fetched_inst;

	IF_ID if_id_reg;
	ID_EX id_ex_reg;

	fetch_stage instruction_fetch(
		.clk(exec_if.clk),
		.reset_n(exec_if.reset_n),
		.pc(pc),
		.rd_ram_addr(exec_if.rd_ram_addr),
		.rd_ram_data(exec_if.rd_ram_data),
		.if_id_reg(if_id_reg)
	);

	decode_unit instruction_decode(
		.clk(exec_if.clk),
		.reset_n(exec_if.reset_n),
		.if_id_reg(if_id_reg),
		.id_ex_reg(id_ex_reg)
	);

	assign regfile_interface.clk 			= exec_if.clk;
	assign regfile_interface.reset_n 	= exec_if.reset_n;
	assign regfile_interface.rd0_en 	= id_ex_reg.reg_rd0_en;
	assign regfile_interface.rd0_addr = id_ex_reg.reg_rd0_addr;
	assign regfile_interface.rd1_en 	= id_ex_reg.reg_rd1_en;
	assign regfile_interface.rd1_addr = id_ex_reg.reg_rd1_addr;
	assign regfile_interface.wr_en 		= id_ex_reg.reg_wr_en & alu_result_ready;
	assign regfile_interface.wr_addr 	= id_ex_reg.reg_wr_addr;
	assign regfile_rd0_data 					= regfile_interface.rd0_data;
	assign regfile_rd1_data 					= regfile_interface.rd1_data;
	assign regfile_interface.wr_data 	= reg_store_wr_data;


	alu_stage arithmetic_logic_unit(
		.clk(exec_if.clk),
		.reset_n(reset_n),
		.id_ex_reg(id_ex_reg),
		.regfile_rd0_data(regfile_rd0_data),
		.regfile_rd1_data(regfile_rd1_data),
		.result_ready(alu_result_ready),
		.alu_result(alu_result)
	);
	assign reg_store_wr_data = alu_result;

endmodule


module register_store(
	input logic result_ready,
	input logic [31:0] alu_result,
	input logic decode_reg_wr_en,
	input logic [4:0] decode_reg_wr_addr,

	output logic [4:0] reg_wr_addr,
	output logic [31:0] reg_wr_data,
	output logic reg_wr_en
);

always @(result_ready) begin
	reg_wr_addr <= decode_reg_wr_addr;
	reg_wr_data <= alu_result;
	reg_wr_en <=  decode_reg_wr_en;
end

endmodule

