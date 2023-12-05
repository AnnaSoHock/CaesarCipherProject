# Author: Jason Yam
# Encryption File

.data
	encrypted_text: .space 20
	output_message: .asciiz "Encrypted message: "

.text
.globl encryption_prompt

encryption_prompt:
    la $s0, encrypted_text

encryption:
    #loading singular character into $t1
    lb $t1, 0($t0)

    #see compare singular character to null character
    #if equal then we are done incrementing through string
    beq $t1, $0, display_output_encrypted

    #increment character (ASCII) by one
    #addi $t1, $t1, 1
    add $t1, $t1, $s2    # increment character (ASCII) by the shift value

    #store the character in encrypted_text
    sb $t1, 0($s0)

    #have a pointer on the next character
    addi $t0, $t0, 1
    addi $s0, $s0, 1

    #loop again
    j encryption

display_output_encrypted:

    #Prompt output for encrypted message
    la $a0, output_message     #load address of output_message into $a0
    li $v0, 4         #4 is the code to print strings
    syscall

    #Display the encrypted message
    la $a0, encrypted_text    #load address of encrypted_text into $a0
    li $v0, 4        #4 is the code to print string
    syscall

    #reset both the pointers of encrypted text and decrypted text
    la $s0, encrypted_text

exit:
    # returning to main_menu.asm
    jr $ra