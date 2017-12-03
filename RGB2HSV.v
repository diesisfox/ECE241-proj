module RGB2HSV (
	input clk,
	input [7:0] r, g, b,
	output reg [31:0] h, s, v
	);
	wire GgeR, BgeG, RgeB;
	wire [31:0] rF, gF, bF;

	localparam
	F_0 	= 32'h00000000, // 0/6
	F_42_5 	= 32'h3e2a0000, // 1/6
	F_85 	= 32'h3eaa0000, // 2/6
	F_127_5	= 32'h3eff0000, // 3/6
	F_170 	= 32'h3f2a0000, // 4/6
	F_212_5	= 32'h3f548000, // 5/6
	F_255 	= 32'h3f7f0000; // 6/6

	FPconv_Q2_8_to_F32 ConvR(
	.clock(clk),
	.dataa({2'b0,r}),
	.result(rF));
	FPconv_Q2_8_to_F32 ConvG(
	.clock(clk),
	.dataa({2'b0,g}),
	.result(gF));
	FPconv_Q2_8_to_F32 ConvB(
	.clock(clk),
	.dataa({2'b0,b}),
	.result(bF));

	FPcomp GgeR_comp(
	.clock(clk),
	.dataa(gF),
	.datab(rF),
	.aeb(),
	.agb(),
	.ageb(GgeR),
	.alb(),
	.aleb(),
	.aneb());
	FPcomp BgeG_comp(
	.clock(clk),
	.dataa(bF),
	.datab(gF),
	.aeb(),
	.agb(),
	.ageb(BgeG),
	.alb(),
	.aleb(),
	.aneb());
	FPcomp RgeB_comp(
	.clock(clk),
	.dataa(rF),
	.datab(bF),
	.aeb(),
	.agb(),
	.ageb(RgeB),
	.alb(),
	.aleb(),
	.aneb());

	//formula
	always@*begin
		case({GgeR,RgeB,BgeG})
		3'b001:begin
			//B>R>G
			v = bF;
			//s = F_255 - g/b
			div_S_0a = gF;
			div_S_0b = bF;
			s = sub_S_0o;
			//h = F_170 + F_42_5*((r-g)/(b-g))
			sub_H_0a = rF;
			sub_H_0b = gF;
			sub_H_1a = bF;
			sub_H_1b = gF;
			add_H_0a = F_170;
			h = add_H_0o;
		end
		3'b010:begin
			//R>G>B
			v = rF;
			//s = F_255 - b/r
			div_S_0a = bF;
			div_S_0b = rF;
			s = sub_S_0o;
			//h = F_0 + F_42_5*((g-b)/(r-b))
			sub_H_0a = gF;
			sub_H_0b = bF;
			sub_H_1a = rF;
			sub_H_1b = bF;
			add_H_0a = F_0;
			h = add_H_0o;
		end
		3'b011:begin
			//R≥B≥G, G<R
			v = rF;
			//s = F_255 - g/r
			div_S_0a = gF;
			div_S_0b = rF;
			s = sub_S_0o;
			//h = F_212_5 + F_42_5*((r-b)/(r-g))
			sub_H_0a = rF;
			sub_H_0b = bF;
			sub_H_1a = rF;
			sub_H_1b = gF;
			add_H_0a = F_212_5;
			h = add_H_0o;
		end
		3'b100:begin
			//G>B>R
			v = gF;
			//s = F_255 - r/g
			div_S_0a = rF;
			div_S_0b = gF;
			s = sub_S_0o;
			//h = F_85 + F_42_5*((b-r)/(g-r))
			sub_H_0a = bF;
			sub_H_0b = rF;
			sub_H_1a = gF;
			sub_H_1b = rF;
			add_H_0a = F_85;
			h = add_H_0o;
		end
		3'b101:begin
			//B≥G≥R, R<B
			v = bF;
			//s = F_255 - r/b
			div_S_0a = rF;
			div_S_0b = bF;
			s = sub_S_0o;
			//h = F_127_5 + F_42_5*((b-g)/(b-r))
			sub_H_0a = bF;
			sub_H_0b = gF;
			sub_H_1a = bF;
			sub_H_1b = rF;
			add_H_0a = F_127_5;
			h = add_H_0o;
		end
		3'b110:begin
			//G≥R≥B, B<G
			v = gF;
			//s = F_255 - b/g
			div_S_0a = bF;
			div_S_0b = gF;
			s = sub_S_0o;
			//h = F_42_5 + F_42_5*((g-r)/(g-b))
			sub_H_0a = gF;
			sub_H_0b = rF;
			sub_H_1a = gF;
			sub_H_1b = bF;
			add_H_0a = F_42_5;
			h = add_H_0o;
		end
		3'b111:begin
			//R=G=B
			v = rF;
			//s = 0
			div_S_0a = F_42_5;
			div_S_0b = F_255;
			s = F_0;
			//h = 0
			sub_H_0a = F_42_5;
			sub_H_0b = F_255;
			sub_H_1a = F_42_5;
			sub_H_1b = F_255;
			add_H_0a = F_0;
			h = F_0;
		end
		default:begin
			//impossible
			v = rF;
			//s = 0
			div_S_0a = F_42_5;
			div_S_0b = F_255;
			s = F_0;
			//h = 0
			sub_H_0a = F_42_5;
			sub_H_0b = F_255;
			sub_H_1a = F_42_5;
			sub_H_1b = F_255;
			add_H_0a = F_0;
			h = F_0;
		end
		endcase
	end

	//S pipeline
	reg [31:0] div_S_0a, div_S_0b;
	wire [31:0] div_S_0o;
	FPdiv div_S_0(
	.clock(clk),
	.dataa(div_S_0a),
	.datab(div_S_0b),
	.division_by_zero(),
	.result(div_S_0o));

	wire [31:0] sub_S_0o;
	FPadd sub_S_0(
	.add_sub(1'b0),
	.clock(clk),
	.dataa(F_255),
	.datab(div_S_0o),
	.result(sub_S_0o));

	//H pipeline
	reg [31:0] sub_H_0a, sub_H_0b;
	wire [31:0] sub_H_0o;
	FPadd sub_H_0(
	.add_sub(1'b0),
	.clock(clk),
	.dataa(sub_H_0a),
	.datab(sub_H_0b),
	.result(sub_H_0o));

	reg [31:0] sub_H_1a, sub_H_1b;
	wire [31:0] sub_H_1o;
	FPadd sub_H_1(
	.add_sub(1'b0),
	.clock(clk),
	.dataa(sub_H_1a),
	.datab(sub_H_1b),
	.result(sub_H_1o));

	wire [31:0] div_H_0o;
	FPdiv div_H_0(
	.clock(clk),
	.dataa(sub_H_0o),
	.datab(sub_H_1o),
	.division_by_zero(),
	.result(div_H_0o));

	wire [31:0] mult_H_0o;
	FPmult mult_H_0(
	.clock(clk),
	.dataa(F_42_5),
	.datab(div_H_0o),
	.result(mult_H_0o));

	reg [31:0] add_H_0a;
	wire [31:0] add_H_0o;
	FPadd add_H_0(
	.add_sub(1'b1),
	.clock(clk),
	.dataa(add_H_0a),
	.datab(mult_H_0o),
	.result(add_H_0o));
endmodule // RGB2HSV
