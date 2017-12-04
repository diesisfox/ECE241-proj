module RGB_Controller (
	// Inputs
	clk,
	reset,
	keys,
	e_keys,
	
	// Outputs
	r,
	g,
	b,
	animSel,
	s_rgb_controller,
	seqEnter,
	hex0,
	hex1,
	hex2,
	hex3,
	hex4,
	hex5
);

// FSM States

localparam		STATE_0_IDLE = 4'h0,
				STATE_1_ENTER_R = 4'h1,
				STATE_2_WAIT = 4'h2,
				STATE_3_ENTER_G = 4'h3,
				STATE_4_WAIT = 4'h4,
				STATE_5_ENTER_B = 4'h5,
				STATE_6_SEL_ANIM = 4'h6,
				INPUT_STATE_0_IDLE = 4'h0,
				INPUT_STATE_1 = 4'h1,
				INPUT_STATE_2_WAIT = 4'h2,
				INPUT_STATE_3 = 4'h3,
				INPUT_STATE_4_WAIT = 4'h4;
input clk, reset;
input [127:0] keys, e_keys;
output reg [7:0] r, g, b;
output reg [1:0] animSel;
output reg [3:0] s_rgb_controller;
output [6:0] hex0, hex1, hex2, hex3, hex4, hex5;
reg [3:0] ns_rgb_controller, s_input, ns_input;
reg [7:0] input_value;
output reg seqEnter;
reg [5:0] hexOn;
reg [3:0] hex0in, hex1in, hex2in, hex3in, hex4in, hex5in;

onoff_hex_decoder h0 (.in(hex0in),.out(hex0),.on(hexOn[0]));
onoff_hex_decoder h1 (.in(hex1in),.out(hex1),.on(hexOn[1]));
onoff_hex_decoder h2 (.in(hex2in),.out(hex2),.on(hexOn[2]));
onoff_hex_decoder h3 (.in(hex3in),.out(hex3),.on(hexOn[3]));
onoff_hex_decoder h4 (.in(hex4in),.out(hex4),.on(hexOn[4]));
onoff_hex_decoder h5 (.in(hex5in),.out(hex5),.on(hexOn[5]));

// Top-level FSM

always @(posedge clk) begin
	if (reset == 1'b1)
		s_rgb_controller <= STATE_0_IDLE;
	else
		s_rgb_controller <= ns_rgb_controller;
end

// FSM for entering RGB values (3-digit decimal values)
always @(posedge clk) begin
	if (reset == 1'b1)
		s_input <= INPUT_STATE_0_IDLE;
	else
		s_input <= ns_input;
end

// state logic for top-level FSM
always @(*) begin
	// Default behaviour
	ns_rgb_controller = STATE_0_IDLE;
	case (s_rgb_controller)
		STATE_0_IDLE:
		begin
			if ((keys[22] == 1'b1) || (keys[30] == 1'b1) || (keys[38] == 1'b1))
				ns_rgb_controller = STATE_6_SEL_ANIM;
			else if (keys[21] == 1'b1)
				ns_rgb_controller = STATE_1_ENTER_R;
			else if (keys[29] == 1'b1)
				ns_rgb_controller = STATE_3_ENTER_G;
			else if (keys[36] == 1'b1)
				ns_rgb_controller = STATE_5_ENTER_B;
			else if (keys[45] == 1'b1)
				ns_rgb_controller = STATE_1_ENTER_R;
			else
				ns_rgb_controller = STATE_0_IDLE;
		end
		STATE_1_ENTER_R:
		begin
			if (keys[90] == 1'b1 && seqEnter == 1'b1)
				ns_rgb_controller = STATE_2_WAIT;
			else if (keys[90] == 1'b1 && seqEnter == 1'b0)
				ns_rgb_controller = STATE_0_IDLE;
			else
				ns_rgb_controller = STATE_1_ENTER_R;
		end
		STATE_2_WAIT:
		begin
			if (keys[90] == 1'b0)
				ns_rgb_controller = STATE_3_ENTER_G;
			else
				ns_rgb_controller = STATE_2_WAIT;
		end
		STATE_3_ENTER_G:
		begin
			if (keys[90] == 1'b1 && seqEnter == 1'b1)
				ns_rgb_controller = STATE_4_WAIT;
			else if (keys[90] == 1'b1 && seqEnter == 1'b0)
				ns_rgb_controller = STATE_0_IDLE;
			else
				ns_rgb_controller = STATE_3_ENTER_G;
		end
		STATE_4_WAIT:
		begin
			if (keys[90] == 1'b0)
				ns_rgb_controller = STATE_5_ENTER_B;
			else
				ns_rgb_controller = STATE_4_WAIT;
		end
		STATE_5_ENTER_B:
		begin
			if (keys[90] == 1'b1)
				ns_rgb_controller = STATE_0_IDLE;
			else
				ns_rgb_controller  = STATE_5_ENTER_B;
		end
		STATE_6_SEL_ANIM:
		begin
			ns_rgb_controller = STATE_0_IDLE;
		end
	endcase
end

// state logic for input FSM
always @(*) begin
	ns_input = INPUT_STATE_0_IDLE;
	case (s_input)
		INPUT_STATE_0_IDLE:
		begin
			if (s_rgb_controller == STATE_3_ENTER_G || s_rgb_controller == STATE_5_ENTER_B || s_rgb_controller == STATE_1_ENTER_R)
				ns_input = INPUT_STATE_1;
			else
				ns_input = INPUT_STATE_0_IDLE;
		end
		INPUT_STATE_1:
		begin
			if (keys[69] == 1'b1 || keys[22] == 1'b1 || keys[30] == 1'b1 || keys[38] == 1'b1 || keys[37] == 1'b1 || keys[46] == 1'b1 || keys[54] == 1'b1 || keys[61] == 1'b1 || keys[62] == 1'b1 || keys[70] == 1'b1 || keys[28] == 1'b1 || keys[50] == 1'b1 || keys[33] == 1'b1 || keys[35] == 1'b1 || keys[36] == 1'b1 || keys[43] == 1'b1)
				ns_input = INPUT_STATE_2_WAIT;
			else if (keys[90] == 1'b1)
				ns_input = INPUT_STATE_4_WAIT;
			else
				ns_input = INPUT_STATE_1;
		end
		INPUT_STATE_2_WAIT:
		begin
			if (keys[70:22] == 49'b0)
				ns_input = INPUT_STATE_3;
			else
				ns_input = INPUT_STATE_2_WAIT;
		end
		INPUT_STATE_3:
		begin
			if (keys[69] == 1'b1 || keys[22] == 1'b1 || keys[30] == 1'b1 || keys[38] == 1'b1 || keys[37] == 1'b1 || keys[46] == 1'b1 || keys[54] == 1'b1 || keys[61] == 1'b1 || keys[62] == 1'b1 || keys[70] == 1'b1 || keys[28] == 1'b1 || keys[50] == 1'b1 || keys[33] == 1'b1 || keys[35] == 1'b1 || keys[36] == 1'b1 || keys[43] == 1'b1)
				ns_input = INPUT_STATE_4_WAIT;
			else if (keys[102] == 1'b1)
				ns_input = INPUT_STATE_1;
			else
				ns_input = INPUT_STATE_3;
		end
		INPUT_STATE_4_WAIT:
		begin
			if (keys[70:22] == 49'b0 && keys[90] == 1'b1)
				ns_input = INPUT_STATE_0_IDLE;
			else if (keys[102] == 1'b1)
				ns_input = INPUT_STATE_1;
			else
				ns_input = INPUT_STATE_4_WAIT;
		end
	endcase
end

// Sequential logic for the control FSM

// always block for assigning values to animSel
always @(posedge clk) begin
	if (s_rgb_controller == STATE_6_SEL_ANIM) begin
		if (keys[22] == 1'b1)
			animSel <= 2'b01;
		else if (keys[30] == 1'b1)
			animSel <= 2'b10;
		else if (keys[38] == 1'b1)
			animSel <= 2'b11;
	end
end

// always block for dealing with the seqEnter flag
always @(posedge clk) begin
	if (keys[45] == 1'b1)
		seqEnter <= 1'b1;
	else if (s_rgb_controller == STATE_0_IDLE)
		seqEnter <= 1'b0;
	else if (reset == 1'b1)
		seqEnter <= 1'b0;
end

// always block for controlling the input digits
always @(posedge clk) begin
	if (s_input == INPUT_STATE_1) begin
		if (keys[69] == 1'b1 || keys[22] == 1'b1 || keys[30] == 1'b1 || keys[38] == 1'b1 || keys[37] == 1'b1 || keys[46] == 1'b1 || keys[54] == 1'b1 || keys[61] == 1'b1 || keys[62] == 1'b1 || keys[70] == 1'b1 || keys[28] == 1'b1 || keys[50] == 1'b1 || keys[33] == 1'b1 || keys[35] == 1'b1 || keys[36] == 1'b1 || keys[43] == 1'b1) begin
			if (keys[69] == 1'b1)
				input_value[3:0] <= 4'h0;
			else if (keys[22] == 1'b1)
				input_value[3:0] <= 4'h1;
			else if (keys[30] == 1'b1)
				input_value[3:0] <= 4'h2;
			else if (keys[38] == 1'b1)
				input_value[3:0] <= 4'h3;
			else if (keys[37] == 1'b1)
				input_value[3:0] <= 4'h4;
			else if (keys[46] == 1'b1)
				input_value[3:0] <= 4'h5;
			else if (keys[54] == 1'b1)
				input_value[3:0] <= 4'h6;
			else if (keys[61] == 1'b1)
				input_value[3:0] <= 4'h7;
			else if (keys[62] == 1'b1)
				input_value[3:0] <= 4'h8;
			else if (keys[70] == 1'b1)
				input_value[3:0] <= 4'h9;
			else if (keys[28] == 1'b1)
				input_value[3:0] <= 4'hA;
			else if (keys[50] == 1'b1)
				input_value[3:0] <= 4'hB;
			else if (keys[33] == 1'b1)
				input_value[3:0] <= 4'hC;
			else if (keys[35] == 1'b1)
				input_value[3:0] <= 4'hD;
			else if (keys[36] == 1'b1)
				input_value[3:0] <= 4'hE;
			else if (keys[43] == 1'b1)
				input_value[3:0] <= 4'hF;
		end
	end
	else if (s_input == INPUT_STATE_3) begin
		if (keys[69] == 1'b1 || keys[22] == 1'b1 || keys[30] == 1'b1 || keys[38] == 1'b1 || keys[37] == 1'b1 || keys[46] == 1'b1 || keys[54] == 1'b1 || keys[61] == 1'b1 || keys[62] == 1'b1 || keys[70] == 1'b1 || keys[28] == 1'b1 || keys[50] == 1'b1 || keys[33] == 1'b1 || keys[35] == 1'b1 || keys[36] == 1'b1 || keys[43] == 1'b1) begin
			input_value <= input_value << 4;
			if (keys[69] == 1'b1)
				input_value[3:0] <= 4'h0;
			else if (keys[22] == 1'b1)
				input_value[3:0] <= 4'h1;
			else if (keys[30] == 1'b1)
				input_value[3:0] <= 4'h2;
			else if (keys[38] == 1'b1)
				input_value[3:0] <= 4'h3;
			else if (keys[37] == 1'b1)
				input_value[3:0] <= 4'h4;
			else if (keys[46] == 1'b1)
				input_value[3:0] <= 4'h5;
			else if (keys[54] == 1'b1)
				input_value[3:0] <= 4'h6;
			else if (keys[61] == 1'b1)
				input_value[3:0] <= 4'h7;
			else if (keys[62] == 1'b1)
				input_value[3:0] <= 4'h8;
			else if (keys[70] == 1'b1)
				input_value[3:0] <= 4'h9;
			else if (keys[28] == 1'b1)
				input_value[3:0] <= 4'hA;
			else if (keys[50] == 1'b1)
				input_value[3:0] <= 4'hB;
			else if (keys[33] == 1'b1)
				input_value[3:0] <= 4'hC;
			else if (keys[35] == 1'b1)
				input_value[3:0] <= 4'hD;
			else if (keys[36] == 1'b1)
				input_value[3:0] <= 4'hE;
			else if (keys[43] == 1'b1)
				input_value[3:0] <= 4'hF;
		end
		else if (keys[90] == 1'b1) begin
			input_value[7:4] <= 4'b0000;
		end
	end
	else if (s_input == INPUT_STATE_0_IDLE) begin
		input_value <= 8'h0;
	end
end

// Sequential logic for the input

// always block for storing the inputted value
always @(posedge clk) begin
	if (s_input == INPUT_STATE_4_WAIT) begin
		if (s_rgb_controller == STATE_1_ENTER_R)
			r <= input_value;
		else if (s_rgb_controller == STATE_3_ENTER_G)
			g <= input_value;
		else if (s_rgb_controller == STATE_5_ENTER_B)
			b <= input_value;
	end
	else if (reset == 1'b1) begin
		r <= 8'h00;
		g <= 8'h00;
		b <= 8'h00;
	end
end

// always block for controlling the hexIn and hexOn registers
always @(posedge clk) begin
	if (s_rgb_controller == STATE_0_IDLE) begin
		hex0in <= b[3:0];
		hex1in <= b[7:4];
		hex2in <= g[3:0];
		hex3in <= g[7:4];
		hex4in <= r[3:0];
		hex5in <= r[7:4];
		hexOn[5:0] <= 6'b111111;
	end
	else if (s_input != INPUT_STATE_0_IDLE) begin
		hex0in <= input_value[3:0];
		hex1in <= input_value[7:4];
	end
	if (s_input == INPUT_STATE_2_WAIT) begin
		hexOn[0] <= 1'b1;
	end
	else if (s_input == INPUT_STATE_4_WAIT) begin
		hexOn[1] <= 1'b1;
	end
	else if (s_input == INPUT_STATE_1) begin
		hexOn <= 5'b0;
	end
end
endmodule		