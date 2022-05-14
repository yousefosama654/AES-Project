module Verilog1#(parameter N = 8)(InKey,Round,OutKey);

input  [(32*N)-1:0]  InKey;
output reg [(32*N)-1:0]  OutKey;
input [3:0] Round;

wire [31:0] LastCol;
wire [31:0] FirstCol;
wire [31:0] RCon;
wire [31:0] SubCol;
wire [31:0] newCol;
wire [31:0] Temp;

reg  [(32*N) - 1:0] NewKey;
wire [31:0]         TempColumn;

assign TempColumn = NewKey[128 +: 32];


assign LastCol = InKey[31:0];
assign FirstCol = InKey[(32*N)-1 -: 32];
assign newCol = {LastCol[23:0] , LastCol[31:24]};
//=======================================================================
assign RCon = Round == 1 ? 32'b00000001000000000000000000000000 :
				  Round == 2 ? 32'b00000010000000000000000000000000 :
				  Round == 3 ? 32'b00000100000000000000000000000000 :
				  Round == 4 ? 32'b00001000000000000000000000000000 :
				  Round == 5 ? 32'b00010000000000000000000000000000 :
				  Round == 6 ? 32'b00100000000000000000000000000000 :
				  Round == 7 ? 32'b01000000000000000000000000000000 :
				  Round == 8 ? 32'b10000000000000000000000000000000 :
				  Round == 9 ? 32'b00011011000000000000000000000000 :
				  Round == 10 ? 32'b00110110000000000000000000000000 : 0;
//=======================================================================

SubBytes SB(newCol,SubCol);
SubBytes Column4(TempColumn , Temp);

integer i;
integer j;




always @(InKey)
begin
		NewKey[(32*N) - 1 -: 32] = SubCol ^ RCon ^ FirstCol;
		OutKey[(32*N) - 1 -: 32] = NewKey[(32*N) - 1 -: 32];
		for ( i = (32*N)-33 ; i > 0 ; i = i - 32)
		begin
				if (N == 8 && i == 127)
				begin
						NewKey[i -: 32] = InKey[i -: 32] ^ Temp; 
				end
				else
				begin
						NewKey[i -: 32] = NewKey[i + 32 -: 32] ^ InKey[i -: 32];
				end
				OutKey[i -: 32] = NewKey[i -: 32];
		end
end
endmodule 