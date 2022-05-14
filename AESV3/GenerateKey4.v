module GenerateKey4(InKey,Round,OutKey);

input  [127:0]  InKey;
input  [3:0]    Round;
output [127:0]  OutKey;

wire [31:0] LastCol;
wire [31:0] FirstCol;
wire [31:0] RCon;
wire [31:0] SubCol;
wire [31:0] newCol;

//-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

assign LastCol = InKey[31:0];
assign FirstCol = InKey[127:96];

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


assign newCol = {LastCol[23:0] , LastCol[31:24]};


SubBytes SB(newCol,SubCol);

//-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

assign OutKey[127:96] = SubCol ^ FirstCol ^ RCon;
assign OutKey[95:64] = InKey[95:64] ^ OutKey[127:96];
assign OutKey[63:32] = InKey[63:32] ^ OutKey[95:64];
assign OutKey[31:0] = InKey[31:0] ^ OutKey[63:32];


endmodule 

//==========================================================================================

module KeysGeneration4 (OriginalKey , OutKeys);

input  [127 :0] OriginalKey;
output [1407:0] OutKeys;

//-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

wire [127:0] Key[9:0];

//-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

GenerateKey4 K1   (OriginalKey,1, Key[0]);
GenerateKey4 K2   (Key[0],     2, Key[1]);
GenerateKey4 K3   (Key[1],     3, Key[2]);
GenerateKey4 K4   (Key[2],     4, Key[3]);
GenerateKey4 K5   (Key[3],     5, Key[4]);
GenerateKey4 K6   (Key[4],     6, Key[5]);
GenerateKey4 K7   (Key[5],     7, Key[6]); 
GenerateKey4 K8   (Key[6],     8, Key[7]);
GenerateKey4 K9   (Key[7],     9, Key[8]);
GenerateKey4 K10  (Key[8],     10,Key[9]);


//-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

assign OutKeys[1407 : 1280] = OriginalKey;
assign OutKeys[1279:1152] = Key[0];
assign OutKeys[1151:1024] = Key[1];
assign OutKeys[1023:896]  = Key[2];
assign OutKeys[895:768]   = Key[3];
assign OutKeys[767:640]   = Key[4];
assign OutKeys[639:512]   = Key[5];
assign OutKeys[511:384]   = Key[6];
assign OutKeys[383:256]   = Key[7];
assign OutKeys[255:128]   = Key[8];
assign OutKeys[127:0]     = Key[9];
endmodule  

//==========================================================================================

module EncryptNK4 (PlainText,Key,Encryption,Clk);

input  [127:0] PlainText;
input  [127:0] Key;
input          Clk;
output [127:0] Encryption;

wire [1407:0] WorkingKeys;
wire [127:0] Keys  [9:0 ];
wire [127:0] XOR   [10:0];
wire [127:0] Sub   [9:0 ];
wire [127:0] Shift [9:0 ];
wire [127:0] Mix   [8:0 ];


KeysGeneration4 KG4 (Key,WorkingKeys);

assign Keys[0] =  WorkingKeys[1279:1152];
assign Keys[1] =  WorkingKeys[1151:1024];
assign Keys[2] =  WorkingKeys[1023:896 ];
assign Keys[3] =  WorkingKeys[895:768  ];
assign Keys[4] =  WorkingKeys[767:640  ];
assign Keys[5] =  WorkingKeys[639:512  ];
assign Keys[6] =  WorkingKeys[511:384  ];
assign Keys[7] =  WorkingKeys[383:256  ];
assign Keys[8] =  WorkingKeys[255:128  ];
assign Keys[9] =  WorkingKeys[127:0    ];




// Pre-Rounds
AddRoundKey ARK0 (PlainText,Key,XOR[0]);
//==========================================
//Round 1
FullSubBytes S1(XOR[0] , Sub[0]);
ShiftRows Sh1(Sub[0],Shift[0]);
MixColumns MC1(Shift[0],Mix[0]);
AddRoundKey ARK1(Mix[0],Keys[0],XOR[1]);
//==========================================
//Round 2
FullSubBytes S2(XOR[1] , Sub[1]);
ShiftRows Sh2(Sub[1],Shift[1]);
MixColumns MC2(Shift[1],Mix[1]);
AddRoundKey ARK2(Mix[1],Keys[1],XOR[2]);
//==========================================
//Round 3
FullSubBytes S3(XOR[2] , Sub[2]);
ShiftRows Sh3(Sub[2],Shift[2]);
MixColumns MC3(Shift[2],Mix[2]);
AddRoundKey ARK3(Mix[2],Keys[2],XOR[3]);
//==========================================
//Round 4
FullSubBytes S4(XOR[3] , Sub[3]);
ShiftRows Sh4(Sub[3],Shift[3]);
MixColumns MC4(Shift[3],Mix[3]);
AddRoundKey ARK4(Mix[3],Keys[3],XOR[4]);
//==========================================
//Round 5
FullSubBytes S5(XOR[4] , Sub[4]);
ShiftRows Sh5(Sub[4],Shift[4]);
MixColumns MC5(Shift[4],Mix[4]);
AddRoundKey ARK5(Mix[4],Keys[4],XOR[5]);
//==========================================
//Round 6
FullSubBytes S6(XOR[5] , Sub[5]);
ShiftRows Sh6(Sub[5],Shift[5]);
MixColumns MC6(Shift[5],Mix[5]);
AddRoundKey ARK6(Mix[5],Keys[5],XOR[6]);
//==========================================
//Round 7
FullSubBytes S7(XOR[6] , Sub[6]);
ShiftRows Sh7(Sub[6],Shift[6]);
MixColumns MC7(Shift[6],Mix[6]);
AddRoundKey ARK7(Mix[6],Keys[6],XOR[7]);
//==========================================
//Round 8
FullSubBytes S8(XOR[7] , Sub[7]);
ShiftRows Sh8(Sub[7],Shift[7]);
MixColumns MC8(Shift[7],Mix[7]);
AddRoundKey ARK8(Mix[7],Keys[7],XOR[8]);
//==========================================
//Round 9
FullSubBytes S9(XOR[8] , Sub[8]);
ShiftRows Sh9(Sub[8],Shift[8]);
MixColumns MC9(Shift[8],Mix[8]);
AddRoundKey ARK9(Mix[8],Keys[8],XOR[9]);
//==========================================
//Round 10
FullSubBytes S10(XOR[9] , Sub[9]);
ShiftRows Sh10(Sub[9],Shift[9]);
AddRoundKey ARK10(Shift[9],Keys[9],XOR[10]);

assign Encryption = XOR[10];
endmodule
//-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-_-

module DecryptNK4 (PlainText,Key,Decryption);

input  [127:0] PlainText;
input  [127:0] Key;
output [127:0] Decryption;

wire [1407:0] WorkingKeys;
wire [127:0] Keys  [9:0];
wire [127:0] XOR   [10:0];
wire [127:0] Sub   [9:0 ];
wire [127:0] Shift [9:0 ];
wire [127:0] Mix   [8:0 ];


KeysGeneration4 KG4 (Key,WorkingKeys);


assign Keys[9]  =  WorkingKeys[1279:1152];
assign Keys[8]  =  WorkingKeys[1151:1024];
assign Keys[7]  =  WorkingKeys[1023:896 ];
assign Keys[6]  =  WorkingKeys[895:768  ];
assign Keys[5]  =  WorkingKeys[767:640  ];
assign Keys[4]  =  WorkingKeys[639:512  ];
assign Keys[3]  =  WorkingKeys[511:384  ];
assign Keys[2]  =  WorkingKeys[383:256  ];
assign Keys[1]  =  WorkingKeys[255:128  ];
assign Keys[0]  =  WorkingKeys[127:0    ];



// Pre-Rounds
AddRoundKey ARK0 (PlainText,Keys[0],XOR[0]);
//==========================================
//Round 1
InvShiftRows Sh1(XOR[0],Shift[0]);
Inv_Full_SubBytes S1(Shift[0] , Sub[0]);
AddRoundKey ARK1(Sub[0],Keys[1],XOR[1]);
inverse_mix_columns MC1(XOR[1],Mix[0]);
//==========================================
//Round 2
InvShiftRows Sh2(Mix[0],Shift[1]);
Inv_Full_SubBytes S2(Shift[1] , Sub[1]);
AddRoundKey ARK2(Sub[1],Keys[2],XOR[2]);
inverse_mix_columns MC2(XOR[2],Mix[1]);
//==========================================
//Round 3
InvShiftRows Sh3(Mix[1],Shift[2]);
Inv_Full_SubBytes S3(Shift[2] , Sub[2]);
AddRoundKey ARK3(Sub[2],Keys[3],XOR[3]);
inverse_mix_columns MC3(XOR[3],Mix[2]);
//==========================================
//Round 4
InvShiftRows Sh4(Mix[2],Shift[3]);
Inv_Full_SubBytes S4(Shift[3] , Sub[3]);
AddRoundKey ARK4(Sub[3],Keys[4],XOR[4]);
inverse_mix_columns MC4(XOR[4],Mix[3]);
//==========================================
//Round 5
InvShiftRows Sh5(Mix[3],Shift[4]);
Inv_Full_SubBytes S5(Shift[4] , Sub[4]);
AddRoundKey ARK5(Sub[4],Keys[5],XOR[5]);
inverse_mix_columns MC5(XOR[5],Mix[4]);
//==========================================
//Round 6
InvShiftRows Sh6(Mix[4],Shift[5]);
Inv_Full_SubBytes S6(Shift[5] , Sub[5]);
AddRoundKey ARK6(Sub[5],Keys[6],XOR[6]);
inverse_mix_columns MC6(XOR[6],Mix[5]);
//==========================================
//Round 7
InvShiftRows Sh7(Mix[5],Shift[6]);
Inv_Full_SubBytes S7(Shift[6] , Sub[6]);
AddRoundKey ARK7(Sub[6],Keys[7],XOR[7]);
inverse_mix_columns MC7(XOR[7],Mix[6]);
//==========================================
//Round 8
InvShiftRows Sh8(Mix[6],Shift[7]);
Inv_Full_SubBytes S8(Shift[7] , Sub[7]);
AddRoundKey ARK8(Sub[7],Keys[8],XOR[8]);
inverse_mix_columns MC8(XOR[8],Mix[7]);
//==========================================
//Round 9
InvShiftRows Sh9(Mix[7],Shift[8]);
Inv_Full_SubBytes S9(Shift[8] , Sub[8]);
AddRoundKey ARK9(Sub[8],Keys[9],XOR[9]);
inverse_mix_columns MC9(XOR[9],Mix[8]);
//==========================================
//Round 10
InvShiftRows Sh10(Mix[8],Shift[9]);
Inv_Full_SubBytes S10(Shift[9] , Sub[9]);
AddRoundKey ARK10(Sub[9],Key,XOR[10]);
//==========================================

assign Decryption=XOR[10];

endmodule 