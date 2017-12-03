module ledTest (
	input CLOCK_50,
	input [0:0]KEY,
	output [35:0]GPIO_0
	);

	reg [192:0]ds, rs;
	wire next, out, reset, CLOCK_10;

	assign GPIO_0[0] = out;
	assign GPIO_0[1] = out;
	assign GPIO_0[2] = next;
	assign GPIO_0[3] = CLOCK_10;
	assign GPIO_0[4] = reset;
	assign reset = KEY[0];

	PLL10M P1M0(CLOCK_50, 0, CLOCK_10);

	WS2812B_Bit_Encoder BE0(CLOCK_10, reset, ds[192], rs[192], next, out);

	always@(posedge CLOCK_10)begin
		if(reset)begin
			//#66ccff #66ffcc #cc66ff #ff66cc #ffcc66 #ccff66 #ff6666 #66ff66
			ds <= 193'h0cc66ffff66cc66ccff66ffccccff66ffcc6666ff66ff6666;
			rs <= 193'h1000000000000000000000001000000000000000000000000;
		end
		else if(next)begin
			ds <= ds<<1;
			rs <= 1 | rs<<1;
		end
	end

endmodule // ledTest
