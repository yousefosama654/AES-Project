
module AES(Text, Key, Nk, Encryption, Decryption);

input  [127:0] Text;
input  [256:0] Key;
input  [3:0]   Nk;
output [127:0] Encryption;
output [127:0] Decryption;

wire [127:0] Key4;
wire [192:0] Key6;
wire [255:0] Key8;

assign Key4 = Key[127:0];
assign Key6 = Key[191:0];
assign Key8 = Key[255:0];

wire [127:0] EOut4;
wire [127:0] EOut6;
wire [127:0] EOut8;
wire [127:0] DOut4;
wire [127:0] DOut6;
wire [127:0] DOut8;

EncryptNK4    E4 (Text,Key4,EOut4);
EncryptNK6    E6 (Text,Key6,EOut6);
EncryptNK8    E8 (Text,Key8,EOut8);

DecryptNK4 D4 (EOut4,Key4,DOut4);
DecryptNK6 D6 (EOut6,Key6,DOut6);
DecryptNK8 D8 (EOut8,Key8,DOut8);


assign Encryption = Nk == 4 ? EOut4 :
						  Nk == 6 ? EOut6 : EOut8;
						  
assign Decryption = Nk == 4 ? DOut4 :
						  Nk == 6 ? DOut6 : DOut8;

endmodule 
