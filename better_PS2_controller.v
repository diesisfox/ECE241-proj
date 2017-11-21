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
		nextBuf = {buffer[9:0],ps2Dat};
		if(!nextBuf[10] && nextBuf[0])begin
			if(nextBuf[1] == ~(^(nextBuf[9:2])))begin
				nextData = {nextBuf[2],nextBuf[3],nextBuf[4],nextBuf[5],nextBuf[6],nextBuf[7],nextBuf[8],nextBuf[9]};
				nextBuf = 11'h7ff;
				dr_n = !dr;
			end
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
