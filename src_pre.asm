.nds

// Trim ARM9 binary
.create TEMP+"/arm9.dec",0
.import TEMP+"/arm9.bin",0,readu32(TEMP+"/header.bin",0x2C)
.close
