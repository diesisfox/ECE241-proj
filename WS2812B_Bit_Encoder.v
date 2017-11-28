module WS2812B_Bit_Encoder (
	input clk, reset, d, r,
	output reg next, out
	);

	localparam //timing
	T1H 	= 35, //35 cycles, 700 ns
	T1L 	= 30, //30 cycles, 600 ns
	T0H 	= 20, //20 cycles, 400 ns
	T0L 	= 30, //30 cycles, 600 ns
	TRST 	= 350; //350 cycles, 7000 ns

	localparam //states
	S_1H 	= 0,
	S_1L 	= 1,
	S_0H	= 2,
	S_0L	= 3,
	S_R		= 4;

	reg [15:0] counter, nextCounter, comp;
	reg [2:0] state, nextState;
	reg nextOut, nextNext;

	//transition logic
	always@(posedge clk)begin
		counter <= nextCounter;
		out <= nextOut; //NOTE: consider handling {out} in output logic
		next <= nextNext;
		state <= nextState;
	end

	//state table
	always@*begin
		if(reset)begin
			nextOut = 1'b0;
			nextNext = 1'b0;
			nextCounter = 15'b0;
			nextState = S_R;
		end
		else begin
			nextCounter = counter+1;
			case(state)
				S_1H:begin
					if(nextCounter >= T1H)begin
						nextState = T1L;
						nextCounter = 0;
					end
				end
				S_1L:begin
					//TODO
				end
				S_0H:begin
					if(nextCounter >= T0H)begin
						nextState = T0L;
						nextCounter = 0;
					end
				end
				S_0L:begin
					//TODO
				end
				S_R:begin
					//TODO
				end
				default: nextState = S_R;
			endcase
		end
	end

	//output logic
	always@*begin
		case(state)
			S_1H: comp = T1H;
			S_1L: comp = T1L;
			S_0H: comp = T0H;
			S_0L: comp = T0L;
			S_R: comp = TRST;
			default: comp = TRST;
		endcase
	end
endmodule // WS2812B_Bit_Encoder
