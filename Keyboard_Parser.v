module Keyboard_Parser (
	// Inputs
	clk,
	reset,
	ps2_clk,
	ps2_data,

	// Outputs
	key_data,
	E0_key_data
);

// States

localparam 		PARSER_STATE_0_IDLE = 3'h0,
				PARSER_STATE_1_E0_RECEIVED = 3'h1,
				PARSER_STATE_2_F0_RECEIVED = 3'h2,
				PARSER_STATE_3_CODE_RECEIVED = 3'h3;
input clk,reset,ps2_clk,ps2_data;
wire [7:0] PS2_byte;
wire data_received, CLOCK_10;
reg [2:0] ns_keyboard_parser, s_keyboard_parser;
reg F0, E0;
output reg [127:0] key_data, E0_key_data;
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
				else if (data_received == 1'b1 && PS2_byte != 8'hF0 && PS2_byte != 8'hE0)
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
	if (s_keyboard_parser == 3'h3) begin
		if (E0 == 1'b0 && F0 == 1'b0) begin
			case (PS2_byte)
				8'h0: key_data[0] <= 1'b1;
                8'h1: key_data[1] <= 1'b1;
                8'h2: key_data[2] <= 1'b1;
                8'h3: key_data[3] <= 1'b1;
                8'h4: key_data[4] <= 1'b1;
                8'h5: key_data[5] <= 1'b1;
                8'h6: key_data[6] <= 1'b1;
                8'h7: key_data[7] <= 1'b1;
                8'h8: key_data[8] <= 1'b1;
                8'h9: key_data[9] <= 1'b1;
                8'ha: key_data[10] <= 1'b1;
                8'hb: key_data[11] <= 1'b1;
                8'hc: key_data[12] <= 1'b1;
                8'hd: key_data[13] <= 1'b1;
                8'he: key_data[14] <= 1'b1;
                8'hf: key_data[15] <= 1'b1;
                8'h10: key_data[16] <= 1'b1;
                8'h11: key_data[17] <= 1'b1;
                8'h12: key_data[18] <= 1'b1;
                8'h13: key_data[19] <= 1'b1;
                8'h14: key_data[20] <= 1'b1;
                8'h15: key_data[21] <= 1'b1;
                8'h16: key_data[22] <= 1'b1;
                8'h17: key_data[23] <= 1'b1;
                8'h18: key_data[24] <= 1'b1;
                8'h19: key_data[25] <= 1'b1;
                8'h1a: key_data[26] <= 1'b1;
                8'h1b: key_data[27] <= 1'b1;
                8'h1c: key_data[28] <= 1'b1;
                8'h1d: key_data[29] <= 1'b1;
                8'h1e: key_data[30] <= 1'b1;
                8'h1f: key_data[31] <= 1'b1;
                8'h20: key_data[32] <= 1'b1;
                8'h21: key_data[33] <= 1'b1;
                8'h22: key_data[34] <= 1'b1;
                8'h23: key_data[35] <= 1'b1;
                8'h24: key_data[36] <= 1'b1;
                8'h25: key_data[37] <= 1'b1;
                8'h26: key_data[38] <= 1'b1;
                8'h27: key_data[39] <= 1'b1;
                8'h28: key_data[40] <= 1'b1;
                8'h29: key_data[41] <= 1'b1;
                8'h2a: key_data[42] <= 1'b1;
                8'h2b: key_data[43] <= 1'b1;
                8'h2c: key_data[44] <= 1'b1;
                8'h2d: key_data[45] <= 1'b1;
                8'h2e: key_data[46] <= 1'b1;
                8'h2f: key_data[47] <= 1'b1;
                8'h30: key_data[48] <= 1'b1;
                8'h31: key_data[49] <= 1'b1;
                8'h32: key_data[50] <= 1'b1;
                8'h33: key_data[51] <= 1'b1;
                8'h34: key_data[52] <= 1'b1;
                8'h35: key_data[53] <= 1'b1;
                8'h36: key_data[54] <= 1'b1;
                8'h37: key_data[55] <= 1'b1;
                8'h38: key_data[56] <= 1'b1;
                8'h39: key_data[57] <= 1'b1;
                8'h3a: key_data[58] <= 1'b1;
                8'h3b: key_data[59] <= 1'b1;
                8'h3c: key_data[60] <= 1'b1;
                8'h3d: key_data[61] <= 1'b1;
                8'h3e: key_data[62] <= 1'b1;
                8'h3f: key_data[63] <= 1'b1;
                8'h40: key_data[64] <= 1'b1;
                8'h41: key_data[65] <= 1'b1;
                8'h42: key_data[66] <= 1'b1;
                8'h43: key_data[67] <= 1'b1;
                8'h44: key_data[68] <= 1'b1;
                8'h45: key_data[69] <= 1'b1;
                8'h46: key_data[70] <= 1'b1;
                8'h47: key_data[71] <= 1'b1;
                8'h48: key_data[72] <= 1'b1;
                8'h49: key_data[73] <= 1'b1;
                8'h4a: key_data[74] <= 1'b1;
                8'h4b: key_data[75] <= 1'b1;
                8'h4c: key_data[76] <= 1'b1;
                8'h4d: key_data[77] <= 1'b1;
                8'h4e: key_data[78] <= 1'b1;
                8'h4f: key_data[79] <= 1'b1;
                8'h50: key_data[80] <= 1'b1;
                8'h51: key_data[81] <= 1'b1;
                8'h52: key_data[82] <= 1'b1;
                8'h53: key_data[83] <= 1'b1;
                8'h54: key_data[84] <= 1'b1;
                8'h55: key_data[85] <= 1'b1;
                8'h56: key_data[86] <= 1'b1;
                8'h57: key_data[87] <= 1'b1;
                8'h58: key_data[88] <= 1'b1;
                8'h59: key_data[89] <= 1'b1;
                8'h5a: key_data[90] <= 1'b1;
                8'h5b: key_data[91] <= 1'b1;
                8'h5c: key_data[92] <= 1'b1;
                8'h5d: key_data[93] <= 1'b1;
                8'h5e: key_data[94] <= 1'b1;
                8'h5f: key_data[95] <= 1'b1;
                8'h60: key_data[96] <= 1'b1;
                8'h61: key_data[97] <= 1'b1;
                8'h62: key_data[98] <= 1'b1;
                8'h63: key_data[99] <= 1'b1;
                8'h64: key_data[100] <= 1'b1;
                8'h65: key_data[101] <= 1'b1;
                8'h66: key_data[102] <= 1'b1;
                8'h67: key_data[103] <= 1'b1;
                8'h68: key_data[104] <= 1'b1;
                8'h69: key_data[105] <= 1'b1;
                8'h6a: key_data[106] <= 1'b1;
                8'h6b: key_data[107] <= 1'b1;
                8'h6c: key_data[108] <= 1'b1;
                8'h6d: key_data[109] <= 1'b1;
                8'h6e: key_data[110] <= 1'b1;
                8'h6f: key_data[111] <= 1'b1;
                8'h70: key_data[112] <= 1'b1;
                8'h71: key_data[113] <= 1'b1;
                8'h72: key_data[114] <= 1'b1;
                8'h73: key_data[115] <= 1'b1;
                8'h74: key_data[116] <= 1'b1;
                8'h75: key_data[117] <= 1'b1;
                8'h76: key_data[118] <= 1'b1;
                8'h77: key_data[119] <= 1'b1;
                8'h78: key_data[120] <= 1'b1;
                8'h79: key_data[121] <= 1'b1;
                8'h7a: key_data[122] <= 1'b1;
                8'h7b: key_data[123] <= 1'b1;
                8'h7c: key_data[124] <= 1'b1;
                8'h7d: key_data[125] <= 1'b1;
                8'h7e: key_data[126] <= 1'b1;
                8'h7f: key_data[127] <= 1'b1;
			endcase
		end
		else if (E0 == 1'b0 && F0 == 1'b1) begin	
			case (PS2_byte)
				8'h0: key_data[0] <= 1'b0;
                8'h1: key_data[1] <= 1'b0;
                8'h2: key_data[2] <= 1'b0;
                8'h3: key_data[3] <= 1'b0;
                8'h4: key_data[4] <= 1'b0;
                8'h5: key_data[5] <= 1'b0;
                8'h6: key_data[6] <= 1'b0;
                8'h7: key_data[7] <= 1'b0;
                8'h8: key_data[8] <= 1'b0;
                8'h9: key_data[9] <= 1'b0;
                8'ha: key_data[10] <= 1'b0;
                8'hb: key_data[11] <= 1'b0;
                8'hc: key_data[12] <= 1'b0;
                8'hd: key_data[13] <= 1'b0;
                8'he: key_data[14] <= 1'b0;
                8'hf: key_data[15] <= 1'b0;
                8'h10: key_data[16] <= 1'b0;
                8'h11: key_data[17] <= 1'b0;
                8'h12: key_data[18] <= 1'b0;
                8'h13: key_data[19] <= 1'b0;
                8'h14: key_data[20] <= 1'b0;
                8'h15: key_data[21] <= 1'b0;
                8'h16: key_data[22] <= 1'b0;
                8'h17: key_data[23] <= 1'b0;
                8'h18: key_data[24] <= 1'b0;
                8'h19: key_data[25] <= 1'b0;
                8'h1a: key_data[26] <= 1'b0;
                8'h1b: key_data[27] <= 1'b0;
                8'h1c: key_data[28] <= 1'b0;
                8'h1d: key_data[29] <= 1'b0;
                8'h1e: key_data[30] <= 1'b0;
                8'h1f: key_data[31] <= 1'b0;
                8'h20: key_data[32] <= 1'b0;
                8'h21: key_data[33] <= 1'b0;
                8'h22: key_data[34] <= 1'b0;
                8'h23: key_data[35] <= 1'b0;
                8'h24: key_data[36] <= 1'b0;
                8'h25: key_data[37] <= 1'b0;
                8'h26: key_data[38] <= 1'b0;
                8'h27: key_data[39] <= 1'b0;
                8'h28: key_data[40] <= 1'b0;
                8'h29: key_data[41] <= 1'b0;
                8'h2a: key_data[42] <= 1'b0;
                8'h2b: key_data[43] <= 1'b0;
                8'h2c: key_data[44] <= 1'b0;
                8'h2d: key_data[45] <= 1'b0;
                8'h2e: key_data[46] <= 1'b0;
                8'h2f: key_data[47] <= 1'b0;
                8'h30: key_data[48] <= 1'b0;
                8'h31: key_data[49] <= 1'b0;
                8'h32: key_data[50] <= 1'b0;
                8'h33: key_data[51] <= 1'b0;
                8'h34: key_data[52] <= 1'b0;
                8'h35: key_data[53] <= 1'b0;
                8'h36: key_data[54] <= 1'b0;
                8'h37: key_data[55] <= 1'b0;
                8'h38: key_data[56] <= 1'b0;
                8'h39: key_data[57] <= 1'b0;
                8'h3a: key_data[58] <= 1'b0;
                8'h3b: key_data[59] <= 1'b0;
                8'h3c: key_data[60] <= 1'b0;
                8'h3d: key_data[61] <= 1'b0;
                8'h3e: key_data[62] <= 1'b0;
                8'h3f: key_data[63] <= 1'b0;
                8'h40: key_data[64] <= 1'b0;
                8'h41: key_data[65] <= 1'b0;
                8'h42: key_data[66] <= 1'b0;
                8'h43: key_data[67] <= 1'b0;
                8'h44: key_data[68] <= 1'b0;
                8'h45: key_data[69] <= 1'b0;
                8'h46: key_data[70] <= 1'b0;
                8'h47: key_data[71] <= 1'b0;
                8'h48: key_data[72] <= 1'b0;
                8'h49: key_data[73] <= 1'b0;
                8'h4a: key_data[74] <= 1'b0;
                8'h4b: key_data[75] <= 1'b0;
                8'h4c: key_data[76] <= 1'b0;
                8'h4d: key_data[77] <= 1'b0;
                8'h4e: key_data[78] <= 1'b0;
                8'h4f: key_data[79] <= 1'b0;
                8'h50: key_data[80] <= 1'b0;
                8'h51: key_data[81] <= 1'b0;
                8'h52: key_data[82] <= 1'b0;
                8'h53: key_data[83] <= 1'b0;
                8'h54: key_data[84] <= 1'b0;
                8'h55: key_data[85] <= 1'b0;
                8'h56: key_data[86] <= 1'b0;
                8'h57: key_data[87] <= 1'b0;
                8'h58: key_data[88] <= 1'b0;
                8'h59: key_data[89] <= 1'b0;
                8'h5a: key_data[90] <= 1'b0;
                8'h5b: key_data[91] <= 1'b0;
                8'h5c: key_data[92] <= 1'b0;
                8'h5d: key_data[93] <= 1'b0;
                8'h5e: key_data[94] <= 1'b0;
                8'h5f: key_data[95] <= 1'b0;
                8'h60: key_data[96] <= 1'b0;
                8'h61: key_data[97] <= 1'b0;
                8'h62: key_data[98] <= 1'b0;
                8'h63: key_data[99] <= 1'b0;
                8'h64: key_data[100] <= 1'b0;
                8'h65: key_data[101] <= 1'b0;
                8'h66: key_data[102] <= 1'b0;
                8'h67: key_data[103] <= 1'b0;
                8'h68: key_data[104] <= 1'b0;
                8'h69: key_data[105] <= 1'b0;
                8'h6a: key_data[106] <= 1'b0;
                8'h6b: key_data[107] <= 1'b0;
                8'h6c: key_data[108] <= 1'b0;
                8'h6d: key_data[109] <= 1'b0;
                8'h6e: key_data[110] <= 1'b0;
                8'h6f: key_data[111] <= 1'b0;
                8'h70: key_data[112] <= 1'b0;
                8'h71: key_data[113] <= 1'b0;
                8'h72: key_data[114] <= 1'b0;
                8'h73: key_data[115] <= 1'b0;
                8'h74: key_data[116] <= 1'b0;
                8'h75: key_data[117] <= 1'b0;
                8'h76: key_data[118] <= 1'b0;
                8'h77: key_data[119] <= 1'b0;
                8'h78: key_data[120] <= 1'b0;
                8'h79: key_data[121] <= 1'b0;
                8'h7a: key_data[122] <= 1'b0;
                8'h7b: key_data[123] <= 1'b0;
                8'h7c: key_data[124] <= 1'b0;
                8'h7d: key_data[125] <= 1'b0;
                8'h7e: key_data[126] <= 1'b0;
                8'h7f: key_data[127] <= 1'b0;
			endcase
		end
		else if (E0 == 1'b1 && F0 == 1'b0) begin
			case (PS2_byte)
				8'h0: E0_key_data[0] <= 1'b1;
                8'h1: E0_key_data[1] <= 1'b1;
                8'h2: E0_key_data[2] <= 1'b1;
                8'h3: E0_key_data[3] <= 1'b1;
                8'h4: E0_key_data[4] <= 1'b1;
                8'h5: E0_key_data[5] <= 1'b1;
                8'h6: E0_key_data[6] <= 1'b1;
                8'h7: E0_key_data[7] <= 1'b1;
                8'h8: E0_key_data[8] <= 1'b1;
                8'h9: E0_key_data[9] <= 1'b1;
                8'ha: E0_key_data[10] <= 1'b1;
                8'hb: E0_key_data[11] <= 1'b1;
                8'hc: E0_key_data[12] <= 1'b1;
                8'hd: E0_key_data[13] <= 1'b1;
                8'he: E0_key_data[14] <= 1'b1;
                8'hf: E0_key_data[15] <= 1'b1;
                8'h10: E0_key_data[16] <= 1'b1;
                8'h11: E0_key_data[17] <= 1'b1;
                8'h12: E0_key_data[18] <= 1'b1;
                8'h13: E0_key_data[19] <= 1'b1;
                8'h14: E0_key_data[20] <= 1'b1;
                8'h15: E0_key_data[21] <= 1'b1;
                8'h16: E0_key_data[22] <= 1'b1;
                8'h17: E0_key_data[23] <= 1'b1;
                8'h18: E0_key_data[24] <= 1'b1;
                8'h19: E0_key_data[25] <= 1'b1;
                8'h1a: E0_key_data[26] <= 1'b1;
                8'h1b: E0_key_data[27] <= 1'b1;
                8'h1c: E0_key_data[28] <= 1'b1;
                8'h1d: E0_key_data[29] <= 1'b1;
                8'h1e: E0_key_data[30] <= 1'b1;
                8'h1f: E0_key_data[31] <= 1'b1;
                8'h20: E0_key_data[32] <= 1'b1;
                8'h21: E0_key_data[33] <= 1'b1;
                8'h22: E0_key_data[34] <= 1'b1;
                8'h23: E0_key_data[35] <= 1'b1;
                8'h24: E0_key_data[36] <= 1'b1;
                8'h25: E0_key_data[37] <= 1'b1;
                8'h26: E0_key_data[38] <= 1'b1;
                8'h27: E0_key_data[39] <= 1'b1;
                8'h28: E0_key_data[40] <= 1'b1;
                8'h29: E0_key_data[41] <= 1'b1;
                8'h2a: E0_key_data[42] <= 1'b1;
                8'h2b: E0_key_data[43] <= 1'b1;
                8'h2c: E0_key_data[44] <= 1'b1;
                8'h2d: E0_key_data[45] <= 1'b1;
                8'h2e: E0_key_data[46] <= 1'b1;
                8'h2f: E0_key_data[47] <= 1'b1;
                8'h30: E0_key_data[48] <= 1'b1;
                8'h31: E0_key_data[49] <= 1'b1;
                8'h32: E0_key_data[50] <= 1'b1;
                8'h33: E0_key_data[51] <= 1'b1;
                8'h34: E0_key_data[52] <= 1'b1;
                8'h35: E0_key_data[53] <= 1'b1;
                8'h36: E0_key_data[54] <= 1'b1;
                8'h37: E0_key_data[55] <= 1'b1;
                8'h38: E0_key_data[56] <= 1'b1;
                8'h39: E0_key_data[57] <= 1'b1;
                8'h3a: E0_key_data[58] <= 1'b1;
                8'h3b: E0_key_data[59] <= 1'b1;
                8'h3c: E0_key_data[60] <= 1'b1;
                8'h3d: E0_key_data[61] <= 1'b1;
                8'h3e: E0_key_data[62] <= 1'b1;
                8'h3f: E0_key_data[63] <= 1'b1;
                8'h40: E0_key_data[64] <= 1'b1;
                8'h41: E0_key_data[65] <= 1'b1;
                8'h42: E0_key_data[66] <= 1'b1;
                8'h43: E0_key_data[67] <= 1'b1;
                8'h44: E0_key_data[68] <= 1'b1;
                8'h45: E0_key_data[69] <= 1'b1;
                8'h46: E0_key_data[70] <= 1'b1;
                8'h47: E0_key_data[71] <= 1'b1;
                8'h48: E0_key_data[72] <= 1'b1;
                8'h49: E0_key_data[73] <= 1'b1;
                8'h4a: E0_key_data[74] <= 1'b1;
                8'h4b: E0_key_data[75] <= 1'b1;
                8'h4c: E0_key_data[76] <= 1'b1;
                8'h4d: E0_key_data[77] <= 1'b1;
                8'h4e: E0_key_data[78] <= 1'b1;
                8'h4f: E0_key_data[79] <= 1'b1;
                8'h50: E0_key_data[80] <= 1'b1;
                8'h51: E0_key_data[81] <= 1'b1;
                8'h52: E0_key_data[82] <= 1'b1;
                8'h53: E0_key_data[83] <= 1'b1;
                8'h54: E0_key_data[84] <= 1'b1;
                8'h55: E0_key_data[85] <= 1'b1;
                8'h56: E0_key_data[86] <= 1'b1;
                8'h57: E0_key_data[87] <= 1'b1;
                8'h58: E0_key_data[88] <= 1'b1;
                8'h59: E0_key_data[89] <= 1'b1;
                8'h5a: E0_key_data[90] <= 1'b1;
                8'h5b: E0_key_data[91] <= 1'b1;
                8'h5c: E0_key_data[92] <= 1'b1;
                8'h5d: E0_key_data[93] <= 1'b1;
                8'h5e: E0_key_data[94] <= 1'b1;
                8'h5f: E0_key_data[95] <= 1'b1;
                8'h60: E0_key_data[96] <= 1'b1;
                8'h61: E0_key_data[97] <= 1'b1;
                8'h62: E0_key_data[98] <= 1'b1;
                8'h63: E0_key_data[99] <= 1'b1;
                8'h64: E0_key_data[100] <= 1'b1;
                8'h65: E0_key_data[101] <= 1'b1;
                8'h66: E0_key_data[102] <= 1'b1;
                8'h67: E0_key_data[103] <= 1'b1;
                8'h68: E0_key_data[104] <= 1'b1;
                8'h69: E0_key_data[105] <= 1'b1;
                8'h6a: E0_key_data[106] <= 1'b1;
                8'h6b: E0_key_data[107] <= 1'b1;
                8'h6c: E0_key_data[108] <= 1'b1;
                8'h6d: E0_key_data[109] <= 1'b1;
                8'h6e: E0_key_data[110] <= 1'b1;
                8'h6f: E0_key_data[111] <= 1'b1;
                8'h70: E0_key_data[112] <= 1'b1;
                8'h71: E0_key_data[113] <= 1'b1;
                8'h72: E0_key_data[114] <= 1'b1;
                8'h73: E0_key_data[115] <= 1'b1;
                8'h74: E0_key_data[116] <= 1'b1;
                8'h75: E0_key_data[117] <= 1'b1;
                8'h76: E0_key_data[118] <= 1'b1;
                8'h77: E0_key_data[119] <= 1'b1;
                8'h78: E0_key_data[120] <= 1'b1;
                8'h79: E0_key_data[121] <= 1'b1;
                8'h7a: E0_key_data[122] <= 1'b1;
                8'h7b: E0_key_data[123] <= 1'b1;
                8'h7c: E0_key_data[124] <= 1'b1;
                8'h7d: E0_key_data[125] <= 1'b1;
                8'h7e: E0_key_data[126] <= 1'b1;
                8'h7f: E0_key_data[127] <= 1'b1;
			endcase
		end
		else if (E0 == 1'b1 && F0 == 1'b1) begin	
			case (PS2_byte)
				8'h0: E0_key_data[0] <= 1'b0;
                8'h1: E0_key_data[1] <= 1'b0;
                8'h2: E0_key_data[2] <= 1'b0;
                8'h3: E0_key_data[3] <= 1'b0;
                8'h4: E0_key_data[4] <= 1'b0;
                8'h5: E0_key_data[5] <= 1'b0;
                8'h6: E0_key_data[6] <= 1'b0;
                8'h7: E0_key_data[7] <= 1'b0;
                8'h8: E0_key_data[8] <= 1'b0;
                8'h9: E0_key_data[9] <= 1'b0;
                8'ha: E0_key_data[10] <= 1'b0;
                8'hb: E0_key_data[11] <= 1'b0;
                8'hc: E0_key_data[12] <= 1'b0;
                8'hd: E0_key_data[13] <= 1'b0;
                8'he: E0_key_data[14] <= 1'b0;
                8'hf: E0_key_data[15] <= 1'b0;
                8'h10: E0_key_data[16] <= 1'b0;
                8'h11: E0_key_data[17] <= 1'b0;
                8'h12: E0_key_data[18] <= 1'b0;
                8'h13: E0_key_data[19] <= 1'b0;
                8'h14: E0_key_data[20] <= 1'b0;
                8'h15: E0_key_data[21] <= 1'b0;
                8'h16: E0_key_data[22] <= 1'b0;
                8'h17: E0_key_data[23] <= 1'b0;
                8'h18: E0_key_data[24] <= 1'b0;
                8'h19: E0_key_data[25] <= 1'b0;
                8'h1a: E0_key_data[26] <= 1'b0;
                8'h1b: E0_key_data[27] <= 1'b0;
                8'h1c: E0_key_data[28] <= 1'b0;
                8'h1d: E0_key_data[29] <= 1'b0;
                8'h1e: E0_key_data[30] <= 1'b0;
                8'h1f: E0_key_data[31] <= 1'b0;
                8'h20: E0_key_data[32] <= 1'b0;
                8'h21: E0_key_data[33] <= 1'b0;
                8'h22: E0_key_data[34] <= 1'b0;
                8'h23: E0_key_data[35] <= 1'b0;
                8'h24: E0_key_data[36] <= 1'b0;
                8'h25: E0_key_data[37] <= 1'b0;
                8'h26: E0_key_data[38] <= 1'b0;
                8'h27: E0_key_data[39] <= 1'b0;
                8'h28: E0_key_data[40] <= 1'b0;
                8'h29: E0_key_data[41] <= 1'b0;
                8'h2a: E0_key_data[42] <= 1'b0;
                8'h2b: E0_key_data[43] <= 1'b0;
                8'h2c: E0_key_data[44] <= 1'b0;
                8'h2d: E0_key_data[45] <= 1'b0;
                8'h2e: E0_key_data[46] <= 1'b0;
                8'h2f: E0_key_data[47] <= 1'b0;
                8'h30: E0_key_data[48] <= 1'b0;
                8'h31: E0_key_data[49] <= 1'b0;
                8'h32: E0_key_data[50] <= 1'b0;
                8'h33: E0_key_data[51] <= 1'b0;
                8'h34: E0_key_data[52] <= 1'b0;
                8'h35: E0_key_data[53] <= 1'b0;
                8'h36: E0_key_data[54] <= 1'b0;
                8'h37: E0_key_data[55] <= 1'b0;
                8'h38: E0_key_data[56] <= 1'b0;
                8'h39: E0_key_data[57] <= 1'b0;
                8'h3a: E0_key_data[58] <= 1'b0;
                8'h3b: E0_key_data[59] <= 1'b0;
                8'h3c: E0_key_data[60] <= 1'b0;
                8'h3d: E0_key_data[61] <= 1'b0;
                8'h3e: E0_key_data[62] <= 1'b0;
                8'h3f: E0_key_data[63] <= 1'b0;
                8'h40: E0_key_data[64] <= 1'b0;
                8'h41: E0_key_data[65] <= 1'b0;
                8'h42: E0_key_data[66] <= 1'b0;
                8'h43: E0_key_data[67] <= 1'b0;
                8'h44: E0_key_data[68] <= 1'b0;
                8'h45: E0_key_data[69] <= 1'b0;
                8'h46: E0_key_data[70] <= 1'b0;
                8'h47: E0_key_data[71] <= 1'b0;
                8'h48: E0_key_data[72] <= 1'b0;
                8'h49: E0_key_data[73] <= 1'b0;
                8'h4a: E0_key_data[74] <= 1'b0;
                8'h4b: E0_key_data[75] <= 1'b0;
                8'h4c: E0_key_data[76] <= 1'b0;
                8'h4d: E0_key_data[77] <= 1'b0;
                8'h4e: E0_key_data[78] <= 1'b0;
                8'h4f: E0_key_data[79] <= 1'b0;
                8'h50: E0_key_data[80] <= 1'b0;
                8'h51: E0_key_data[81] <= 1'b0;
                8'h52: E0_key_data[82] <= 1'b0;
                8'h53: E0_key_data[83] <= 1'b0;
                8'h54: E0_key_data[84] <= 1'b0;
                8'h55: E0_key_data[85] <= 1'b0;
                8'h56: E0_key_data[86] <= 1'b0;
                8'h57: E0_key_data[87] <= 1'b0;
                8'h58: E0_key_data[88] <= 1'b0;
                8'h59: E0_key_data[89] <= 1'b0;
                8'h5a: E0_key_data[90] <= 1'b0;
                8'h5b: E0_key_data[91] <= 1'b0;
                8'h5c: E0_key_data[92] <= 1'b0;
                8'h5d: E0_key_data[93] <= 1'b0;
                8'h5e: E0_key_data[94] <= 1'b0;
                8'h5f: E0_key_data[95] <= 1'b0;
                8'h60: E0_key_data[96] <= 1'b0;
                8'h61: E0_key_data[97] <= 1'b0;
                8'h62: E0_key_data[98] <= 1'b0;
                8'h63: E0_key_data[99] <= 1'b0;
                8'h64: E0_key_data[100] <= 1'b0;
                8'h65: E0_key_data[101] <= 1'b0;
                8'h66: E0_key_data[102] <= 1'b0;
                8'h67: E0_key_data[103] <= 1'b0;
                8'h68: E0_key_data[104] <= 1'b0;
                8'h69: E0_key_data[105] <= 1'b0;
                8'h6a: E0_key_data[106] <= 1'b0;
                8'h6b: E0_key_data[107] <= 1'b0;
                8'h6c: E0_key_data[108] <= 1'b0;
                8'h6d: E0_key_data[109] <= 1'b0;
                8'h6e: E0_key_data[110] <= 1'b0;
                8'h6f: E0_key_data[111] <= 1'b0;
                8'h70: E0_key_data[112] <= 1'b0;
                8'h71: E0_key_data[113] <= 1'b0;
                8'h72: E0_key_data[114] <= 1'b0;
                8'h73: E0_key_data[115] <= 1'b0;
                8'h74: E0_key_data[116] <= 1'b0;
                8'h75: E0_key_data[117] <= 1'b0;
                8'h76: E0_key_data[118] <= 1'b0;
                8'h77: E0_key_data[119] <= 1'b0;
                8'h78: E0_key_data[120] <= 1'b0;
                8'h79: E0_key_data[121] <= 1'b0;
                8'h7a: E0_key_data[122] <= 1'b0;
                8'h7b: E0_key_data[123] <= 1'b0;
                8'h7c: E0_key_data[124] <= 1'b0;
                8'h7d: E0_key_data[125] <= 1'b0;
                8'h7e: E0_key_data[126] <= 1'b0;
                8'h7f: E0_key_data[127] <= 1'b0;
			endcase
		end
	end
	if (reset == 1'b1) begin
		key_data <= 128'h00;
		E0_key_data <= 128'h00;
	end
end
endmodule
