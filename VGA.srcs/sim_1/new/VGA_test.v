`timescale 10ns / 1ns

module VGA_test;

	reg clk;
	reg rst;
	reg en;
	
	wire pll_clk;
	wire VSync;
	wire HSync;
	wire h_addr;
	wire v_addr;
	
	VGA U1
(
    .clk(clk),
    .rst(rst),
	.en(en),
	
	.pll_clk(pll_clk),
    .VSync(VSync),
    .HSync(HSync),
	.h_addr(h_addr),
	.v_addr(v_addr)
);
	
	always
	begin
		clk = 1'b0;
		#1;
		clk = 1'b1;
		#1;
	end
	
	initial
	begin
		rst = 1'b0;
		en  = 1'b0;
		#5;
		rst = 1'b1;
		#3;
		en  = 1'b1;
	end
	
	initial
	begin
		$monitor($time,"pll_clk = %b,VSync = %b,HSync = %b,h_addr = %b,v_addr = %b",
		pll_clk,VSync,HSync,h_addr,v_addr);
	end
	
endmodule






