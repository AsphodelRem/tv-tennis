###########################################
# 0xE0, 0xE1 - game score
# 0xE2, 0xE3 - coordinates of bats
# 0xE4, 0xE5 - ball's coordinates
# 0xE6, 0xE7 - ball's velocity by x and y
###########################################

asect 0xD0							#load some value into register from an address (ldi and ld together)
	macro idv/2
	ldi $1, $2
	ld $1, $1
	mend

asect 0xE0
	player_score: 		dc 0
	cdm8_score: 		dc 0
	player_bat_y_coord: dc 0
	cdm8_bat_y_coord: 	dc 0
	ball_x: 			dc 16
	ball_y: 			dc 16
	vx:					dc -1
	vy:					dc 1

asect 0x00
jsr check_wall_hitting

asect 0xA0
check_wall_hitting:					#checking a hitting the wall
	push r0
	push r1
	push r2
	ldi r0, 31
	ldi r2, 0
	idv r1, ball_x
	
	if
		cmp r0, r1
		cmp r2, r1
	is eq
		push r1 
		idv r0, vx
		neg r0
		ldi r1, vx
		st r1, r0
		ldi 
		pop r1
	fi
	
	pop r2
	pop r1
	pop r0
rts

#это не понадобилось, хотя пусть пока будет здесь	
init:								#initialization game's data
	ldi r0, player_score
	ldi r1, cdm8_score
	ldi r0, 1
	ldi r1, 1
	ldi r0, vx
	ldi r0, -1
	ldi r0, vy
	ldi r0, 1
	ldi r0, ball_x
	ldi r1, ball_y
	ldi r0, 16
	ldi r1, 16
	ldi r0, player_bat_y_coord
	ldi r0, 0
	ldi r0, cdm8_bat_y_coord
	ldi r0, 0
rts	
###

halt
end