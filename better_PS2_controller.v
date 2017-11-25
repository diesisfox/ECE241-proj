module topLevel (CLOCK_50, PS2_CLK, PS2_DATA, HEX0, HEX1);
	input CLOCK_50, PS2_CLK, PS2_DATA;
	output [6:0] HEX0, HEX1;

	reg [7:0] controllerOUT;

	Better_PS2_controller bc0 (.clk(CLOCK_50),.ps2Clk(PS2_CLK),.ps2Dat(PS2_DATA),.data(controllerOUT));
	hex_decoder h0 (.in(controllerOUT[3:0]),.out(HEX0));
	hex_decoder h1 (.in(controllerOUT[7:4]),.out(HEX1));
endmodule

module Better_PS2_controller (
	input clk, ps2Clk, ps2Dat,
	output reg ready,
	output reg [7:0] data
	);
	reg [10:0] buffer,nextBuf;
	reg [7:0] nextData;
	reg dr, dr_c, dr_n;
	//next buffer logic
	always@*begin
		dr_n = dr;
		nextData = data;
		nextBuf = {ps2Dat,buffer[10:1]};
		if(!nextBuf[0] && nextBuf[10] && nextBuf[9]==~(^(nextBuf[8:1])))begin
			nextData = nextBuf[8:1];
			nextBuf = 11'h7ff;
			dr_n = !dr;
		end
	end
	//state transition logic
	always@(negedge ps2Clk)begin
		buffer <= nextBuf;
		data <= nextData;
		dr <= dr_n;
	end
	//data ready generator
	always@(posedge clk)begin
		if(!ready) ready <= dr^dr_c;
		else begin
			dr_c <= !dr_c;
			ready <= 1'b0;
		end
	end
endmodule // Better_PS2_controller
