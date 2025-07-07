`ifndef __WRITEBACK_STAGE_SV__
`define __WRITEBACK_STAGE_SV__

module writeback_unit(
	input logic clk,
	input logic reset_n,

	input bit result_ready,
	input logic [31:0] alu_result,
	input logic [4:0] wr_addr,

	output logic rd_wr_en,
	output logic [4:0] reg_wr_addr,
	output logic [31:0] reg_wr_data
);

	always_ff @(posedge clk or negedge reset_n) begin
		if (~reset_n) begin
			rd_wr_en <= 0;
			reg_wr_addr <= '{default:0};
			reg_wr_data <= '{default:0};
		end else begin
			if (result_ready) begin
				rd_wr_en <= 1;
				reg_wr_addr <= wr_addr;
				reg_wr_data <= alu_result;
			end else begin
				rd_wr_en <= 0;
				reg_wr_addr <= '{default:0};
				reg_wr_data <= '{default:0};
			end
		end
	end

endmodule

`endif
