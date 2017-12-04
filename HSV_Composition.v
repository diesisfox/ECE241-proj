module HSV_Composition (
	input clk,
	input [31:0] dh, ds, dv,
	input [7:0] r, g, b,
	output [7:0] ro, go, bo
	);

	localparam
	F_0 	= 32'h00000000, // 0/6
	F_42_5 	= 32'h3e2a0000, // 1/6
	F_85 	= 32'h3eaa0000, // 2/6
	F_127_5	= 32'h3eff0000, // 3/6
	F_170 	= 32'h3f2a0000, // 4/6
	F_212_5	= 32'h3f548000, // 5/6
	F_255 	= 32'h3f7f0000; // 6/6

	//setup conversion
	wire [31:0] h, s, v;
	wire [31:0] so, vo;
	reg [31:0] ho;
	wire [9:0] rQ, gQ, bQ;
	RGB2HSV lol0(clk, {2'b0,r}, {2'b0,g}, {2'b0,b}, h, s, v);
	HSV2RGB lol(clk, ho, so, vo, rQ, gQ, bQ);
	assign ro = rQ[7:0];
	assign go = gQ[7:0];
	assign bo = bQ[7:0];

	//add h by dh and modulo by F_255
	wire [31:0] add_H_0o;
	FPadd add_H_0(
		.add_sub(1'b1),
		.clock(clk),
		.dataa(h),
		.datab(dh),
		.result(add_H_0o)
	);
	wire h_overflow;
	FPcomp comp_H_0(
		.clock(clk),
		.dataa(add_H_0o),
		.datab(F_255),
		.agb(h_overflow)
	);
	wire sub_H_0o;
	FPadd sub_H_0(
		.add_sub(1'b0),
		.clock(clk),
		.dataa(add_H_0o),
		.datab(F_255),
		.result(sub_H_0o)
	);
	always@*begin
		if(h_overflow==1'b1) ho = sub_H_0o;
		else ho = add_H_0o;
	end

	//multiply s by ds
	FPmult mult_S_0(
		.clock(clk),
		.dataa(s),
		.datab(ds),
		.result(so)
	);

	//multiply v by dv
	FPmult mult_V_0(
		.clock(clk),
		.dataa(v),
		.datab(dv),
		.result(vo)
	);

endmodule // HSV_Composition
