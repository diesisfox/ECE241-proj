// top level module for the ECE241 project

module ECE241_proj (CLOCK_50, HEX0, HEX1, PS2_CLK, PS2_DAT, SW, LEDR, GPIO_0);

	input [9:0] SW;
	output [9:0] LEDR;
	output [6:0] HEX0, HEX1;
	input CLOCK_50;
	inout PS2_CLK, PS2_DAT;
	wire tmp, tmp2;
	output [10:0] GPIO_0;
	wire [7:0] ps2Word;
	reg [7:0] data;
	
	assign GPIO_0[0] = ps2Word[0];
	assign GPIO_0[1] = ps2Word[1];
	assign GPIO_0[2] = ps2Word[2];
	assign GPIO_0[3] = ps2Word[3];
	assign GPIO_0[4] = ps2Word[4];
	assign GPIO_0[5] = ps2Word[5];
	assign GPIO_0[6] = ps2Word[6];
	assign GPIO_0[7] = tmp;
	assign GPIO_0[8] = tmp2;
	assign GPIO_0[9] = tmp;
	assign GPIO_0[10] = tmp2;
	
	Keyboard_Parser kp0 (.clk(CLOCK_50),.reset(SW[9]),.ps2_clk(PS2_CLK),.ps2_data(PS2_DAT),.data(ps2Word),.key_pressed(tmp),.key_released(tmp2));
	//always @(posedge CLOCK_50) begin
		//if (tmp == 1'b1)
			//data <= ps2Word;
	//end
	
	hex_decoder h0 (.in(ps2Word[3:0]),.out(HEX0));
	hex_decoder h1 (.in(ps2Word[7:4]),.out(HEX1));
	
endmodule
