module Keyboard_Parser (
	// Inputs
	clk,
	reset,
	ps2_clk,
	ps2_data,

	// Outputs
	data,
	key_pressed,
	key_released
);

// States

localparam 		PARSER_STATE_0_IDLE = 3'h0,
				PARSER_STATE_1_E0_RECEIVED = 3'h1,
				PARSER_STATE_2_F0_RECEIVED = 3'h2,
				PARSER_STATE_3_CODE_RECEIVED = 3'h3;
input clk,reset,ps2_clk,ps2_data;
wire [7:0] PS2_byte;
wire data_received;
reg [2:0] ns_keyboard_parser, s_keyboard_parser;
reg F0, E0, ps2_clk_posedge, ps2_clk_negedge;
output reg key_pressed, key_released;
output 	reg [7:0] data;
reg [127:0] active;
PS2_Controller pc0 (.CLOCK_50(clk),.reset(reset),.PS2_CLK(ps2_clk),.PS2_DAT(ps2_data),.received_data(PS2_byte),.received_data_en(data_received));


// FSM

always @(posedge clk) begin
	if (reset == 1'b1) begin
		s_keyboard_parser <= PARSER_STATE_0_IDLE;
	end
	else begin
		s_keyboard_parser <= ns_keyboard_parser;
	end
end

always @(*) begin
	// Defaults
	ns_keyboard_parser = PARSER_STATE_0_IDLE;
	case (s_keyboard_parser)
		PARSER_STATE_0_IDLE:
			begin
				if (data_received == 1'b0)
					ns_keyboard_parser = PARSER_STATE_0_IDLE;
				else if (PS2_byte == 8'hE0 && data_received == 1'b1)
					ns_keyboard_parser = PARSER_STATE_1_E0_RECEIVED;
				else if (PS2_byte == 8'hF0 && data_received == 1'b1)
					ns_keyboard_parser = PARSER_STATE_2_F0_RECEIVED;
				else if (data_received == 1'b1)
					ns_keyboard_parser = PARSER_STATE_3_CODE_RECEIVED;
			end
		PARSER_STATE_1_E0_RECEIVED:
			begin
				if (data_received == 1'b0)
					ns_keyboard_parser = PARSER_STATE_1_E0_RECEIVED;
				else if (PS2_byte == 8'hF0 && data_received == 1'b1)
					ns_keyboard_parser = PARSER_STATE_2_F0_RECEIVED;
				else if (PS2_byte != 8'hF0 && data_received == 1'b1)
					ns_keyboard_parser = PARSER_STATE_3_CODE_RECEIVED;
			end
		PARSER_STATE_2_F0_RECEIVED:
			begin
				if (data_received == 1'b0)
					ns_keyboard_parser = PARSER_STATE_2_F0_RECEIVED;
				else if (data_received == 1'b1)
					ns_keyboard_parser = PARSER_STATE_3_CODE_RECEIVED;
			end
		PARSER_STATE_3_CODE_RECEIVED:
			begin
				ns_keyboard_parser = PARSER_STATE_0_IDLE;
			end
		default:
			begin
				ns_keyboard_parser = PARSER_STATE_0_IDLE;
			end
	endcase
end

// Sequential logic

always @(posedge clk) begin
	if (s_keyboard_parser == 3'h2) begin
		F0 <= 1'b1;
	end
	else if (s_keyboard_parser == 3'h1) begin
		E0 <= 1'b1;
	end
	if (s_keyboard_parser == 3'h0) begin
		E0 <= 1'b0;
		F0 <= 1'b0;
	end
end

always @(posedge clk) begin
	key_pressed <= 1'b0;
	key_released <= 1'b0;
	
	if (s_keyboard_parser == 3'h3) begin
		if (F0 == 1'b1) begin
			key_released <= 1'b1;
		end
		else if (F0 == 1'b0) begin
			key_pressed <= 1'b1;
		end
		if (E0 == 1'b0) begin
			// a=0;z=1;s=2;x=3;c=4;f=5;v=6;g=7;b=8;n=9;j=10;m=11;k=12;,=13;l=14;.=15;/=16;'=17;
			// 1=12;q=13;2=14;w=15;e=16;4=17;r=18;5=19;t=20;y=21;7=22;u=23;8=24;i=25;9=26;o=27;p=28;-=29;[=30;==31;]=32;\=33
			case (PS2_byte)
				8'h1C: data <= 8'h00;
				8'h1A: data <= 8'h01;
				8'h1B: data <= 8'h02;
				8'h22: data <= 8'h03;
				8'h21: data <= 8'h04;
				8'h2B: data <= 8'h05;
				8'h2A: data <= 8'h06;
				8'h34: data <= 8'h07;
				8'h32: data <= 8'h08;
				8'h31: data <= 8'h09;
				8'h3B: data <= 8'h0A;
				8'h3A: data <= 8'h0B;
				8'h42: data <= 8'h0C;
				8'h41: data <= 8'h0D;
				8'h4B: data <= 8'h0E;
				8'h49: data <= 8'h0F;
				8'h4A: data <= 8'h10;
				8'h52: data <= 8'h11;
				8'h16: data <= 8'h0C;
				8'h15: data <= 8'h0D;
				8'h1E: data <= 8'h0E;
				8'h1D: data <= 8'h0F;
				8'h24: data <= 8'h10;
				8'h25: data <= 8'h11;
				8'h2D: data <= 8'h12;
				8'h2E: data <= 8'h13;
				8'h2C: data <= 8'h14;
				8'h35: data <= 8'h15;
				8'h3D: data <= 8'h16;
				8'h3C: data <= 8'h17;
				8'h3E: data <= 8'h18;
				8'h43: data <= 8'h19;
				8'h46: data <= 8'h1A;
				8'h44: data <= 8'h1B;
				8'h4D: data <= 8'h1C;
				8'h4E: data <= 8'h1D;
				8'h54: data <= 8'h1E;
				8'h55: data <= 8'h1F;
				8'h5B: data <= 8'h20;
				8'h5D: data <= 8'h21;
			endcase
		//if (key_pressed == 1'b1 && active[data] == 1'b1)
			//key_pressed <= 1'b0;
		//else if (key_released == 1'b1 & active[data] == 1'b0)
			//key_released <= 1'b0;
		end
	end
	
	if (reset == 1'b1)
		data <= 8'h0;
		key_pressed <= 1'b0;
		key_released <= 1'b0;
end
endmodule
