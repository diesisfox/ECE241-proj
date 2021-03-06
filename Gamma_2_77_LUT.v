module Gamma_2_77_LUT (
	input [7:0]in,
	output reg [7:0]out
	);

	/*
	table retrieved from: https://learn.adafruit.com/led-tricks-gamma-correction/the-quick-fix

	0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,
	0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  0,  1,  1,  1,  1,
	1,  1,  1,  1,  1,  1,  1,  1,  1,  2,  2,  2,  2,  2,  2,  2,
	2,  3,  3,  3,  3,  3,  3,  3,  4,  4,  4,  4,  4,  5,  5,  5,
	5,  6,  6,  6,  6,  7,  7,  7,  7,  8,  8,  8,  9,  9,  9, 10,
	10, 10, 11, 11, 11, 12, 12, 13, 13, 13, 14, 14, 15, 15, 16, 16,
	17, 17, 18, 18, 19, 19, 20, 20, 21, 21, 22, 22, 23, 24, 24, 25,
	25, 26, 27, 27, 28, 29, 29, 30, 31, 32, 32, 33, 34, 35, 35, 36,
	37, 38, 39, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 50,
	51, 52, 54, 55, 56, 57, 58, 59, 60, 61, 62, 63, 64, 66, 67, 68,
	69, 70, 72, 73, 74, 75, 77, 78, 79, 81, 82, 83, 85, 86, 87, 89,
	90, 92, 93, 95, 96, 98, 99,101,102,104,105,107,109,110,112,114,
	115,117,119,120,122,124,126,127,129,131,133,135,137,138,140,142,
	144,146,148,150,152,154,156,158,160,162,164,167,169,171,173,175,
	177,180,182,184,186,189,191,193,196,198,200,203,205,208,210,213,
	215,218,220,223,225,228,231,233,236,239,241,244,247,249,252,255

	script used: x.split(',').map(parseInt).map((x,i)=>`8'd${i}:	out = 8'd${x};`).join('\n');
	*/

	always@*begin
		case(in)
			8'd0:	out = 8'd0;
			8'd1:	out = 8'd0;
			8'd2:	out = 8'd0;
			8'd3:	out = 8'd0;
			8'd4:	out = 8'd0;
			8'd5:	out = 8'd0;
			8'd6:	out = 8'd0;
			8'd7:	out = 8'd0;
			8'd8:	out = 8'd0;
			8'd9:	out = 8'd0;
			8'd10:	out = 8'd0;
			8'd11:	out = 8'd0;
			8'd12:	out = 8'd0;
			8'd13:	out = 8'd0;
			8'd14:	out = 8'd0;
			8'd15:	out = 8'd0;
			8'd16:	out = 8'd0;
			8'd17:	out = 8'd0;
			8'd18:	out = 8'd0;
			8'd19:	out = 8'd0;
			8'd20:	out = 8'd0;
			8'd21:	out = 8'd0;
			8'd22:	out = 8'd0;
			8'd23:	out = 8'd0;
			8'd24:	out = 8'd0;
			8'd25:	out = 8'd0;
			8'd26:	out = 8'd0;
			8'd27:	out = 8'd0;
			8'd28:	out = 8'd1;
			8'd29:	out = 8'd1;
			8'd30:	out = 8'd1;
			8'd31:	out = 8'd1;
			8'd32:	out = 8'd1;
			8'd33:	out = 8'd1;
			8'd34:	out = 8'd1;
			8'd35:	out = 8'd1;
			8'd36:	out = 8'd1;
			8'd37:	out = 8'd1;
			8'd38:	out = 8'd1;
			8'd39:	out = 8'd1;
			8'd40:	out = 8'd1;
			8'd41:	out = 8'd2;
			8'd42:	out = 8'd2;
			8'd43:	out = 8'd2;
			8'd44:	out = 8'd2;
			8'd45:	out = 8'd2;
			8'd46:	out = 8'd2;
			8'd47:	out = 8'd2;
			8'd48:	out = 8'd2;
			8'd49:	out = 8'd3;
			8'd50:	out = 8'd3;
			8'd51:	out = 8'd3;
			8'd52:	out = 8'd3;
			8'd53:	out = 8'd3;
			8'd54:	out = 8'd3;
			8'd55:	out = 8'd3;
			8'd56:	out = 8'd4;
			8'd57:	out = 8'd4;
			8'd58:	out = 8'd4;
			8'd59:	out = 8'd4;
			8'd60:	out = 8'd4;
			8'd61:	out = 8'd5;
			8'd62:	out = 8'd5;
			8'd63:	out = 8'd5;
			8'd64:	out = 8'd5;
			8'd65:	out = 8'd6;
			8'd66:	out = 8'd6;
			8'd67:	out = 8'd6;
			8'd68:	out = 8'd6;
			8'd69:	out = 8'd7;
			8'd70:	out = 8'd7;
			8'd71:	out = 8'd7;
			8'd72:	out = 8'd7;
			8'd73:	out = 8'd8;
			8'd74:	out = 8'd8;
			8'd75:	out = 8'd8;
			8'd76:	out = 8'd9;
			8'd77:	out = 8'd9;
			8'd78:	out = 8'd9;
			8'd79:	out = 8'd10;
			8'd80:	out = 8'd10;
			8'd81:	out = 8'd10;
			8'd82:	out = 8'd11;
			8'd83:	out = 8'd11;
			8'd84:	out = 8'd11;
			8'd85:	out = 8'd12;
			8'd86:	out = 8'd12;
			8'd87:	out = 8'd13;
			8'd88:	out = 8'd13;
			8'd89:	out = 8'd13;
			8'd90:	out = 8'd14;
			8'd91:	out = 8'd14;
			8'd92:	out = 8'd15;
			8'd93:	out = 8'd15;
			8'd94:	out = 8'd16;
			8'd95:	out = 8'd16;
			8'd96:	out = 8'd17;
			8'd97:	out = 8'd17;
			8'd98:	out = 8'd18;
			8'd99:	out = 8'd18;
			8'd100:	out = 8'd19;
			8'd101:	out = 8'd19;
			8'd102:	out = 8'd20;
			8'd103:	out = 8'd20;
			8'd104:	out = 8'd21;
			8'd105:	out = 8'd21;
			8'd106:	out = 8'd22;
			8'd107:	out = 8'd22;
			8'd108:	out = 8'd23;
			8'd109:	out = 8'd24;
			8'd110:	out = 8'd24;
			8'd111:	out = 8'd25;
			8'd112:	out = 8'd25;
			8'd113:	out = 8'd26;
			8'd114:	out = 8'd27;
			8'd115:	out = 8'd27;
			8'd116:	out = 8'd28;
			8'd117:	out = 8'd29;
			8'd118:	out = 8'd29;
			8'd119:	out = 8'd30;
			8'd120:	out = 8'd31;
			8'd121:	out = 8'd32;
			8'd122:	out = 8'd32;
			8'd123:	out = 8'd33;
			8'd124:	out = 8'd34;
			8'd125:	out = 8'd35;
			8'd126:	out = 8'd35;
			8'd127:	out = 8'd36;
			8'd128:	out = 8'd37;
			8'd129:	out = 8'd38;
			8'd130:	out = 8'd39;
			8'd131:	out = 8'd39;
			8'd132:	out = 8'd40;
			8'd133:	out = 8'd41;
			8'd134:	out = 8'd42;
			8'd135:	out = 8'd43;
			8'd136:	out = 8'd44;
			8'd137:	out = 8'd45;
			8'd138:	out = 8'd46;
			8'd139:	out = 8'd47;
			8'd140:	out = 8'd48;
			8'd141:	out = 8'd49;
			8'd142:	out = 8'd50;
			8'd143:	out = 8'd50;
			8'd144:	out = 8'd51;
			8'd145:	out = 8'd52;
			8'd146:	out = 8'd54;
			8'd147:	out = 8'd55;
			8'd148:	out = 8'd56;
			8'd149:	out = 8'd57;
			8'd150:	out = 8'd58;
			8'd151:	out = 8'd59;
			8'd152:	out = 8'd60;
			8'd153:	out = 8'd61;
			8'd154:	out = 8'd62;
			8'd155:	out = 8'd63;
			8'd156:	out = 8'd64;
			8'd157:	out = 8'd66;
			8'd158:	out = 8'd67;
			8'd159:	out = 8'd68;
			8'd160:	out = 8'd69;
			8'd161:	out = 8'd70;
			8'd162:	out = 8'd72;
			8'd163:	out = 8'd73;
			8'd164:	out = 8'd74;
			8'd165:	out = 8'd75;
			8'd166:	out = 8'd77;
			8'd167:	out = 8'd78;
			8'd168:	out = 8'd79;
			8'd169:	out = 8'd81;
			8'd170:	out = 8'd82;
			8'd171:	out = 8'd83;
			8'd172:	out = 8'd85;
			8'd173:	out = 8'd86;
			8'd174:	out = 8'd87;
			8'd175:	out = 8'd89;
			8'd176:	out = 8'd90;
			8'd177:	out = 8'd92;
			8'd178:	out = 8'd93;
			8'd179:	out = 8'd95;
			8'd180:	out = 8'd96;
			8'd181:	out = 8'd98;
			8'd182:	out = 8'd99;
			8'd183:	out = 8'd101;
			8'd184:	out = 8'd102;
			8'd185:	out = 8'd104;
			8'd186:	out = 8'd105;
			8'd187:	out = 8'd107;
			8'd188:	out = 8'd109;
			8'd189:	out = 8'd110;
			8'd190:	out = 8'd112;
			8'd191:	out = 8'd114;
			8'd192:	out = 8'd115;
			8'd193:	out = 8'd117;
			8'd194:	out = 8'd119;
			8'd195:	out = 8'd120;
			8'd196:	out = 8'd122;
			8'd197:	out = 8'd124;
			8'd198:	out = 8'd126;
			8'd199:	out = 8'd127;
			8'd200:	out = 8'd129;
			8'd201:	out = 8'd131;
			8'd202:	out = 8'd133;
			8'd203:	out = 8'd135;
			8'd204:	out = 8'd137;
			8'd205:	out = 8'd138;
			8'd206:	out = 8'd140;
			8'd207:	out = 8'd142;
			8'd208:	out = 8'd144;
			8'd209:	out = 8'd146;
			8'd210:	out = 8'd148;
			8'd211:	out = 8'd150;
			8'd212:	out = 8'd152;
			8'd213:	out = 8'd154;
			8'd214:	out = 8'd156;
			8'd215:	out = 8'd158;
			8'd216:	out = 8'd160;
			8'd217:	out = 8'd162;
			8'd218:	out = 8'd164;
			8'd219:	out = 8'd167;
			8'd220:	out = 8'd169;
			8'd221:	out = 8'd171;
			8'd222:	out = 8'd173;
			8'd223:	out = 8'd175;
			8'd224:	out = 8'd177;
			8'd225:	out = 8'd180;
			8'd226:	out = 8'd182;
			8'd227:	out = 8'd184;
			8'd228:	out = 8'd186;
			8'd229:	out = 8'd189;
			8'd230:	out = 8'd191;
			8'd231:	out = 8'd193;
			8'd232:	out = 8'd196;
			8'd233:	out = 8'd198;
			8'd234:	out = 8'd200;
			8'd235:	out = 8'd203;
			8'd236:	out = 8'd205;
			8'd237:	out = 8'd208;
			8'd238:	out = 8'd210;
			8'd239:	out = 8'd213;
			8'd240:	out = 8'd215;
			8'd241:	out = 8'd218;
			8'd242:	out = 8'd220;
			8'd243:	out = 8'd223;
			8'd244:	out = 8'd225;
			8'd245:	out = 8'd228;
			8'd246:	out = 8'd231;
			8'd247:	out = 8'd233;
			8'd248:	out = 8'd236;
			8'd249:	out = 8'd239;
			8'd250:	out = 8'd241;
			8'd251:	out = 8'd244;
			8'd252:	out = 8'd247;
			8'd253:	out = 8'd249;
			8'd254:	out = 8'd252;
			8'd255:	out = 8'd255;
			default:	out = 0;
		endcase
	end
endmodule // Gamma_2_77_LUT
