# Author: Thu Nguyen, Marc Cruz, John Dang, Anna Hock, Jason Yam
# Date 11/05/2023
# Main Menu, users would start this file and be used to navigate to the other modules (encryption, decryption, and encryption game)

.data
	# main_menu .data
	instructions: .asciiz "Why Hello! This is the menu for the caesar cipher scripts! \nYou may choose to encrypt a message, decrypt an encrypted message, or select the Caesar Cipher Game! \nKeep in mind the limitation to messages are 20 characters"
	main_menu_options:.asciiz "\n\nPlease choose one of the options:\n1. Encrypt a message\n2. Decrypt a message\n3. Caesar Cipher Game\n4. Exit\n"
	main_menu_prompt: .asciiz "Enter [1/2/3/4]: "
	main_menu_error_msg: .asciiz "Error: Invalid input. Please enter [1/2/3/4]: \n"
	
	# encryption.asm .data
	# Within main_menu.asm to allow encryption.asm to be pure encryption with being given required variables instead of asking for variables
	# the asking part, is within main_menu.asm
	encrypted_input_message: .asciiz "Enter plaintext message: "
	
	# decryption.asm .data
	decrypted_input_message: .asciiz "Enter Encrypted message: "
	output_message: .asciiz "Decrypt message: "
	encrypted_text: .space 20
	
	# misc. .data 
	# used by multiple files
	shift_msg: .asciiz "Enter shift value: "
	plaintext: .space 20
	shift_value: .space 4
	
	
.text
.globl main_menu #initializing the branch to be accessed by other files

	# Printing instructions/introduction of the scripts. Put first to avoid it being reiterated
	la $a0, instructions
	li $v0, 4
	syscall
	
main_menu:
	# Printing out options for the user to select from
	la $a0, main_menu_options
	li $v0, 4
	syscall
	
    	# Prompt the user to enter option 1, 2, 3, or 4
   	la $a0, main_menu_prompt
   	li $v0, 4
   	syscall

    	# Read user input as an integer
    	li $v0, 5
    	syscall

    	# Check if user input is an integer
    	# send them to their respective option (encryption, decryption, encryption game, or exit)
    	li $t0, 1
    	beq $v0, $t0, encryption_menu
    	li $t0, 2
    	beq $v0, $t0, decryption_menu
    	li $t0, 3
    	beq $v0, $t0, game_menu
    	li $t0, 4
    	beq $v0, $t0, exit

    	# Print error message
    	li $v0, 4
    	la $a0, main_menu_error_msg
    	syscall

    	# Jump back to the beginning to re-enter the value
    	j main_menu
	
	# routing of the main options to their respective file via .globl
	# option 1
	encryption_menu:
		# print the shift message
		li $v0, 4	# 4 is the code to print strings
		la $a0, shift_msg	
		syscall
	
		# take shift value input from the user
		li $v0, 5	# 5 is the code to input strings
		syscall
		move $s2, $v0	# move the shift value from $v0 to $s2
	
		li $v0, 4		#4 is the code to print strings
		la $a0, encrypted_input_message	#store address of input_message into a0
		syscall
	
		#Take string input from user
		li $v0, 8		#8 is the code to input string
		la $a0, plaintext	#a0 is the parameter to hold the address
		li $a1, 20		#a1 is the parameter to hold the length
		syscall
	
		#load address of plaintext into $t0
		la $t0, plaintext
		
		# calling encryption function
		jal encryption_prompt
		j main_menu
	
	# option 2
	decryption_menu:
		#Prompt for user input
		li $v0, 4		#4 is the code to print strings
		la $a0, decrypted_input_message	#store address of input_message into a0
		syscall
	
		#Take string input from user
		li $v0, 8			#8 is the code to input string
		la $a0, plaintext	#a0 is the parameter to hold the address
		li $a1, 20		#a1 is the parameter to hold the length
		syscall
	
		# Prompt for shift value from user input
		li $v0, 4	#4 is the code to print strings
		la $a0, shift_msg
		syscall
	
		#Take shift value input from the user
		li $v0, 5	# 5 is the code to input integer
		syscall
		move $s3, $v0	# move shift value from $v0 to $s4
	
		#load address of plaintext into $t0
		la $s0, plaintext
		
		# calling decryption function
    		jal decryption_prompt
    		j main_menu
    		
    	# option 3
	game_menu:
		jal game_prompt
		j main_menu
exit:
    li $v0, 10
    syscall
