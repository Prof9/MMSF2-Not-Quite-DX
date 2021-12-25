@archive mess_0723
@size 70

script 40 mmsf2 {
	checkLinkPower
		value = 800
		jumpIfEnough = 42
		jumpIfNotEnough = 41
	end
}
script 41 mmsf2 {
	msgOpen
	mugshotHide
	"""
	This door shall open
	opened unto he whose
	"""
	keyWait1
	clearMsg
	"""
	Link Power is 800
	or greater...
	"""
	keyWait2
	end
}
script 42 mmsf2 {
	msgOpen
	mugshotHide
	"""
	This door shall open
	opened unto he whose
	"""
	keyWait1
	clearMsg
	"""
	Link Power is 800
	or greater...
	"""
	keyWait2
	flagClear
		flag = 700
	end
}
script 45 mmsf2 {
	checkTotalBattleCards
		amount = 500
		jumpIfEnough = 47
		jumpIfNotEnough = 46
	end
}
script 46 mmsf2 {
	msgOpen
	mugshotHide
	"""
	This door shall open
	for he who has
	"""
	keyWait1
	clearMsg
	"""
	amassed a total of
	500 Battle Cards...
	"""
	keyWait2
	end
}
script 47 mmsf2 {
	msgOpen
	mugshotHide
	"""
	This door shall open
	for he who has
	"""
	keyWait1
	clearMsg
	"""
	amassed a total of
	500 Battle Cards...
	"""
	keyWait2
	flagClear
		flag = 701
	end
}
script 50 mmsf2 {
	checkBestComboDamage
		damage = 1000
		jumpIfLess = 51
		jumpIfGreaterOrEqual = 52
	end
}
script 51 mmsf2 {
	msgOpen
	mugshotHide
	"""
	This door shall open
	for he who has
	"""
	keyWait1
	clearMsg
	"""
	achieved a Personal
	Best Combo of
	1000 damage...
	"""
	keyWait2
	end
}
script 52 mmsf2 {
	msgOpen
	mugshotHide
	"""
	This door shall open
	for he who has
	"""
	keyWait1
	clearMsg
	"""
	achieved a Personal
	Best Combo of
	1000 damage...
	"""
	keyWait2
	flagClear
		flag = 702
	end
}