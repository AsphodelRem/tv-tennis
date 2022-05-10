###########################################
# 0xE0, 0xE1 - game score
# 0xE2 - coordinates of cdm8's bat
# 0xE3, 0xE4 - ball's coordinates
# 0xE5, 0xE6 - ball's velocity by x and y
# 0xE7 - game flag, if this flag = 1, game over
###########################################

#load some value into register from an address (ldi and ld together)						
macro idv/2
	ldi $1, $2
	ld $1, $1
mend

#data
asect 0xE0
	player_score: 		ds 1
	cdm8_score: 		ds 1
	cdm8_bat_y_coord: 	ds 1
	ball_x: 			ds 1
	ball_y: 			ds 1
	vx:					ds 1
	vy:					ds 1	
	game_over:			ds 1

asect 0x00

#set a pointer on stack
setsp 0xf0

#start bot
cdm8_player:
#***********************************************
#formula for counting
#d = y + (240 - x) / vx * vy - 255
#***********************************************
	
	#load values
	idv r1, ball_x						
	idv r3, vx
		
	#we shouldn't count anything, if the ball on the left side
	if
		tst r3
	is mi, or
		tst r1
	is mi
	then
		br 0x2b
	fi
	
	#(240 - x)
	ldi r0, 240
	sub r0, r1
	
	#reset all flags
	tst r1
	
	#division
	shra r1
	
	idv r3, vy	
	
	#if vy was negative, take the inverse number
	if
		tst r3
	is mi
		neg r1
	fi
	
	idv r2, ball_y
	
	#if there is carry bit, sustract 255 from our value
	if 
		add r2, r1
	is cs
		ldi r2, 255
		sub r1, r2
	fi
	
	#count final cross point
	ldi r3, 255
	sub r3, r2
	
	#save value to the memory
	ldi r0, cdm8_bat_y_coord
	st r0, r2
	
	#start again
	br cdm8_player

	rts

halt
end
