@archive mess_0486
@size 256

script 45 mmsf2 {
	msgOpen
	mugshotShow
		mugshot = LegendaryMasterShin
	"""
	I am Legendary
	Master Shin!
	"""
	keyWait1
	clearMsg
	"""
	I sanction the splendid
	things in this world as
	"Legendary"!
	"""
	keyWait1
	clearMsg
	checkFlag
		flag = 0x1076
		jumpIfTrue = 47
		jumpIfFalse = continue
	checkFlag
		flag = 0x900
		jumpIfTrue = continue
		jumpIfFalse = 47
	"""
	You! Don't say
	another word!
	"""
	keyWait1
	clearMsg
	"""
	You've done something
	truly legendary,
	haven't you?
	"""
	keyWait1
	clearMsg
	"""
	Yes,I can see it
	in your eyes!
	"""
	keyWait1
	clearMsg
	"""
	You defeated Le Mu
	and saved the world
	from certain doom!
	"""
	keyWait1
	clearMsg
	"""
	I have a special gift
	for someone as
	legendary as yourself!
	"""
	keyWait1
	clearMsg
	mugshotHide
	playerAnimate
		animation = 24
	itemGiveEventCard
		card = 0xF6
	printGeoMegaMan
	"""
	 got:
	"
	"""
	printCard
		card = 0xF6
	"\"!\n"
	keyWait2
	playerFinish
	playerResetScene
	clearMsg
	mugshotShow
		mugshot = LegendaryMasterShin
	"""
	Legendary!
	"""
	keyWait0
	end
}
script 47 mmsf2 {
	checkFlag
		flag = 0x1077
		jumpIfTrue = 48
		jumpIfFalse = continue
	checkFlag
		flag = 2606
		jumpIfTrue = continue
		jumpIfFalse = 48
	"""
	You! Don't say
	another word!
	"""
	keyWait1
	clearMsg
	"""
	You've done something
	truly legendary,
	haven't you?
	"""
	keyWait1
	clearMsg
	"""
	Yes,I can see it
	in your eyes!
	"""
	keyWait1
	clearMsg
	"""
	You've defeated the
	most powerful warrior
	in this world!
	"""
	keyWait1
	clearMsg
	"""
	I have a special gift
	for someone as
	legendary as yourself!
	"""
	keyWait1
	clearMsg
	mugshotHide
	playerAnimate
		animation = 24
	itemGiveEventCard
		card = 0xF7
	printGeoMegaMan
	"""
	 got:
	"
	"""
	printCard
		card = 0xF7
	"\"!\n"
	keyWait2
	playerFinish
	playerResetScene
	clearMsg
	mugshotShow
		mugshot = LegendaryMasterShin
	"""
	Legendary!
	"""
	keyWait0
	end
}
script 48 mmsf2 {
	checkFlag
		flag = 3597
		jumpIfTrue = 46
		jumpIfFalse = continue
	jump
		target = 50
	end
}
script 70 mmsf2 {
	msgOpen
	mugshotHide
	"*BEEP,BEEP!*"
	keyWait1
	clearMsg
	"""
	THIS IS THE WAVE
	STATION.
	"""
	keyWait1
	clearMsg
	"""
	IT BROADCASTS ALL MANNER
	OF DATA TO STAR CARRIERS
	EVERYWHERE.
	"""
	keyWait1
	clearMsg
	checkFlag
		flag = 0x900
		jumpIfTrue = 72
		jumpIfFalse = continue
	checkFlag
		flag = 3596
		jumpIfTrue = 72
		jumpIfFalse = continue
	jump
		target = 71
	end
}
script 72 mmsf2 {
	checkEventBrother
		brother = 1
		jumpIfRegistered = continue
		jumpIfNotRegistered = 73
	msgOpen
	mugshotHide
	"""
	BY USING THE WAVE
	STATION NOW...
	"""
	keyWait1
	clearMsg
	"""
	YOU CAN BECOME BROTHERS
	WITH NONE OTHER THAN
	LEGENDARY MASTER SHIN!
	"""
	keyWait1
	clearMsg
	"...OOPS."
	keyWait1
	clearMsg
	"""
	IT APPEARS THAT YOU'RE
	ALREADY IN THE MIDDLE OF
	A DATA TRANSMISSION.
	"""
	keyWait1
	clearMsg
	"""
	PLEASE COME BACK AGAIN
	AT ANOTHER TIME!
	"""
	keyWait0
	end
	end
}
script 80 mmsf2 {
	msgOpen
	mugshotHide
	"*BEEP,BEEP!*"
	keyWait1
	clearMsg
	"""
	THIS IS THE WAVE
	STATION.
	"""
	keyWait1
	clearMsg
	"""
	IT BROADCASTS ALL MANNER
	OF DATA TO STAR CARRIERS
	EVERYWHERE.
	"""
	keyWait1
	clearMsg
	checkFlag
		flag = 0x900
		jumpIfTrue = 82
		jumpIfFalse = continue
	checkFlag
		flag = 3632
		jumpIfTrue = 82
		jumpIfFalse = continue
	jump
		target = 81
	end
}
script 82 mmsf2 {
	checkEventBrother
		brother = 2
		jumpIfRegistered = continue
		jumpIfNotRegistered = 83
	msgOpen
	mugshotHide
	"""
	BY USING THE WAVE
	STATION NOW...
	"""
	keyWait1
	clearMsg
	"""
	YOU CAN BECOME BROTHERS
	WITH NONE OTHER THAN
	1ST MEGAMAN!
	"""
	keyWait1
	clearMsg
	"...OOPS."
	keyWait1
	clearMsg
	"""
	IT APPEARS THAT YOU'RE
	ALREADY IN THE MIDDLE OF
	A DATA TRANSMISSION.
	"""
	keyWait1
	clearMsg
	"""
	PLEASE COME BACK AGAIN
	AT ANOTHER TIME!
	"""
	keyWait0
	end
	end
}
