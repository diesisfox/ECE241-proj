

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
	S_1H 	= 4,
	S_1L 	= 1,
	S_0H	= 2,
	S_0L	= 3,
	S_R		= 0;

	reg [15:0] counter, nextCounter, comp;
	reg [2:0] state, nextState;
	reg nextNext;

	//transition logic
	always@(posedge clk)begin
		counter <= nextCounter;
		next <= nextNext;
		state <= nextState;
	end

	//state table
	always@*begin
		if(reset)begin
			nextCounter = 15'b0;
			nextState = S_R;
		end
		else begin
			nextCounter = counter+1;
			case(state) //NOTE: could compact to if else tree
				S_1H:begin
					if(nextCounter >= comp)begin
						nextState = S_1L;
						nextCounter = 0;
					end
				end
				S_1L:begin
					if(nextCounter >= comp)begin
						if(r) nextState = S_R;
						else if(d) nextState = S_1H;
						else nextState = S_0H;
						nextCounter = 0;
					end
				end
				S_0H:begin
					if(nextCounter >= comp)begin
						nextState = S_0L;
						nextCounter = 0;
					end
				end
				S_0L:begin
					if(nextCounter >= comp)begin
						if(r) nextState = S_R;
						else if(d) nextState = S_1H;
						else nextState = S_0H;
						nextCounter = 0;
					end
				end
				S_R:begin
					if(nextCounter >= comp)begin
						if(r) nextState = S_R;
						else if(d) nextState = S_1H;
						else nextState = S_0H;
						nextCounter = 0;
					end
				end
				default: nextState = S_R;
			endcase
		end
	end

	//output logic
	always@*begin
		comp = TRST;
		out = 1'b0;
		nextNext = 1'b0;
		if(!reset)begin
			case(state)
				S_1H:begin
					comp = T1H;
					out = 1'b1;
					if(counter==0) nextNext = 1'b1;
				end
				S_1L: comp = T1L;
				S_0H:begin
					comp = T0H;
					out = 1'b1;
					if(counter==0) nextNext = 1'b1;
				end
				S_0L: comp = T0L;
				S_R: if(counter==0) nextNext = 1'b1;
			endcase
		end
	end
endmodule // WS2812B_Bit_Encoder
