`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: SDU
// Engineer: GYC
// 
// Create Date: 2018/09/13 15:02:59
// Design Name: VGA's interface
// Module Name: VGA
// Project Name: VGA
// Target Devices: 
// Tool Versions: 
// Description: 
// 晶振：50MHz
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module VGA
(
    input wire clk,
    input wire rst,
	input wire en,
	
	output wire pll_clk,
    output reg VSync,
    output reg HSync,
	output reg h_addr,
	output reg v_addr
);
	
	parameter h_front_porch  = 10'd8;//0.318*25
	parameter h_sync_time    = 10'd95;//3.813*25
	parameter h_back_porch   = 10'd40;//1.598*25
	parameter h_left_border  = 10'd8;
	parameter h_addr_time    = 10'd636;//25.422*25
	parameter h_right_border = 10'd8;
	parameter h_blank_time   = h_front_porch + h_sync_time + h_back_porch;
	parameter h_active_time  = h_left_border + h_addr_time + h_right_border;
	
	parameter v_front_porch   = 19'd1600;//0.064*25000
	parameter v_sync_time     = 19'd1600;
	parameter v_back_porch    = 19'd19850;//0.794*25000
	parameter v_top_border    = 19'd6350;//0.254*25000
	parameter v_addr_time     = 19'd381325;//15.253*25000
	parameter v_bottom_border = 19'd6350;
	parameter v_blank_time   = v_front_porch + v_sync_time + v_back_porch;
	parameter v_active_time  = v_top_border + v_addr_time + v_bottom_border;
	
	
	
	reg cnt_clk;
	
	reg[9:0] cnt_h;
	reg[18:0] cnt_v;
	
	always@(posedge clk or negedge rst)//output 25MHz
	begin
		if(~rst)
			cnt_clk <= 1'b0;
		else
		begin
			if(cnt_clk == 1'b1)
				cnt_clk <= 1'b0;
			else
				cnt_clk <= 1'b1;
		end
	end
	
	assign pll_clk = cnt_clk;
	
	always@(posedge cnt_clk or negedge rst)//horizontal count
	begin
		if(~rst)
		begin
			cnt_h  <= 10'b0;
			HSync <= 1'b0;
			h_addr <= 1'b0;
		end
		else
		begin
			if(en)
			begin
				case(1'b1)
					cnt_h < h_front_porch:
					begin
						HSync <= 1'b0;
						cnt_h <= cnt_h + 10'b1;
						h_addr <= 1'b0;
					end
					cnt_h >= h_front_porch && cnt_h < h_front_porch + h_sync_time:
					begin
						HSync <= 1'b1;
						cnt_h <= cnt_h + 10'b1;
						h_addr <= 1'b0;
					end
					cnt_h >= h_front_porch + h_sync_time && cnt_h < h_blank_time:
					begin
						HSync <= 1'b0;
						cnt_h <= cnt_h + 10'b1;
						h_addr <= 1'b0;
					end
					cnt_h >= h_blank_time && cnt_h < h_blank_time + h_left_border:
					begin
						HSync <= 1'b0;
						cnt_h <= cnt_h + 10'b1;
						h_addr <= 1'b0;
					end
					cnt_h >= h_blank_time + h_left_border && cnt_h < h_blank_time + h_left_border + h_addr_time:
					begin
						HSync <= 1'b0;
						cnt_h <= cnt_h + 10'b1;
						h_addr <= 1'b1;
					end
					cnt_h >= h_blank_time + h_left_border + h_addr_time && cnt_h < h_blank_time + h_active_time - 10'b1:
					begin
						HSync <= 1'b0;
						cnt_h <= cnt_h + 10'b1;
						h_addr <= 1'b0;
					end
					default:
					begin
						HSync <= 1'b0;
						cnt_h  <= 10'b0;
						h_addr <= 1'b0;
					end
				endcase
			end
			else//if not ,clear the register
			begin
				cnt_h  <= 10'b0;
				HSync <= 1'b0;
				h_addr <= 1'b0;
			end
		end
	end
	
	always@(posedge cnt_clk or negedge rst)
	begin
		if(~rst)
		begin
			VSync  <= 1'b0;
			cnt_v  <= 19'b0;
			v_addr <= 1'b0;
		end
		else
		begin
			if(en)
			begin
				case(1'b1)
					cnt_v < v_front_porch:
					begin
						VSync  <= 1'b0;
						cnt_v  <= cnt_v + 19'b1;
						v_addr <= 1'b0;
					end
					cnt_v >= v_front_porch && cnt_v < v_front_porch + v_sync_time:
					begin
						VSync  <= 1'b1;
						cnt_v  <= cnt_v + 19'b1;
						v_addr <= 1'b0;
					end
					cnt_v >= v_front_porch + v_sync_time && cnt_v < v_blank_time:
					begin
						VSync  <= 1'b0;
						cnt_v  <= cnt_v + 19'b1;
						v_addr <= 1'b0;
					end
					cnt_v >= v_blank_time && cnt_v < v_blank_time + v_top_border:
					begin
						VSync  <= 1'b0;
						cnt_v  <= cnt_v + 19'b1;
						v_addr <= 1'b0;
					end
					cnt_v >= v_blank_time + v_top_border && cnt_v < v_blank_time + v_top_border + v_addr_time:
					begin
						VSync  <= 1'b0;
						cnt_v  <= cnt_v + 19'b1;
						v_addr <= 1'b1;
					end
					cnt_v >= v_blank_time + v_top_border + v_addr_time && cnt_v < v_blank_time + v_active_time - 19'b1:
					begin
						VSync  <= 1'b0;
						cnt_v  <= cnt_v + 19'b1;
						v_addr <= 1'b0;
					end
					default:
					begin
						VSync  <= 1'b0;
						cnt_v  <= 19'b0;
						v_addr <= 1'b0;
					end
				endcase
			end
			else
			begin
				VSync  <= 1'b0;
				cnt_v  <= 19'b0;
				v_addr <= 1'b0;
			end
		end
	end
endmodule










