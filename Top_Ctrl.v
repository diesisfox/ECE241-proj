module Top_Ctrl (
	input CLOCK_50,
	inout PS2_CLK, PS2_DAT,
	input [3:0] KEY,
	output [9:0] LEDR,
	output [6:0] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5,
	output [2:0] GPIO_0
	);

	localparam
	F_0 	= 32'h00000000, // 0/6
	F_42_5 	= 32'h3e2a0000, // 1/6
	F_85 	= 32'h3eaa0000, // 2/6
	F_127_5	= 32'h3eff0000, // 3/6
	F_170 	= 32'h3f2a0000, // 4/6
	F_212_5	= 32'h3f548000, // 5/6
	F_255 	= 32'h3f7f0000, // 6/6
	F_1_64	= 32'h3c800000, // 1/64
	F_1 	= 32'h3f800000; // actually 1.0

	//input setup
	wire reset;
	assign reset = ~KEY[0];

	//clock setup
	wire CLOCK_10, CLOCK_100;
	PLL10M PLL10 (CLOCK_50, 1'b0, CLOCK_10);
	PLL100M PLL100 (CLOCK_50, 1'b0, CLOCK_100);

	//keyboard logic
	wire [3:0]animSel;
	wire [127:0] parser_output, e0_parser_output;
	wire [7:0] r,g,b;
	Keyboard_Parser kp0 (
		.clk(CLOCK_10),.reset(reset),
		.ps2_clk(PS2_CLK),.ps2_data(PS2_DAT),
		.key_data(parser_output),.E0_key_data(e0_parser_output)
	);
	RGB_Controller rgbc0 (
		.clk(CLOCK_10),
		.reset(reset),
		.keys(parser_output),
		.e_keys(e0_parser_output),
		.r(r),
		.g(g),
		.b(b),
		.animSel(animSel),
		.hex0(HEX0),
		.hex1(HEX1),
		.hex2(HEX2),
		.hex3(HEX3),
		.hex4(HEX4),
		.hex5(HEX5)
	);
	assign LEDR[3:0] = animSel;

	//rgb signal pipeline
	reg [7:0] rs, gs, bs; 	//values that go into the pipeline
	reg [31:0] dh, ds, dv; 	//values to modify HSV by (float32)
	reg [7:0] dr, dg, db; 	//values to modufy RGB by
	wire [7:0] r1, g1, b1; 	//values coming out of HSV stage and into RGB stage
	wire [7:0] r2, g2, b2; 	//values coming out of RGB stage and into gamma correction
	wire [7:0] ro, go, bo; 	//values coming out of gamma correction and into output signal encoder
	HSV_Composition HSVC0(
		CLOCK_100,
		dh, ds, dv,
		rs, gs, bs,
		r1, g1, b1,
		GPIO_0[2]
	);
	RGB_Composition RGBC0(
		CLOCK_100,
		dr, dg, db,
		r1, g1, b1,
		r2, g2, b2
	);
	Gamma_2_77_LUT GL0(r2,ro);
	Gamma_2_77_LUT GL1(g2,go);
	Gamma_2_77_LUT GL2(b2,bo);

	//output setup
	reg latch, nextLatch;
	wire done;
	LED_Pixel_Encoder LED0(
		.r(ro),.g(go),.b(bo),
		.clk(CLOCK_10),.reset(1'b0),
		.latch(latch),.done(done),
		.data_pin(GPIO_0[0])
	);
	assign GPIO_0[1] = GPIO_0[0];

	//output control
	reg[31:0] fpsCounter, nextFpsCounter;
	reg[9:0] counter, nextCounter;
	reg[7:0] val, nextVal; //increments from 0 to 252 over 64 pixels
	reg[31:0] frac, nextFrac; //increments from 0 to 63/64 over 64 pixels (float32)
	always@(posedge CLOCK_10)begin
		counter <= nextCounter;
		latch <= nextLatch;
		val <= nextVal;
		fpsCounter <= nextFpsCounter;
		frac <= nextFrac;
		case(animSel)
			1:begin //red "random" gradient
				rs <= 8'h00;
				gs <= 8'h00;
				bs <= 8'h00;
				dr <= nextVal;
				dh <= F_0;
				ds <= F_0;
				dv <= F_0;
			end
			2:begin //green "random" gradient
				rs <= 8'h00;
				gs <= 8'h00;
				bs <= 8'h00;
				dg <= nextVal;
				dh <= F_0;
				ds <= F_0;
				dv <= F_0;
			end
			3:begin //blue "random" gradient
				rs <= 8'h00;
				gs <= 8'h00;
				bs <= 8'h00;
				db <= nextVal;
				dh <= F_0;
				ds <= F_0;
				dv <= F_0;
			end
			0: begin //white gradient
				rs <= 8'h00;
				gs <= 8'h00;
				bs <= 8'h00;
				dr <= r;
				dg <= g;
				db <= b;
				dh <= F_0;
				ds <= F_1;
				dv <= F_1;
			end
			4: begin //hue user-defined gradient
				rs <= r;
				gs <= g;
				bs <= b;
				dr <= 0;
				dg <= 0;
				db <= 0;
				dh <= nextFrac;
				ds <= F_1;
				dv <= F_1;
			end
			5: begin //saturation user-defined gradient
				rs <= r;
				gs <= g;
				bs <= b;
				dr <= 0;
				dg <= 0;
				db <= 0;
				dh <= F_0;
				ds <= nextFrac;
				dv <= F_1;
			end
			6: begin //value user-defined gradient
				rs <= r;
				gs <= g;
				bs <= b;
				dr <= 0;
				dg <= 0;
				db <= 0;
				dh <= F_0;
				ds <= F_1;
				dv <= nextFrac;
			end
			7: begin //red user-defined gradient
				rs <= 0;
				gs <= g;
				bs <= b;
				dr <= nextVal;
				dg <= 0;
				db <= 0;
				dh <= F_0;
				ds <= F_1;
				dv <= F_1;
			end
			8: begin //green user-defined gradient
				rs <= r;
				gs <= 0;
				bs <= b;
				dr <= 0;
				dg <= nextVal;
				db <= 0;
				dh <= F_0;
				ds <= F_1;
				dv <= F_1;
			end
			9: begin //blue user-defined gradient
				rs <= r;
				gs <= g;
				bs <= 0;
				dr <= 0;
				dg <= 0;
				db <= nextVal;
				dh <= F_0;
				ds <= F_1;
				dv <= F_1;
			end
			default:begin //solid white
				rs <= 8'h00;
				gs <= 8'h00;
				bs <= 8'h00;
				dr <= 8'hff;
				dg <= 8'hff;
				db <= 8'hff;
				dh <= F_0;
				ds <= F_0;
				dv <= F_0;
			end
		endcase
	end

	always@*begin
		nextCounter = counter;
		nextLatch = latch;
		nextFrac = frac;
		nextVal = val;
		nextFpsCounter = fpsCounter+1;
		if(done)begin
			nextCounter = counter+1;
			nextFrac = add_F_0o;
			nextVal = val+4;
			if(counter == 64)begin
				nextLatch = 1'b1;
			end
			if(latch)begin
				nextCounter = 0;
				if(nextFpsCounter >= 32'd166667/*60fps*/)begin
					nextFpsCounter = 0;
					nextLatch = 1'b0;
					nextVal = 0;
					nextFrac = F_0;
				end
			end
		end
	end

	wire [31:0] add_F_0o;
	FPadd add_F_0(
		.add_sub(1'b1),
		.clock(CLOCK_100),
		.dataa(frac),
		.datab(F_1_64),
		.result(add_F_0o)
	);

endmodule // Top_Ctrl
