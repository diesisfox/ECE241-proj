module rgbhsvTest (
	input [9:0]SW,
	input CLOCK_50,
	output [6:0]HEX0,HEX1,HEX2,HEX3,HEX4,HEX5
	);

	wire [31:0] h,s,v;
	wire [9:0] hq,sq,vq;
	wire CLOCK_100;
	PLL100M pll100M_0(CLOCK_50, 1'b0, CLOCK_100);
	RGB2HSV lol(CLOCK_100,{2'b0,SW[8:6],5'b0}, {2'b0,SW[5:3],5'b0}, {2'b0,SW[2:0],5'b0},h, s, v);

	FPconv_F32_to_Q2_8 lol1(CLOCK_100,h,hq);
	FPconv_F32_to_Q2_8 lol2(CLOCK_100,s,sq);
	FPconv_F32_to_Q2_8 lol3(CLOCK_100,v,vq);

	hex_decoder lol11(hq[7:4],HEX5);
	hex_decoder lol12(hq[3:0],HEX4);
	hex_decoder lol21(sq[7:4],HEX3);
	hex_decoder lol22(sq[3:0],HEX2);
	hex_decoder lol31(vq[7:4],HEX1);
	hex_decoder lol32(vq[3:0],HEX0);
endmodule // rgbhsvTest
