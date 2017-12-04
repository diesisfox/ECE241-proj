module hsvrgbTest (
	input [9:0]SW,
	input CLOCK_50,
	output [6:0]HEX0,HEX1,HEX2,HEX3,HEX4,HEX5
	);
	wire [7:0] r,g,b;
	wire [31:0] hF,sF,vF;
	wire CLOCK_100;
	PLL100M pll100M_0(CLOCK_50, 1'b0, CLOCK_100);
	HSV2RGB lol(CLOCK_100,hF, sF, vF, r, g, b);

	FPconv_Q2_8_to_F32 lol1(CLOCK_100,{2'b0,SW[8:6],5'b0},hF);
	FPconv_Q2_8_to_F32 lol2(CLOCK_100,{2'b0,SW[5:3],5'b0},sF);
	FPconv_Q2_8_to_F32 lol3(CLOCK_100,{2'b0,SW[2:0],5'b0},vF);

	hex_decoder lol11(r[7:4],HEX5);
	hex_decoder lol12(r[3:0],HEX4);
	hex_decoder lol21(g[7:4],HEX3);
	hex_decoder lol22(g[3:0],HEX2);
	hex_decoder lol31(b[7:4],HEX1);
	hex_decoder lol32(b[3:0],HEX0);
endmodule // hsvrgbTest
