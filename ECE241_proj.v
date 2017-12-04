// top level module for the ECE241 project

module ECE241_proj (CLOCK_50, PS2_CLK, PS2_DAT, SW, LEDR, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5);

	input [9:0] SW;
	output [9:0] LEDR;
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	input CLOCK_50;
	inout PS2_CLK, PS2_DAT;
	reg [7:0] data;
	wire [7:0] r,g,b;
	wire [1:0] animSel;
	wire CLOCK_10;
	wire [127:0] parser_output, e0_parser_output;
	wire [3:0] currentState;
	
	
	Keyboard_Parser kp0 (.clk(CLOCK_10),.reset(SW[9]),.ps2_clk(PS2_CLK),.ps2_data(PS2_DAT),.key_data(parser_output),.E0_key_data(e0_parser_output));
	RGB_Controller rgbc0 (
		.clk(CLOCK_10),
		.reset(SW[9]),
		.keys(parser_output),
		.e_keys(e0_parser_output),
		.r(r),
		.g(g),
		.b(b),
		.animSel(animSel),
		.hex0(HEX0),
		.hex1(HEX1),
		.hex2(HEX2),
		.hex3(HEX3),
		.hex4(HEX4),
		.hex5(HEX5)
	);
	PLL10M PL10 (CLOCK_50, 0, CLOCK_10);
	
	assign LEDR[0] = animSel[0];
	assign LEDR[1] = animSel[1];
	
endmodule
