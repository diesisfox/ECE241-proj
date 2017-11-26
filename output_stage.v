module Output_Stage(
	input clk, clk1mhz, reset,
	input [199:0]inBits,
	output reg [32:0]outBits,
	output reg [7:0]D,
	output reg [4:0]A,
	output reg CS, RW
	);
	reg [7:0]regs[28:0];
	reg [7:0]nextRegs[28:0];
	reg [4:0]addr;
	reg [4:0]nextAddr;

	localparam  maxAddr = 5'd28;

	always@*begin
		addr = 0;
		if(addr >= 5'd0 && addr <= 5'd24)begin //write range
			if(inBits[8*addr +: 8] == regs[addr])begin
				nextAddr = addr+1'b1;
			end
			else begin

			end
		end
		else if(addr >= 5'd25 && addr <= 5'd28)begin //read range

		end
		
		if(nextAddr == maxAddr) nextAddr = 5'b0;
	end
endmodule
