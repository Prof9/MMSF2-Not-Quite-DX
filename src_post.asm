.nds

.open TEMP+"/arm9.bin",0x02000000

// Set compressed ARM9 length
.org 0x02000B9C + 0x14
.if filesize(TEMP+"/arm9.bin") != filesize(TEMP+"/arm9.dec")
	.dw	headersize() + filesize(TEMP+"/arm9.bin")
.else
	.dw	0x0
.endif

.close
