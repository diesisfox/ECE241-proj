// top level module for the ECE241 project

module ECE241_proj (CLOCK_50, PS2_CLK, PS2_DAT, SW, LEDR);

	input [9:0] SW;
	output [9:0] LEDR;
	input CLOCK_50;
	inout PS2_CLK, PS2_DAT;
	reg [7:0] data;
	wire CLOCK_10;
	wire [127:0] parser_output, e0_parser_output;
	
	Keyboard_Parser kp0 (.clk(CLOCK_10),.reset(SW[9]),.ps2_clk(PS2_CLK),.ps2_data(PS2_DAT),.key_data(parser_output),.E0_key_data(e0_parser_output));
	PLL10M PL10 (CLOCK_50, 0, CLOCK_10);
	
	assign LEDR[0] = e0_parser_output[112];
	assign LEDR[1] = parser_output[28];
	
endmodule
