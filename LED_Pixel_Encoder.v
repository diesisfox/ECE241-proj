module LED_Pixel_Encoder (
	input [7:0] r,g,b,
	input clk, reset, latch,
	output reg done,
	output wire data_pin
	);

	reg [23:0]bitStream, nextBitStream;
	reg [4:0]counter, nextCounter;
	reg bitR, nextBitR, nextDone;
	wire next;

	WS2812B_Bit_Encoder WBE0(.clk(clk),.reset(reset),.d(bitStream[23]),.r(bitR),.next(next),.out(data_pin));

	always@(posedge clk)begin
		if(reset)begin
			counter <= 5'b0;
			bitStream <= 24'b0;
			bitR <= 1'b1;
			done <= 1'b0;
		end
		else begin
			counter <= nextCounter;
			bitStream <= nextBitStream;
			bitR <= nextBitR;
			done <= nextDone;
		end
	end

	always@*begin
		nextCounter = counter;
		nextBitStream = bitStream;
		nextBitR = bitR;
		nextDone = 1'b0;
		if(next)begin
			nextCounter = counter+1;
			nextBitStream = bitStream<<1;
			if(nextCounter >= 5'd24)begin
				nextCounter = 5'd0;
				nextDone = 1'b1;
				nextBitStream = {g,r,b};
				if(latch)begin
					nextBitR = 1'b1;
					nextCounter = 5'd23;
				end
				else nextBitR = 1'b0;
			end
		end
	end
endmodule // LED_Pixel_Encoder
