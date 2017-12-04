module HSV2RGB (
	input clk,
	input [31:0] h, s, v,
	output [7:0] r, g, b
	);

	reg [31:0] rF, gF, bF;
	wire [9:0] rQ, gQ, bQ;
	assign r = rQ[7:0], g = gQ[7:0], b = bQ[7:0];

	localparam
	F_0 	= 32'h00000000, // 0/6
	F_42_5 	= 32'h3e2a0000, // 1/6
	F_85 	= 32'h3eaa0000, // 2/6
	F_127_5	= 32'h3eff0000, // 3/6
	F_170 	= 32'h3f2a0000, // 4/6
	F_212_5	= 32'h3f548000, // 5/6
	F_255 	= 32'h3f7f0000; // 6/6

	//cast float to fixed then extract fraction
	FPconv_F32_to_Q2_8 convQ_r(
		.clock(clk),
		.dataa(rF),
		.result(rQ)
	);
	FPconv_F32_to_Q2_8 convQ_g(
		.clock(clk),
		.dataa(gF),
		.result(gQ)
	);
	FPconv_F32_to_Q2_8 convQ_b(
		.clock(clk),
		.dataa(bF),
		.result(bQ)
	);
	assign r = rQ[7:0], g = gQ[7:0], b = bQ[7:0];

	//determine h range
	wire le1, le2, le3, le4, le5, le6;
	FPcomp le1_comp(
		.clock(clk),
		.dataa(h),
		.datab(F_42_5),
		.aleb(le1)
	);
	FPcomp le2_comp(
		.clock(clk),
		.dataa(h),
		.datab(F_85),
		.aleb(le2)
	);
	FPcomp le3_comp(
		.clock(clk),
		.dataa(h),
		.datab(F_127_5),
		.aleb(le3)
	);
	FPcomp le4_comp(
		.clock(clk),
		.dataa(h),
		.datab(F_170),
		.aleb(le4)
	);
	FPcomp le5_comp(
		.clock(clk),
		.dataa(h),
		.datab(F_212_5),
		.aleb(le5)
	);
	FPcomp le6_comp(
		.clock(clk),
		.dataa(h),
		.datab(F_255),
		.aleb(le6)
	);

	//formula
	always@*begin
		if(le1)begin
			//0° < h ≤ 60°
			//r = v
			//b = v-vs
			//g = v - vs(F_42_5 - h)/F_42_5 [4s,5o][√] = (v-(vs)) + ((vs)(h/F_42_5)) [3s,5o] = v(1-s(1+h/F_42_5)) [5s,5o]
			rF = v;
			bF = sub_N_0o;
			gF = sub_D_1o;
			sub_D_0a = F_42_5;
			sub_D_0b = h;
		end
		else if(le2)begin
			//60° < h ≤ 120°
			//g = v
			//b = v-vs
			//r = v - vs(h - F_42_5)/F_42_5
			gF = v;
			bF = sub_N_0o;
			rF = sub_D_1o;
			sub_D_0a = h;
			sub_D_0b = F_42_5;
		end
		else if(le3)begin
			//120° < h ≤ 180°
			//g = v
			//r = v-vs
			//b = v - vs(F_127_5 - h)/F_42_5
			gF = v;
			rF = sub_N_0o;
			bF = sub_D_1o;
			sub_D_0a = F_127_5;
			sub_D_0b = h;
		end
		else if(le4)begin
			//180° < h ≤ 240°
			//b = v
			//r = v-vs
			//g = v - vs(h - F_127_5)/F_42_5
			bF = v;
			rF = sub_N_0o;
			gF = sub_D_1o;
			sub_D_0a = h;
			sub_D_0b = F_127_5;
		end
		else if(le5)begin
			//240° < h ≤ 300°
			//b = v
			//g = v-vs
			//r = v - vs(F_212_5 - h)/F_42_5
			bF = v;
			gF = sub_N_0o;
			rF = sub_D_1o;
			sub_D_0a = F_212_5;
			sub_D_0b = h;
		end
		else if(le6)begin
			//300° < h ≤ 360°
			//r = v
			//g = v-vs
			//b = v - vs(h - F_212_5)/F_42_5
			rF = v;
			gF = sub_N_0o;
			bF = sub_D_1o;
			sub_D_0a = h;
			sub_D_0b = F_212_5;
		end
		else begin
			//impossible
			//#000000
			rF = F_0;
			gF = F_0;
			bF = F_0;
			sub_D_0a = F_0;
			sub_D_0b = F_0;
		end
	end

	//RGBmin pipeline
	wire [31:0] mult_N_0o;
	FPmult mult_N_0(
		.clock(clk),
		.dataa(v),
		.datab(s),
		.result(mult_N_0o)
	);
	wire [31:0] sub_N_0o;
	FPadd sub_N_0(
		.add_sub(1'b0),
		.clock(clk),
		.dataa(v),
		.datab(mult_N_0o),
		.result(sub_N_0o)
	);

	//RGBmid pipeline
	reg [31:0] sub_D_0a, sub_D_0b;
	wire [31:0] sub_D_0o;
	FPadd sub_D_0(
		.add_sub(1'b0),
		.clock(clk),
		.dataa(sub_D_0a),
		.datab(sub_D_0b),
		.result(sub_D_0o)
	);
	wire [31:0] div_D_0o;
	FPdiv div_D_0(
		.clock(clk),
		.dataa(sub_D_0o),
		.datab(F_42_5),
		.division_by_zero(),
		.result(div_D_0o)
	);
	wire [31:0] mult_D_0o;
	FPmult mult_D_0(
		.clock(clk),
		.dataa(mult_N_0o),
		.datab(div_D_0o),
		.result(mult_D_0o)
	);
	wire [31:0] sub_D_1o;
	FPadd sub_D_1(
		.add_sub(1'b0),
		.clock(clk),
		.dataa(v),
		.datab(mult_D_0o),
		.result(sub_D_1o)
	);
endmodule // HSV2RGB
