module ledTest (
	input CLOCK_50,
	input [0:0]KEY,
	output [35:0]GPIO_0
	);

	reg [24:0]ds, rs;
	wire next, out, reset, CLOCK_10;

	assign GPIO_0[0] = out;
	assign GPIO_0[1] = out;
	assign GPIO_0[2] = next;
	assign GPIO_0[3] = CLOCK_10;
	assign GPIO_0[4] = reset;
	assign reset = KEY[0];

	PLL10M P1M0(CLOCK_50, 0, CLOCK_10);

	WS2812B_Bit_Encoder BE0(CLOCK_10, reset, ds[0], rs[0], next, out);

	always@(posedge CLOCK_10)begin
		if(reset)begin
			ds <= 25'h0cdff98;
			rs <= 25'h0000001;
		end
		else if(next)begin
			ds <= ds>>1;
			rs <= 25'h1000000 | rs>>1;
		end
	end

endmodule // ledTest
