# Author: Marc Cruz, Anna Hock, John Dang
# Encryption Game

.data
	game_menu_prompt: .asciiz "\nFor this Casesar Cipher game, you will be guessing the right shift key value to decrypt the message!\nplease choose:\n1. Select a sentence to be encrypted from a list\n2. If you feel lucky, go for a randomly encrypted sentence!\nEnter [1/2]: "
	invalid_prompt: .asciiz "Please enter a valid prompt\n"
	#put list together to make it easier to print
	game_list: .asciiz "Please select one of the given messages to try to decrypt!\nAfter selection, the chosen message is randomly encrypted\n1. Life is an adventure\n2. Keep it simple\n3. Learn and grow\n4. Explore new horizons\n5. Dance in the rain\n6. Bees know faces\n7. Besto Friendo\n8. Honey never spoils\n9. Bananas are berries\n10. Owls form parliaments\nEnter [1/2/3/4/5/6/7/8/9/10]:"

	
	# data
	random_number: .word 0
	shift_range: .word 10  		# Define the range for the random shift value
	# list of messages to pull from
	M1: .asciiz "Life is an adventure"
	M2: .asciiz "Keep it simple"
	M3: .asciiz "Learn and grow"
	M4: .asciiz "Explore new horizons"
	M5: .asciiz "Dance in the rain"
	M6: .asciiz "Bees know faces"
	M7: .asciiz "Besto Friendo"
	M8: .asciiz "Honey never spoils"
	M9: .asciiz "Bananas are berries"
	M10: .asciiz "Owls form parliaments"

	chosen_msg: .space 20
		
	lose_status: .asciiz "\nYou lose."
	win_status: .asciiz "\nYou win!"
	guessed_shift: .asciiz "\n\nPlease guess the shift value: "
	decrypted_sentence: .asciiz "\nThis is the decrypted sentence: "
	iteration_counter: .asciiz "This is try number: "
	
	debugrandom_message: .asciiz "\nThis is the random number generated: "
	debugshiftinput_message: .asciiz "\nThis is the shift input the user just entered: "
.text
.globl game_prompt
	
game_prompt:
	# pushing into stack, the $ra value to save the return address to main menu
	addi $sp, $sp, -4
	sw $ra, 0($sp)
	
	# printing prompt
	la $a0, game_menu_prompt
	li $v0, 4
	syscall
	
	li $v0, 5
	syscall
	move $t3,  $v0 	#$t3 as I first made random branch first.
	beq $t3, 1, print_list
	beq $t3, 2, choose_random
	
	

invalid_input:
	la $a0, invalid_prompt
	li $v0, 4
	syscall
	
	j game_prompt
	
print_list:
	# print list
	la $a0, game_list
	li $v0, 4
	syscall
	# prompt user input to choose a message
	li $v0, 5
	syscall
	move $t0, $v0
	
	bgt $t0, 10, invalid_input
	blt $t0, 1, invalid_input
	
	syscall
	# not sure what a proper branch name is, but jumping to branch to get the desired message and encrypt it
	j loading_message

# Randomizer to pick a number between 1-10, in case the user can decide on an option, or wants random
choose_random:
	# Upper bound
	li $a1, 10
	
	# Request a random number
	li $v0, 42
	syscall
	
	# Lower bound
	add $a0, $a0, 1
	move $t0, $a0

# Connecting the chosen message, encrypting it, and letting user take a guess
loading_message:
	# branching to respective message to then by copied and 
	beq $t0, 1, message_1
	beq $t0, 2, message_2
	beq $t0, 3, message_3
	beq $t0, 4, message_4
	beq $t0, 5, message_5
	beq $t0, 6, message_6
	beq $t0, 7, message_7
	beq $t0, 8, message_8
	beq $t0, 9, message_9
	beq $t0, 10, message_10

message_1:
	la $t0, M1 # $s1 is placeholder. the load would use the proper register for the modified encryption.asm
	# Need to modify encryption.asm to not prompt a message to encrypt and just take in a message
	# jal encryption_game_version # This is assumed name for modified encrypton.asm
	#Take string input from user	
	
	j guessing_game

message_2:
	la $t0, M2
	j guessing_game
	
message_3:
	la $t0, M3
	j guessing_game
	
message_4:
	la $t0, M4
	j guessing_game
	
message_5:
	la $t0, M5
	j guessing_game
	
message_6:
	la $t0, M6
	j guessing_game
	
message_7:
	la $t0, M7
	j guessing_game
	
message_8:
	la $t0, M8
	j guessing_game
	
message_9:
	la $t0, M9 
	j guessing_game
	
message_10:
	la $t0, M10 
	j guessing_game

# This branch is where we use encryption file to encrypt a message. That message is randomly encrypted (need to be made), then displayed
# for user to take a guess with
guessing_game:
	# random shift used to for shift
	# Upper bound
	li $a1, 5
	# Request a random number
	li $v0, 42
	syscall
	# Lower bound
	add $a0, $a0, 1
	
	move $s2, $a0 # this is the random generated number stored in $s2 
	#
	# calling encryption function
	jal encryption_prompt
	
	li $t9, 0	# i = 0. i represents how many times you tried to guess the shift value
	
	#debugging print statements; to print out the number that the random number generated

	#la $a0, debugrandom_message 	#load address of output_message into $a0
	#li $v0, 4 		#4 is the code to print strings
	#syscall
	
	#li $v0, 1
	#move $a0, $s2
	#syscall
	
	
	
	# for_loop branch used to facilitate the amount of guesses the user gets
	for_loop:
	beq $t9, 3, exit_status
	
	
	#print shift value input
	la $a0, guessed_shift
	li $v0, 4
	syscall
	#user input read
	li $v0, 5
	syscall
	move $s4, $v0
	
	#debug statement to output the value the user input as shift value and see if it correctly stores into the register
	#la $a0, debugshiftinput_message 	#load address of output_message into $a0
	#li $v0, 4 		#4 is the code to print strings
	#syscall
	
	#li $v0, 1
	#move $a0, $s4
	#syscall
	
	# if $s3 == shift value, go display you win
	beq $s2, $s4, winner
	
	# increment i
	addi $t9, $t9, 1
	
	 # Print the current iteration (counter variable i)
    la $a0, iteration_counter
    li $v0, 4
    syscall

    li $v0, 1          # syscall code for printing an integer
    move $a0, $t9       # load the value of the counter variable i
    syscall

	j for_loop
	

winner:
	la $a0, win_status
	li $v0, 4
	syscall	
	
	#print decrypted sentence
	la $a0, decrypted_sentence
	li $v0, 4
	jal decryption_prompt
	
	j exit

exit_status:
	la $a0, lose_status
	li $v0, 4
	syscall
	
exit:
	# return to main_menu.asm
	
	# popping out stack
	lw $ra, 0($sp)
	addi $sp, $sp, 4
	jr $ra
