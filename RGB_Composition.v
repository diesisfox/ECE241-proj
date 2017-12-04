module RGB_Composition (
	input clk,
	input [7:0] dr, dg, db,
	input [7:0] r, g, b,
	output [7:0] ro, go, bo
	);

	//add r by dr and clamp
	wire [8:0] r1 = r + dr;
	assign ro = (r1>8'hff)?8'hff:r1;

	//add g by dg and clamp
	wire [8:0] g1 = g + dg;
	assign go = (g1>8'hff)?8'hff:g1;

	//add b by db and clamp
	wire [8:0] b1 = b + db;
	assign bo = (b1>8'hff)?8'hff:b1;

endmodule // RGB_Composition
