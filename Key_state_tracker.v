module key_state_tracker (
	input clk, key_pressed, key_released,
	input [7:0] keyCode
	);
	//declare arrays
	reg [7:0][6:0] keysOn; //{1'active, 6'code}
	reg [7:0][15:0] freqs;
	//next available slot logic
	wire [3:0] nextEmptyIndex; //{1'error, 3'ind}
	min8_uint4 m0(
		keysOn[0][6]?4'hf:4'h0,
		keysOn[1][6]?4'hf:4'h1,
		keysOn[2][6]?4'hf:4'h2,
		keysOn[3][6]?4'hf:4'h3,
		keysOn[4][6]?4'hf:4'h4,
		keysOn[5][6]?4'hf:4'h5,
		keysOn[6][6]?4'hf:4'h6,
		keysOn[7][6]?4'hf:4'h7,
		nextEmptyIndex[3:0]
		);

endmodule // key_state_tracker

module min8_uint4 (
	input [3:0] x0,x1,x2,x3,x4,x5,x6,x7,
	output [3:0] min
	);
	wire [5:0][3:0] stage;
	assign min = (stage[0]<stage[1])?stage[0]:stage[1];

	assign stage[0] = (stage[2]<stage[3])?stage[2]:stage[3];
	assign stage[1] = (stage[4]<stage[5])?stage[4]:stage[5];

	assign stage[2] = (x0<x1)?x0:x1;
	assign stage[3] = (x2<x3)?x2:x3;
	assign stage[4] = (x4<x5)?x4:x5;
	assign stage[5] = (x6<x7)?x6:x7;
endmodule // min8_uint8
