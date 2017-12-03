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

	always@*begin
		case({GgeR,RgeB,BgeG})
		3'b001:begin
			//B>R>G
			v = bF;
		end
		3'b010:begin
			//R>G>B
			v = rF;
		end
		3'b011:begin
			//R≥B≥G, G<R
			v = rF;
		end
		3'b100:begin
			//G>B>R
			v = gF;
		end
		3'b101:begin
			//B≥G≥R, R<B
			v = bF;
		end
		3'b110:begin
			//G≥R≥B, B<G
			v = gF;
		end
		3'b111:begin
			//R=G=B
			v = rF;
			s = F_0;
			h = F_0;
		end
		default:begin
			//impossible
		end
		endcase
	end
endmodule // RGB2HSV
