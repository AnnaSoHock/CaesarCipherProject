# Author: Thu Nguyen, Marc Cruz, John Dang, Anna Hock, Jason Yam
# Decryption File

.data
	decrypted_message: .asciiz "\nDecrypted Message:  "
	decrypted_text: .space 30

.text
.globl decryption_prompt

decryption_prompt:
	la $s1, decrypted_text
decrypt:
	# loading singular character in $t1
	lb $t1, 0($s0)
	
	#see compare singular character to null character
	#if equal then we are done incrementing through string
	beq $t1, $0, display_output_decrypted
	
	#decrement character (ASCII) by one. We can reverse the encryption back to the original plaintext
	#addi $t1, $t1, -1
	sub $t1, $t1,  $s2 #$s3# decrement ASCII by the shift value
	
	#store the character in decrypted_text
	sb $t1, 0($s1)
	
	#have a pointer on the next character
	addi $s0, $s0, 1
	addi $s1, $s1, 1
	
	# loop again
	j decrypt

display_output_decrypted:
	
	# Takes the encrypted message inputted from user and decrypts message		
	
	la $a0, decrypted_message	# load address of decrypted_message into $a0
	li $v0, 4	# 4 is the code to print strings
	syscall
	
	la $a0, decrypted_text
	li $v0, 4
	syscall

exit:
	# returning back to main menu
	jr $ra
