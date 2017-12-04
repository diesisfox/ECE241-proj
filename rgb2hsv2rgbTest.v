module rgb2hsv2rgbTest ( //because why not
	input [9:0]SW,
	input CLOCK_50,
	output [6:0]HEX0,HEX1,HEX2,HEX3,HEX4,HEX5
	);
	wire [9:0] rQ,gQ,bQ;
	wire [31:0] hF,sF,vF;
	wire CLOCK_100;
	PLL100M pll100M_0(CLOCK_50, 1'b0, CLOCK_100);
	HSV2RGB lol(CLOCK_100, hF, sF, vF, rQ, gQ, bQ);
	RGB2HSV lol0(CLOCK_100,{2'b0,SW[8:6],5'b0}, {2'b0,SW[5:3],5'b0}, {2'b0,SW[2:0],5'b0}, hF, sF, vF);

	hex_decoder lol11(rQ[7:4],HEX5);
	hex_decoder lol12(rQ[3:0],HEX4);
	hex_decoder lol21(gQ[7:4],HEX3);
	hex_decoder lol22(gQ[3:0],HEX2);
	hex_decoder lol31(bQ[7:4],HEX1);
	hex_decoder lol32(bQ[3:0],HEX0);
endmodule // rgb2hsv2rgbTest
