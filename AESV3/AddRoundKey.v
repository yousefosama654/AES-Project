module AddRoundKey(input [127:0]a,input [127:0]b,output reg [127:0]out);
	integer c =0;
	always @ (a or b)
	begin
		for (c=0;c<4;c=c+1)
		begin
			out[(31+32*c)-:8] = a[(31+32*c)-:8] ^ b[(31+32*c)-:8];
			out[(23+32*c)-:8] = a[(23+32*c)-:8] ^ b[(23+32*c)-:8];
			out[(15+32*c)-:8] = a[(15+32*c)-:8] ^ b[(15+32*c)-:8];
			out[(7+32*c)-:8] = a[(7+32*c)-:8] ^ b[(7+32*c)-:8];
		end
	end
endmodule 