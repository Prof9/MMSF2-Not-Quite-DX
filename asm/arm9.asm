// ARM9 binary

.nds
.thumb
.open TEMP+"/arm9.dec",0x02000000


.org 0x200EE84	// Fake slot-in after game clear
	bl	common_checkSlotInOrGameClear

.org 0x20E74AC	// Overwrite unused checkSaveStart command
	.dw	common_textCmdItemGiveEventCard|1
.org 0x20E74D4	// Overwrite unused checkSatelliteRegistration command
	.dw	common_textCmdCheckTotalBattleCards|1

.org 0x2012CFC	// First encounter check
	.dw	(4000)		// 250 -> 400 (SF3 = 400)
.org 0x2012DC6	// Next encounter check
	add	r1,(20)		// 10 -> 20 (SF3 = 15)


.org 0x200CF48	// Compress step counter increase rates from 8 per map to 2 per map
.area 0x20,0x00
	push	r14
	bl	common_getStepCounterDelta
	pop	r15
.endarea


.org 0x2012FA2	// Increase SP Boss rate with Cloaker + elemental search
	bl	common_getHighSPBossRate


.org 0x20B63F4	// Step counter increase rates (compressed)
.area 0x1000,0x00
.align 2
common_getStepCounterDelta:
	push	r4,r14
	sub	r0,0x80
	bmi	@@defaultArea
	cmp	r0,0x1F
	bls	@@getRate
@@defaultArea:
	mov	r0,0x0
@@getRate:
	lsl	r0,r0,0x5	// 16 x 2 rates per area
	lsl	r1,r1,0x1	// 2 rates per subarea
	add	r1,r0,r1	// area + subarea
	add	r1,r1,r2	// area + subarea + rate index
	ldr	r0,=common_stepCounterRates
	ldrb	r4,[r0,r1]

	// Check if SearchEye active
	bl	0x2020C44
	cmp	r0,0x0
	bne	@@increase

	// Check if elemental search active
	bl	0x2020CFC
	cmp	r0,0x0
	beq	@@end

@@increase:
	// Increase step counter delta
	lsl	r4,r4,0x1

@@end:
	mov	r0,r4
	pop	r4,r15


.align 2
common_resetEncounterRate:
	push	r14

	// Check if SearchEye active
	bl	0x2020C44
	cmp	r0,0x0
	bne	@@end

	// Check if elemental search active
	bl	0x2020CFC
	cmp	r0,0x0
	bne	@@end

	// Reset encounter rate
	bl	0x2012CD8

@@end:
	pop	r15


.align 2
common_getHighSPBossRate:
	// Check if Cloaker active
	bl	0x2020B7C
	cmp	r0,0x0
	beq	@@normal

	mov	r0,(4)		// 1-in-4
	b	@@end

@@normal:
	mov	r0,(10)		// 1-in-10
@@end:
	pop	r3,r15


.align 2
common_checkSlotInOrGameClear:
	// Expanded MMBN game check
	push	r14

	// r0 already set
	bl	0x202BED8	// check MMBN game inserted
	cmp	r0,0x0
	bne	@@end

	// Check game clear flag
	ldr	r0,=0x210FA4C
	ldr	r0,[r0]
	mov	r1,(0x900 >> 0x8)
	lsl	r1,r1,0x8
	bl	0x202A4D0	// check flag

@@end:
	pop	r15


	.pool

common_stepCounterRates:
	.db	10,  6	// 80 00 - (unused)
	.db	10,  6	// 80 01 - (unused)
	.db	10,  6	// 80 02 - (unused)
	.db	11,  6	// 80 03 - Echo Ridge SW (1.5 -> 1.1)
	.db	11,  6	// 80 04 - Mess Village SW (1.5 -> 1.1)
	.db	11,  6	// 80 05 - Whazzap SW (1.5 -> 1.1)
	.db	 8,  6	// 80 06 - Bermuda Maze (to Whazzap SW) (0.5 -> 0.8)
	.db	 8,  6	// 80 07 - Bermuda Maze (midway) (0.5 -> 0.8)
	.db	 8,  6	// 80 08 - Bermuda Maze (dead end) (0.5 -> 0.8)
	.db	 8,  6	// 80 09 - Bermuda Maze (crossroads) (0.5 -> 0.8)
	.db	 8,  6	// 80 0A - Bermuda Maze (fragmented crossroads) (0.5 -> 0.8)
	.db	 8,  6	// 80 0B - Bermuda Maze (stair maze) (0.5 -> 0.8)
	.db	13,  6	// 80 0C - Bermuda Maze (to Vega's Hideout) (0.5 -> 1.3)
	.db	 8,  6	// 80 0D - Bermuda Maze (to Sky Staircase) (0.5 -> 0.8)
	.db	 8,  6	// 80 0E - Sky Staircase (0.5 -> 0.8)
	.db	 5,  6	// 80 0F - (unused)
	.db	18,  6	// 81 00 - Wave Pool (1.5 -> 1.8)
	.db	18,  6	// 81 01 - Un-Dimension (1.5 -> 1.8)
	.db	15,  6	// 81 02 - (unused)
	.db	15,  6	// 81 03 - (unused)
	.db	15,  6	// 81 04 - (unused)
	.db	15,  6	// 81 05 - (unused)
	.db	15,  6	// 81 06 - (unused)
	.db	15,  6	// 81 07 - (unused)
	.db	15,  6	// 81 08 - (unused)
	.db	15,  6	// 81 09 - (unused)
	.db	15,  6	// 81 0A - (unused)
	.db	15,  6	// 81 0B - (unused)
	.db	15,  6	// 81 0C - (unused)
	.db	15,  6	// 81 0D - (unused)
	.db	15,  6	// 81 0E - (unused)
	.db	15,  6	// 81 0F - (unused)
	.db	12,  6	// 82 00 - Trans Dimension 1 (1.5 -> 1.2)
	.db	12,  6	// 82 01 - Trans Dimension 2 (1.5 -> 1.2)
	.db	15,  6	// 82 02 - (unused)
	.db	15,  6	// 82 03 - (unused)
	.db	15,  6	// 82 04 - (unused)
	.db	15,  6	// 82 05 - (unused)
	.db	15,  6	// 82 06 - (unused)
	.db	15,  6	// 82 07 - (unused)
	.db	15,  6	// 82 08 - (unused)
	.db	15,  6	// 82 09 - (unused)
	.db	15,  6	// 82 0A - (unused)
	.db	15,  6	// 82 0B - (unused)
	.db	15,  6	// 82 0C - (unused)
	.db	15,  6	// 82 0D - (unused)
	.db	15,  6	// 82 0E - (unused)
	.db	15,  6	// 82 0F - (unused)
	.db	15,  6	// 83 00 - Sky-Hi Coliseum
	.db	15,  6	// 83 01 - Sky-Hi Coliseum
	.db	15,  6	// 83 02 - Sky-Hi Coliseum
	.db	15,  6	// 83 03 - Sky-Hi Coliseum
	.db	15,  6	// 83 04 - (unused)
	.db	15,  6	// 83 05 - (unused)
	.db	15,  6	// 83 06 - (unused)
	.db	15,  6	// 83 07 - (unused)
	.db	15,  6	// 83 08 - (unused)
	.db	15,  6	// 83 09 - (unused)
	.db	15,  6	// 83 0A - (unused)
	.db	15,  6	// 83 0B - (unused)
	.db	15,  6	// 83 0C - (unused)
	.db	15,  6	// 83 0D - (unused)
	.db	15,  6	// 83 0E - (unused)
	.db	15,  6	// 83 0F - (unused)
	.db	15,  6	// 84 00 - (unused)
	.db	15,  6	// 84 01 - (unused)
	.db	15,  6	// 84 02 - (unused)
	.db	15,  6	// 84 03 - (unused)
	.db	15,  6	// 84 04 - (unused)
	.db	15,  6	// 84 05 - (unused)
	.db	15,  6	// 84 06 - (unused)
	.db	15,  6	// 84 07 - (unused)
	.db	15,  6	// 84 08 - (unused)
	.db	15,  6	// 84 09 - (unused)
	.db	15,  6	// 84 0A - (unused)
	.db	15,  6	// 84 0B - (unused)
	.db	15,  6	// 84 0C - (unused)
	.db	15,  6	// 84 0D - (unused)
	.db	15,  6	// 84 0E - (unused)
	.db	15,  6	// 84 0F - (unused)
	.db	15,  6	// 85 00 - (unused)
	.db	15,  6	// 85 01 - (unused)
	.db	15,  6	// 85 02 - (unused)
	.db	15,  6	// 85 03 - (unused)
	.db	15,  6	// 85 04 - (unused)
	.db	15,  6	// 85 05 - (unused)
	.db	15,  6	// 85 06 - (unused)
	.db	15,  6	// 85 07 - (unused)
	.db	15,  6	// 85 08 - (unused)
	.db	15,  6	// 85 09 - (unused)
	.db	15,  6	// 85 0A - (unused)
	.db	15,  6	// 85 0B - (unused)
	.db	15,  6	// 85 0C - (unused)
	.db	15,  6	// 85 0D - (unused)
	.db	15,  6	// 85 0E - (unused)
	.db	15,  6	// 85 0F - (unused)
	.db	15,  6	// 86 00 - (unused)
	.db	15,  6	// 86 01 - (unused)
	.db	15,  6	// 86 02 - (unused)
	.db	15,  6	// 86 03 - (unused)
	.db	15,  6	// 86 04 - (unused)
	.db	15,  6	// 86 05 - (unused)
	.db	15,  6	// 86 06 - (unused)
	.db	15,  6	// 86 07 - (unused)
	.db	15,  6	// 86 08 - (unused)
	.db	15,  6	// 86 09 - (unused)
	.db	15,  6	// 86 0A - (unused)
	.db	15,  6	// 86 0B - (unused)
	.db	15,  6	// 86 0C - (unused)
	.db	15,  6	// 86 0D - (unused)
	.db	15,  6	// 86 0E - (unused)
	.db	15,  6	// 86 0F - (unused)
	.db	15,  6	// 87 00 - (unused)
	.db	15,  6	// 87 01 - (unused)
	.db	15,  6	// 87 02 - (unused)
	.db	15,  6	// 87 03 - (unused)
	.db	15,  6	// 87 04 - (unused)
	.db	15,  6	// 87 05 - (unused)
	.db	15,  6	// 87 06 - (unused)
	.db	15,  6	// 87 07 - (unused)
	.db	15,  6	// 87 08 - (unused)
	.db	15,  6	// 87 09 - (unused)
	.db	15,  6	// 87 0A - (unused)
	.db	15,  6	// 87 0B - (unused)
	.db	15,  6	// 87 0C - (unused)
	.db	15,  6	// 87 0D - (unused)
	.db	15,  6	// 87 0E - (unused)
	.db	15,  6	// 87 0F - (unused)
	.db	15,  6	// 88 00 - (unused)
	.db	15,  6	// 88 01 - (unused)
	.db	15,  6	// 88 02 - (unused)
	.db	15,  6	// 88 03 - (unused)
	.db	15,  6	// 88 04 - (unused)
	.db	15,  6	// 88 05 - (unused)
	.db	15,  6	// 88 06 - (unused)
	.db	15,  6	// 88 07 - (unused)
	.db	15,  6	// 88 08 - (unused)
	.db	15,  6	// 88 09 - (unused)
	.db	15,  6	// 88 0A - (unused)
	.db	15,  6	// 88 0B - (unused)
	.db	15,  6	// 88 0C - (unused)
	.db	15,  6	// 88 0D - (unused)
	.db	15,  6	// 88 0E - (unused)
	.db	15,  6	// 88 0F - (unused)
	.db	15,  6	// 89 00 - (unused)
	.db	15,  6	// 89 01 - (unused)
	.db	15,  6	// 89 02 - (unused)
	.db	15,  6	// 89 03 - (unused)
	.db	15,  6	// 89 04 - (unused)
	.db	15,  6	// 89 05 - (unused)
	.db	15,  6	// 89 06 - (unused)
	.db	15,  6	// 89 07 - (unused)
	.db	15,  6	// 89 08 - (unused)
	.db	15,  6	// 89 09 - (unused)
	.db	15,  6	// 89 0A - (unused)
	.db	15,  6	// 89 0B - (unused)
	.db	15,  6	// 89 0C - (unused)
	.db	15,  6	// 89 0D - (unused)
	.db	15,  6	// 89 0E - (unused)
	.db	15,  6	// 89 0F - (unused)
	.db	15,  6	// 8A 00 - (unused)
	.db	15,  6	// 8A 01 - (unused)
	.db	15,  6	// 8A 02 - (unused)
	.db	15,  6	// 8A 03 - (unused)
	.db	15,  6	// 8A 04 - (unused)
	.db	15,  6	// 8A 05 - (unused)
	.db	15,  6	// 8A 06 - (unused)
	.db	15,  6	// 8A 07 - (unused)
	.db	15,  6	// 8A 08 - (unused)
	.db	15,  6	// 8A 09 - (unused)
	.db	15,  6	// 8A 0A - (unused)
	.db	15,  6	// 8A 0B - (unused)
	.db	15,  6	// 8A 0C - (unused)
	.db	15,  6	// 8A 0D - (unused)
	.db	15,  6	// 8A 0E - (unused)
	.db	15,  6	// 8A 0F - (unused)
	.db	15,  6	// 8B 00 - (unused)
	.db	15,  6	// 8B 01 - (unused)
	.db	15,  6	// 8B 02 - (unused)
	.db	15,  6	// 8B 03 - (unused)
	.db	15,  6	// 8B 04 - (unused)
	.db	15,  6	// 8B 05 - (unused)
	.db	15,  6	// 8B 06 - (unused)
	.db	15,  6	// 8B 07 - (unused)
	.db	15,  6	// 8B 08 - (unused)
	.db	15,  6	// 8B 09 - (unused)
	.db	15,  6	// 8B 0A - (unused)
	.db	15,  6	// 8B 0B - (unused)
	.db	15,  6	// 8B 0C - (unused)
	.db	15,  6	// 8B 0D - (unused)
	.db	15,  6	// 8B 0E - (unused)
	.db	15,  6	// 8B 0F - (unused)
	.db	15,  6	// 8C 00 - TV ES
	.db	15,  6	// 8C 01 - Sign ES
	.db	15,  6	// 8C 02 - Doghouse ES
	.db	15,  6	// 8C 03 - Mailbox ES
	.db	15,  6	// 8C 04 - Pool ES
	.db	15,  6	// 8C 05 - Computer ES
	.db	15,  6	// 8C 06 - Air Display ES
	.db	15,  6	// 8C 07 - Mega Display ES
	.db	15,  6	// 8C 08 - Old Binoculars ES
	.db	15,  6	// 8C 09 - IFL Antenna ES
	.db	15,  6	// 8C 0A - Security Camera ES
	.db	15,  6	// 8C 0B - Love Seat ES
	.db	15,  6	// 8C 0C - Bureau ES
	.db	15,  6	// 8C 0D - Junk Box ES
	.db	15,  6	// 8C 0E - Step ES
	.db	15,  6	// 8C 0F - Bargain Bin ES
	.db	15,  6	// 8D 00 - Snow Man ES
	.db	15,  6	// 8D 01 - Wave Fountain ES
	.db	15,  6	// 8D 02 - Jumbo Griddle ES
	.db	15,  6	// 8D 03 - Lost Ice Statue ES
	.db	15,  6	// 8D 04 - Lodge Monitor ES
	.db	15,  6	// 8D 05 - Souvenir Panel ES
	.db	15,  6	// 8D 06 - Christmas Tree ES
	.db	15,  6	// 8D 07 - Canopy Bed ES
	.db	15,  6	// 8D 08 - Wave Sign ES
	.db	15,  6	// 8D 09 - (Broken) Lift ES
	.db	15,  6	// 8D 0A - Control Panel ES
	.db	15,  6	// 8D 0B - Home Security ES
	.db	15,  6	// 8D 0C - Cock-A-Doodle ES
	.db	15,  6	// 8D 0D - Corn Dog Stand ES
	.db	15,  6	// 8D 0E - Shepherd ES
	.db	15,  6	// 8D 0F - Binoculars ES
	.db	15,  6	// 8E 00 - Crown ES
	.db	15,  6	// 8E 01 - Octy ES
	.db	15,  6	// 8E 02 - Mu Statue ES
	.db	15,  6	// 8E 03 - Electric Rock ES
	.db	15,  6	// 8E 04 - Old Dragonfly ES
	.db	15,  6	// 8E 05 - Torchere ES
	.db	15,  6	// 8E 06 - Holy Flame ES
	.db	15,  6	// 8E 07 - Priest Statue ES
	.db	15,  6	// 8E 08 - Murian ES
	.db	15,  6	// 8E 09 - Crest ES
	.db	15,  6	// 8E 0A - Whazzap Maiden ES
	.db	15,  6	// 8E 0B - Sunken Ship ES
	.db	15,  6	// 8E 0C - Ammonite ES
	.db	15,  6	// 8E 0D - Broken Bus Stop ES
	.db	15,  6	// 8E 0E - Broken Display ES
	.db	15,  6	// 8E 0F - Stuck Windmill ES
	.db	15,  6	// 8F 00 - (unused)
	.db	15,  6	// 8F 01 - (unused)
	.db	15,  6	// 8F 02 - (unused)
	.db	15,  6	// 8F 03 - (unused)
	.db	15,  6	// 8F 04 - (unused)
	.db	15,  6	// 8F 05 - (unused)
	.db	15,  6	// 8F 06 - (unused)
	.db	15,  6	// 8F 07 - (unused)
	.db	15,  6	// 8F 08 - (unused)
	.db	15,  6	// 8F 09 - (unused)
	.db	15,  6	// 8F 0A - (unused)
	.db	15,  6	// 8F 0B - (unused)
	.db	15,  6	// 8F 0C - (unused)
	.db	15,  6	// 8F 0D - (unused)
	.db	15,  6	// 8F 0E - (unused)
	.db	15,  6	// 8F 0F - (unused)
	.db	10,  6	// 90 00 - Echo Ridge ER
	.db	10,  6	// 90 01 - Geo's Living Room ER
	.db	10,  6	// 90 02 - Geo's Room ER (1.5 -> 1.0)
	.db	10,  6	// 90 03 - Luna's Room ER
	.db	10,  6	// 90 04 - Bud's Room ER (1.5 -> 1.0)
	.db	10,  6	// 90 05 - Zack's Room ER (1.5 -> 1.0)
	.db	10,  6	// 90 06 - BIG WAVE ER
	.db	10,  6	// 90 07 - Wilshile Hills ER (Day)
	.db	10,  6	// 90 08 - Shopping Plaza ER (1.5 -> 1.0)
	.db	10,  6	// 90 09 - Movie Theater ER (1.5 -> 1.0)
	.db	10,  6	// 90 0A - IFL Tower 1 ER (Day)
	.db	10,  6	// 90 0B - IFL Tower 2 ER (Day)
	.db	10,  6	// 90 0C - Hills Boulevard ER
	.db	10,  6	// 90 0D - Wilshire Hills ER (Night) (1.5 -> 1.0)
	.db	10,  6	// 90 0E - IFL Tower 1 ER (Night)
	.db	10,  6	// 90 0F - IFL Tower 2 ER (Night)
	.db	 8,  3	// 91 00 - Grizzly Peak ER (0.5 -> 0.8)
	.db	 8,  3	// 91 01 - Foodtopia ER (0.5 -> 0.8)
	.db	 8,  3	// 91 02 - Peak Hotel ER (0.5 -> 0.8)
	.db	10,  3	// 91 03 - Suite ER
	.db	10,  6	// 91 04 - Bunny Slopes ER
	.db	10,  6	// 91 05 - Black Diamond Run ER
	.db	10,  6	// 91 06 - (unused)
	.db	10,  6	// 91 07 - (unused)
	.db	10,  6	// 91 08 - (unused)
	.db	10,  6	// 91 09 - (unused)
	.db	10,  6	// 91 0A - (unused)
	.db	10,  6	// 91 0B - (unused)
	.db	10,  6	// 91 0C - (unused)
	.db	10,  6	// 91 0D - (unused)
	.db	10,  6	// 91 0E - (unused)
	.db	10,  6	// 91 0F - (unused)
	.db	10,  6	// 92 00 - Museum ER (1.5 -> 1.0)
	.db	10,  6	// 92 01 - (unused)
	.db	10,  6	// 92 02 - (unused)
	.db	10,  6	// 92 03 - (unused)
	.db	10,  6	// 92 04 - (unused)
	.db	10,  6	// 92 05 - (unused)
	.db	10,  6	// 92 06 - (unused)
	.db	10,  6	// 92 07 - (unused)
	.db	10,  6	// 92 08 - (unused)
	.db	10,  6	// 92 09 - (unused)
	.db	10,  6	// 92 0A - (unused)
	.db	10,  6	// 92 0B - (unused)
	.db	10,  6	// 92 0C - (unused)
	.db	10,  6	// 92 0D - (unused)
	.db	10,  6	// 92 0E - (unused)
	.db	10,  6	// 92 0F - (unused)
	.db	10,  6	// 93 00 - Mess Village ER
	.db	10,  6	// 93 01 - Messie's Cove ER (1.5 -> 1.0)
	.db	12,  6	// 93 02 - Observation Deck ER (Normal) (1.5 -> 1.2)
	.db	25,  6	// 93 03 - Vega's Hideout ER
	.db	 7,  6	// 93 04 - Loch Mess 1 ER (1.0 -> 0.7)
	.db	 7,  6	// 93 05 - Loch Mess 2 ER (1.0 -> 0.7)
	.db	12,  6	// 93 06 - Observation Deck ER (Flooded) (1.0 -> 1.2)
	.db	10,  6	// 93 07 - (unused)
	.db	10,  6	// 93 08 - (unused)
	.db	10,  6	// 93 09 - (unused)
	.db	10,  6	// 93 0A - (unused)
	.db	10,  6	// 93 0B - (unused)
	.db	10,  6	// 93 0C - (unused)
	.db	10,  6	// 93 0D - (unused)
	.db	10,  6	// 93 0E - (unused)
	.db	10,  6	// 93 0F - (unused)
	.db	10,  6	// 94 00 - Whazzap ER (1.5 -> 1.0)
	.db	 8,  6	// 94 01 - Whazzap Lines ER (1.0 -> 0.8)
	.db	 8,  6	// 94 02 - Whazzap Ruins 1 ER (0.5 -> 0.8)
	.db	 8,  6	// 94 03 - Whazzap Ruins 2 ER (0.5 -> 0.8)
	.db	10,  6	// 94 04 - (unused)
	.db	10,  6	// 94 05 - (unused)
	.db	10,  6	// 94 06 - (unused)
	.db	10,  6	// 94 07 - (unused)
	.db	10,  6	// 94 08 - (unused)
	.db	10,  6	// 94 09 - (unused)
	.db	10,  6	// 94 0A - (unused)
	.db	10,  6	// 94 0B - (unused)
	.db	10,  6	// 94 0C - (unused)
	.db	10,  6	// 94 0D - (unused)
	.db	10,  6	// 94 0E - (unused)
	.db	10,  6	// 94 0F - (unused)
	.db	11,  6	// 95 00 - Mu (1.0 -> 1.1)
	.db	11,  6	// 95 01 - Room of Heroes (1.0 -> 1.1)
	.db	11,  6	// 95 02 - Room of Genesis (1.0 -> 1.1)
	.db	 8,  6	// 95 03 - Great Shrine (0.5 -> 0.8)
	.db	10,  6	// 95 04 - (unused)
	.db	10,  6	// 95 05 - (unused)
	.db	10,  6	// 95 06 - (unused)
	.db	10,  6	// 95 07 - (unused)
	.db	10,  6	// 95 08 - (unused)
	.db	10,  6	// 95 09 - (unused)
	.db	10,  6	// 95 0A - (unused)
	.db	10,  6	// 95 0B - (unused)
	.db	10,  6	// 95 0C - (unused)
	.db	10,  6	// 95 0D - (unused)
	.db	10,  6	// 95 0E - (unused)
	.db	10,  6	// 95 0F - (unused)
	.db	12,  6	// 96 00 - Alternate Echo Ridge ER (1.5 -> 1.2)
	.db	12,  6	// 96 01 - Alternate IFL Tower 2 ER (1.5 -> 1.2)
	.db	12,  6	// 96 02 - Alternate Black Diamond Run ER (1.5 -> 1.2)
	.db	12,  6	// 96 03 - Alternate Messie's Cove ER (1.5 -> 1.2)
	.db	12,  6	// 96 04 - Alternate Wilshire Hills ER (1.5 -> 1.2)
	.db	12,  6	// 96 05 - Alternate Loch Mess 2 ER (1.5 -> 1.2)
	.db	12,  6	// 96 06 - Alternate Whazzap Lines ER (1.5 -> 1.2)
	.db	12,  6	// 96 07 - Alternate Whazzap Ruins 2 ER (1.5 -> 1.2)
	.db	10,  6	// 96 08 - (unused)
	.db	10,  6	// 96 09 - (unused)
	.db	10,  6	// 96 0A - (unused)
	.db	10,  6	// 96 0B - (unused)
	.db	10,  6	// 96 0C - (unused)
	.db	10,  6	// 96 0D - (unused)
	.db	10,  6	// 96 0E - (unused)
	.db	10,  6	// 96 0F - (unused)
	.db	10,  6	// 97 00 - (unused)
	.db	10,  6	// 97 01 - (unused)
	.db	10,  6	// 97 02 - (unused)
	.db	10,  6	// 97 03 - (unused)
	.db	10,  6	// 97 04 - (unused)
	.db	10,  6	// 97 05 - (unused)
	.db	10,  6	// 97 06 - (unused)
	.db	10,  6	// 97 07 - (unused)
	.db	10,  6	// 97 08 - (unused)
	.db	10,  6	// 97 09 - (unused)
	.db	10,  6	// 97 0A - (unused)
	.db	10,  6	// 97 0B - (unused)
	.db	10,  6	// 97 0C - (unused)
	.db	10,  6	// 97 0D - (unused)
	.db	10,  6	// 97 0E - (unused)
	.db	10,  6	// 97 0F - (unused)
	.db	10,  6	// 98 00 - (unused)
	.db	10,  6	// 98 01 - (unused)
	.db	10,  6	// 98 02 - (unused)
	.db	10,  6	// 98 03 - (unused)
	.db	10,  6	// 98 04 - (unused)
	.db	10,  6	// 98 05 - (unused)
	.db	10,  6	// 98 06 - (unused)
	.db	10,  6	// 98 07 - (unused)
	.db	10,  6	// 98 08 - (unused)
	.db	10,  6	// 98 09 - (unused)
	.db	10,  6	// 98 0A - (unused)
	.db	10,  6	// 98 0B - (unused)
	.db	10,  6	// 98 0C - (unused)
	.db	10,  6	// 98 0D - (unused)
	.db	10,  6	// 98 0E - (unused)
	.db	10,  6	// 98 0F - (unused)
	.db	10,  6	// 99 00 - (unused)
	.db	10,  6	// 99 01 - (unused)
	.db	10,  6	// 99 02 - (unused)
	.db	10,  6	// 99 03 - (unused)
	.db	10,  6	// 99 04 - (unused)
	.db	10,  6	// 99 05 - (unused)
	.db	10,  6	// 99 06 - (unused)
	.db	10,  6	// 99 07 - (unused)
	.db	10,  6	// 99 08 - (unused)
	.db	10,  6	// 99 09 - (unused)
	.db	10,  6	// 99 0A - (unused)
	.db	10,  6	// 99 0B - (unused)
	.db	10,  6	// 99 0C - (unused)
	.db	10,  6	// 99 0D - (unused)
	.db	10,  6	// 99 0E - (unused)
	.db	10,  6	// 99 0F - (unused)
	.db	10,  6	// 9A 00 - (unused)
	.db	10,  6	// 9A 01 - (unused)
	.db	10,  6	// 9A 02 - (unused)
	.db	10,  6	// 9A 03 - (unused)
	.db	10,  6	// 9A 04 - (unused)
	.db	10,  6	// 9A 05 - (unused)
	.db	10,  6	// 9A 06 - (unused)
	.db	10,  6	// 9A 07 - (unused)
	.db	10,  6	// 9A 08 - (unused)
	.db	10,  6	// 9A 09 - (unused)
	.db	10,  6	// 9A 0A - (unused)
	.db	10,  6	// 9A 0B - (unused)
	.db	10,  6	// 9A 0C - (unused)
	.db	10,  6	// 9A 0D - (unused)
	.db	10,  6	// 9A 0E - (unused)
	.db	10,  6	// 9A 0F - (unused)
	.db	10,  6	// 9B 00 - (unused)
	.db	10,  6	// 9B 01 - (unused)
	.db	10,  6	// 9B 02 - (unused)
	.db	10,  6	// 9B 03 - (unused)
	.db	10,  6	// 9B 04 - (unused)
	.db	10,  6	// 9B 05 - (unused)
	.db	10,  6	// 9B 06 - (unused)
	.db	10,  6	// 9B 07 - (unused)
	.db	10,  6	// 9B 08 - (unused)
	.db	10,  6	// 9B 09 - (unused)
	.db	10,  6	// 9B 0A - (unused)
	.db	10,  6	// 9B 0B - (unused)
	.db	10,  6	// 9B 0C - (unused)
	.db	10,  6	// 9B 0D - (unused)
	.db	10,  6	// 9B 0E - (unused)
	.db	10,  6	// 9B 0F - (unused)
	.db	10,  6	// 9C 00 - (unused)
	.db	10,  6	// 9C 01 - (unused)
	.db	10,  6	// 9C 02 - (unused)
	.db	10,  6	// 9C 03 - (unused)
	.db	10,  6	// 9C 04 - (unused)
	.db	10,  6	// 9C 05 - (unused)
	.db	10,  6	// 9C 06 - (unused)
	.db	10,  6	// 9C 07 - (unused)
	.db	10,  6	// 9C 08 - (unused)
	.db	10,  6	// 9C 09 - (unused)
	.db	10,  6	// 9C 0A - (unused)
	.db	10,  6	// 9C 0B - (unused)
	.db	10,  6	// 9C 0C - (unused)
	.db	10,  6	// 9C 0D - (unused)
	.db	10,  6	// 9C 0E - (unused)
	.db	10,  6	// 9C 0F - (unused)
	.db	10,  6	// 9D 00 - (unused)
	.db	10,  6	// 9D 01 - (unused)
	.db	10,  6	// 9D 02 - (unused)
	.db	10,  6	// 9D 03 - (unused)
	.db	10,  6	// 9D 04 - (unused)
	.db	10,  6	// 9D 05 - (unused)
	.db	10,  6	// 9D 06 - (unused)
	.db	10,  6	// 9D 07 - (unused)
	.db	10,  6	// 9D 08 - (unused)
	.db	10,  6	// 9D 09 - (unused)
	.db	10,  6	// 9D 0A - (unused)
	.db	10,  6	// 9D 0B - (unused)
	.db	10,  6	// 9D 0C - (unused)
	.db	10,  6	// 9D 0D - (unused)
	.db	10,  6	// 9D 0E - (unused)
	.db	10,  6	// 9D 0F - (unused)
	.db	10,  6	// 9E 00 - (unused)
	.db	10,  6	// 9E 01 - (unused)
	.db	10,  6	// 9E 02 - (unused)
	.db	10,  6	// 9E 03 - (unused)
	.db	10,  6	// 9E 04 - (unused)
	.db	10,  6	// 9E 05 - (unused)
	.db	10,  6	// 9E 06 - (unused)
	.db	10,  6	// 9E 07 - (unused)
	.db	10,  6	// 9E 08 - (unused)
	.db	10,  6	// 9E 09 - (unused)
	.db	10,  6	// 9E 0A - (unused)
	.db	10,  6	// 9E 0B - (unused)
	.db	10,  6	// 9E 0C - (unused)
	.db	10,  6	// 9E 0D - (unused)
	.db	10,  6	// 9E 0E - (unused)
	.db	10,  6	// 9E 0F - (unused)
	.db	10,  6	// 9F 00 - (unused)
	.db	10,  6	// 9F 01 - (unused)
	.db	10,  6	// 9F 02 - (unused)
	.db	10,  6	// 9F 03 - (unused)
	.db	10,  6	// 9F 04 - (unused)
	.db	10,  6	// 9F 05 - (unused)
	.db	10,  6	// 9F 06 - (unused)
	.db	10,  6	// 9F 07 - (unused)
	.db	10,  6	// 9F 08 - (unused)
	.db	10,  6	// 9F 09 - (unused)
	.db	10,  6	// 9F 0A - (unused)
	.db	10,  6	// 9F 0B - (unused)
	.db	10,  6	// 9F 0C - (unused)
	.db	10,  6	// 9F 0D - (unused)
	.db	10,  6	// 9F 0E - (unused)
	.db	10,  6	// 9F 0F - (unused)
.endarea


.org 0x2017458
.area 0x74,0x00

.align 2
common_textCmdItemGiveEventCard:
	// itemGiveEventCard text command handler
	push	r4,r14
	mov	r4,r0

	// Load card ID parameter
//	mov	r0,r4
	ldr	r1,[r4,0x10]	// script pointer
	add	r1,0x2
	bl	0x20268D4	// load u16

	// Receive event card
	mov	r1,r0		// card ID
	ldr	r0,=0x20F1DA4
	bl	0x20014C4	// receive event card

	// Play "item get" SFX
	ldr	r0,=0x20F2EEC
	ldr	r0,[r0]
	mov	r1,0xCB
	bl	0x20056E4	// play SFX

	// Advance script handler
	mov	r0,r4
	mov	r1,0x4
	bl	0x20268FC

	mov	r0,0x0		// script continues
	pop	r4,r15


.align 2
common_textCmdCheckTotalBattleCards:
	// checkTotalBattleCards text command handler
	push	r4-r5,r14
	mov	r4,r0

	// Load card count parameter
//	mov	r0,r4
	ldr	r1,[r4,0x10]	// script pointer
	add	r1,0x2
	bl	0x20268D4	// load u16
	mov	r5,r0

	// Get number of cards player has
	ldr	r0,=0x20F47FC
	ldr	r0,[r0]
	mov	r1,0x0
	bl	0x200C8E0	// get total number of cards

	ldr	r1,[r4,0x10]
	add	r1,0x4		// enough
	cmp	r0,r5
	bhs	@@jump		// higher or same
	add	r1,0x1		// not enough

@@jump:
	// Do jump
	mov	r0,r4
	ldrb	r1,[r1]		// load u8
	bl	0x2025E6C
	cmp	r0,0x0
	bne	@@end

	// Advance script handler
	mov	r0,r4
	mov	r1,0x6
	bl	0x20268FC

@@end:
	mov	r0,0x0		// script continues
	pop	r4-r5,r15


	.pool
.endarea


.close
