`timescale 1ns / 1ns

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
	logic [4:0] reg_rd0_addr;
	logic [4:0] reg_rd1_addr;
	logic [4:0] reg_wr_addr;
	logic reg_rd0_en;
	logic reg_rd1_en;
	logic reg_wr_en;

	logic rd_mem_en;

	assign exec_if.rd_ram_en = rd_mem_en;

	regfile_if regfile_interface();

	assign regfile_interface.clk = exec_if.clk;
	assign regfile_interface.reset_n = exec_if.reset_n;
	assign regfile_interface.rd0_en = reg_rd0_en;
	assign regfile_interface.rd0_addr = reg_rd0_addr;
	assign regfile_interface.rd0_data = regfile_rd0_data;
	assign regfile_interface.rd1_en = reg_rd1_en;
	assign regfile_interface.rd1_addr = reg_rd1_addr;
	assign regfile_interface.rd1_data = regfile_rd1_data;
	assign regfile_interface.wr_en = reg_wr_en;
	assign regfile_interface.wr_addr = reg_wr_addr;
	assign regfile_interface.wr_data = reg_wr_data;

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
			reg_rd0_addr <= '0;
			reg_rd1_addr <= '0;
			reg_wr_addr <= '0;
			reg_rd0_en <= '0;
			reg_rd1_en <= '0;
			reg_wr_en <= '0;
		end
	end

	logic fetch_en;
	logic fetch_started;
	logic fetch_completed;
	wire [31:0] fetched_inst;

	initial begin
		fetch_en <= 1;
		rd_mem_en <= 0;
	end

	fetch_stage0 fetch0(
		.clk(exec_if.clk),
		.reset_n(exec_if.reset_n),
		.fetch_en(fetch_en),
		.fetch_started(fetch_started),
		.pc(pc),
		.rd_ram_en(rd_mem_en),
		.rd_ram_addr(exec_if.rd_ram_addr)
	);

	fetch_stage1 fetch1(
		.clk(exec_if.clk),
		.reset_n(exec_if.reset_n),
		.fetch_en(fetch_en),
		.fetch_started(fetch_started),
		.fetch_completed(fetch_completed),
		.rd_ram_data(exec_if.rd_ram_data),
		.fetched_inst(fetched_inst)
	);

	decode_stage decode(
		.clk(exec_if.clk),
		.reset_n(exec_if.reset_n),
		.fetched_inst(fetched_inst)
	);


  always @(posedge exec_if.clk) begin

	end

endmodule


module fetch_stage0(
	input logic clk,
	input logic reset_n,
	input logic fetch_en,
	input logic [31:0] pc,

	output logic fetch_started,
	output logic rd_ram_en,
	output logic [31:0] rd_ram_addr
	);

	always @(posedge clk) begin
		if (!reset_n) begin
				rd_ram_en <= 0;
				fetch_started <= 0;
		end else begin
			if (fetch_en) begin
				rd_ram_addr <= pc;
				rd_ram_en <= 1;
				fetch_started <= 1;
			end else begin
				rd_ram_en <= 0;
				fetch_started <= 0;
			end
		end
	end

endmodule


module fetch_stage1(
	input logic clk,
	input logic reset_n,
	input logic fetch_started,
	input logic [31:0] rd_ram_data,

	output logic fetch_en,
	output logic fetch_completed,
	output logic [31:0] fetched_inst
	);

	logic [31:0] fetched_inst_r;
	assign fetched_inst = fetched_inst_r;

	always @(posedge clk) begin
		if (!reset_n) begin
				fetched_inst_r <= 0;
				fetch_completed <= 0;
		end else begin
			if (fetch_started) begin
				fetched_inst_r <= rd_ram_data;
				fetch_completed <= 1;
				fetch_en <= 0;
			end else begin
				fetch_completed <= 0;
			end
		end
	end

endmodule

module decode_stage(
	input logic clk,
	input logic reset_n,
	input	logic [31:0] fetched_inst
);

	bit is_reg_imm_inst;

	assign is_reg_imm_inst = fetched_inst[6:0] == 7'b0010011;

	always @(posedge clk) begin

	end
endmodule
