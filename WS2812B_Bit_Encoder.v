

module WS2812B_Bit_Encoder (
	input clk, reset, d, r,
	output reg next, out
	);

	localparam //timing ALL DIVIDED BY 5
	T1H 	= 16'd8, //40 cycles, 800 ns
	T1L 	= 16'd3, //15 cycles, 300 ns
	T0H 	= 16'd3, //15 cycles, 300 ns
	T0L 	= 16'd8, //40 cycles, 800 ns
	TRST 	= 16'd500; //2500 cycles, 50000 ns

	localparam //states
	S_1H 	= 3'd4,
	S_1L 	= 3'd1,
	S_0H	= 3'd2,
	S_0L	= 3'd3,
	S_R		= 3'd0;

	reg [15:0] counter, nextCounter, comp;
	reg [2:0] state, nextState;
	reg counterEnd;

	//transition logic
	always@(posedge clk)begin
		counter <= nextCounter;
		state <= nextState;
	end

	//state table
	always@*begin
		if(reset) nextState = S_R;
		else begin
			case(state) //NOTE: could compact to if else tree
				S_1H:begin
					if(counterEnd) nextState = S_1L;
					else nextState = S_1H;
				end
				S_1L:begin
					if(counterEnd)begin
						if(r) nextState = S_R;
						else if(d) nextState = S_1H;
						else nextState = S_0H;
					end
					else nextState = S_1L;
				end
				S_0H:begin
					if(counterEnd) nextState = S_0L;
					else nextState = S_0H;
				end
				S_0L:begin
					if(counterEnd)begin
						if(r) nextState = S_R;
						else if(d) nextState = S_1H;
						else nextState = S_0H;
					end
					else nextState = S_0L;
				end
				S_R:begin
					if(counterEnd)begin
						if(r) nextState = S_R;
						else if(d) nextState = S_1H;
						else nextState = S_0H;
					end
					else nextState = S_R;
				end
				default: nextState = S_R;
			endcase
		end
	end

	//output logic
	always@*begin
		out = 1'b0;
		next = 1'b0;
		if(!reset)begin
			case(state)
				S_1H:begin
					out = 1'b1;
					if(counter==0) next = 1'b1;
				end
				S_1L:begin
				end
				S_0H:begin
					out = 1'b1;
					if(counter==0) next = 1'b1;
				end
				S_0L:begin
				end
				S_R:begin
					if(counter==0) next = 1'b1;
				end
			endcase
		end
	end

	//data path
	always@*begin
		comp = TRST;
		nextCounter = counter+1;
		counterEnd = 0;
		if(reset)begin
			nextCounter = 0;
		end
		else begin
			case(state)
				S_1H:begin
					comp = T1H;
				end
				S_1L:begin
					comp = T1L;
				end
				S_0H:begin
					comp = T0H;
				end
				S_0L:begin
					comp = T0L;
				end
				S_R:begin
					comp = TRST;
				end
				default:
					comp = TRST;
			endcase

			if(nextCounter >= comp)begin
				counterEnd = 1;
				nextCounter = 0;
			end
			else begin
				counterEnd = 0;
			end
		end
	end
endmodule // WS2812B_Bit_Encoder
