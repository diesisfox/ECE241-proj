module pixelIncTest (
	input CLOCK_50,
	input [3:0] KEY,
	output [0:0]GPIO_0
	);

	//set up clock
	wire CLOCK_10;

	//set up LEDs
	reg [7:0] r,g,b;
	wire [7:0] rY,gY,bY;
	reg latch, nextLatch;
	wire done;
	PLL10M pll0(CLOCK_50,1'b0,CLOCK_10);
	Gamma_2_77_LUT GL0(r,rY);
	Gamma_2_77_LUT GL1(g,gY);
	Gamma_2_77_LUT GL2(b,bY);
	LED_Pixel_Encoder LED0(.r(rY),.g(gY),.b(bY),.clk(CLOCK_10),.reset(1'b0),.latch(latch),.done(done),.data_pin(GPIO_0[0]));

	//data generator
	reg[1:0] sel;
	reg[7:0] val, nextVal;
	reg[9:0] counter, nextCounter;

	always@(posedge CLOCK_10)begin
		counter <= nextCounter;
		latch <= nextLatch;
		val <= nextVal;
		case(sel)
			1: r <= nextVal;
			2: g <= nextVal;
			3: b <= nextVal;
			0: begin
				r <= nextVal;
				g <= nextVal;
				b <= nextVal;
			end
			default:
				g <= nextVal;
		endcase
	end

	always@*begin
		nextCounter = counter;
		nextLatch = latch;
		nextVal = val;
		if(done)begin
			nextCounter = counter+1;
			nextVal = val+4;
			if(counter == 64)begin
				nextLatch = 1'b1;
			end
			if(latch)begin
				nextLatch = 1'b0;
				nextCounter = 0;
				nextVal = 0;
			end
		end
	end

	always@*begin
		if(!KEY[0])sel = 0;
		if(!KEY[1])sel = 1;
		if(!KEY[2])sel = 2;
		if((!KEY[3]))sel = 3;
	end
endmodule // pixelIncTest
