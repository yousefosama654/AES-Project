
module AES(Word,Nk,Clk,Out2,CurrentState);
input [7:0] Word;
input Clk;

reg [127:0] PlainText4;
reg [127:0] PlainText6;
reg [127:0] PlainText8;


reg [127:0] Key4;
reg [192:0] Key6;
reg [255:0] Key8;

wire [127:0] Out4;
wire [127:0] Out6;
wire [127:0] Out8;

input [3:0] Nk;
output [127:0] Out2;
output[127:0] CurrentState;

assign CurrentState = PlainText4;

integer i;
initial i = 127;
integer j;
initial j = 0;
EncryptNK4 KG4 (PlainText4,Key4,Out4);
EncryptNK6 KG6 (PlainText6,Key6,Out6);
EncryptNK8 KG8 (PlainText8,Key8,Out8);

initial 
begin
//		PlainText4 = 128'h00112233445566778899aabbccddeeff;
		PlainText6 = 128'h00112233445566778899aabbccddeeff;
		PlainText8 = 128'h00112233445566778899aabbccddeeff;
		Key4 =       128'h000102030405060708090a0b0c0d0e0f;
		Key6 =       192'h000102030405060708090a0b0c0d0e0f1011121314151617;
		Key8 =       256'h000102030405060708090a0b0c0d0e0f101112131415161718191a1b1c1d1e1f;
end

always @(posedge Clk)
begin
		for (j = 0; j < 8 ; j = j+1)
		begin
				PlainText4[i] = Word[7-j];
				i = i - 1;
		end
		j = 0;
end


assign Out2 = Out4;
//				  Nk == 6 ? Out6 :
//				  Nk == 8 ? Out8 : 256'hz;


endmodule 