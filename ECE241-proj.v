// top level module for the ECE241 project

module ECE241_proj (CLOCK_50, HEX0, HEX1, PS2_CLK, PS2_DATA, SW);

	input [9:0] SW;
	output [6:0] HEX0, HEX1;
	input PS2_CLK, PS2_DATA, CLOCK_50;
	
	wire rde;
	wire [7:0] ps2Word;
	PS2_Controller pc0 (.CLOCK_50(CLOCK_50),.reset(SW[9]),.PS2_CLK(PS2_CLK),.PS2_DAT(PS2_DATA),.received_data(ps2Word),.received_data_en(rde));
	hex_decoder h0 (.in (ps2Word[3:0]),.out(HEX0));
	hex_decoder h1 (.in (ps2Word[7:4]),.out(HEX1));

endmodule
