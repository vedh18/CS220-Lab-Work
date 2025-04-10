.data
message1: .asciiz "Enter a number: "			# message to be printed
message_invalid: .asciiz "Invalid Entry"
string_zero: .asciiz "Zero "
string_one: .asciiz "One "
string_two: .asciiz "Two "
string_three: .asciiz "Three "
string_four: .asciiz "Four "
string_five: .asciiz "Five "
string_six: .asciiz "Six "
string_seven: .asciiz "Seven "
string_eight: .asciiz "Eight "
string_nine: .asciiz "Nine "

.text

main:
	li $v0,4
	la $a0,message1
	syscall

	# reading a integer
	li $v0,5
	syscall
	move $s0,$v0

	slt $t8, $s0, $zero
	bne $t8, $zero, invalid

	li $s1, 0                                       # initializing the value in register s1 as zero
	li $s3, 10

	li $t0, 0
	li $t1, 1
	li $t2, 2
	li $t3, 3
	li $t4, 4
	li $t5, 5
	li $t6, 6
	li $t7, 7
	li $s6, 8

function:
	beq $s0, $zero, next_function   # Exit loop if $s0 is zero
	div $s0, $s3                    # Divide $s0 by 10
	mfhi $t8                        # Get the remainder (last digit) into $t8
	mflo $s0                        # Update $s0 with the quotient (remaining number)
	mul $s1, $s1, $s3               # Shift $s1 left by one decimal place (multiply by 10)
	add $s1, $s1, $t8               # Add the remainder (last digit) to $s1
	j function                     

next_function:
	beq $s1, $zero, final
	div $s1, $s3
	mflo $s1
	mfhi $s4
	beq $s4, $t0, zero
	beq $s4, $t1, one
	beq $s4, $t2, two
	beq $s4, $t3, three
	beq $s4, $t4, four
	beq $s4, $t5, five
	beq $s4, $t6, six
	beq $s4, $t7, seven
	beq $s4, $s6, eight
	
	li $v0,4
	la $a0,string_nine
	syscall

	j next_function
	
zero:
	li $v0,4
	la $a0,string_zero
	syscall

	j next_function

one:
	li $v0,4
	la $a0,string_one
	syscall

	j next_function

two:
	li $v0,4
	la $a0,string_two
	syscall

	j next_function

three:
	li $v0,4
	la $a0,string_three
	syscall

	j next_function

four:
	li $v0,4
	la $a0,string_four
	syscall

	j next_function

five:
	li $v0,4
	la $a0,string_five
	syscall

	j next_function

six:
	li $v0,4
	la $a0,string_six
	syscall

	j next_function

seven:
	li $v0,4
	la $a0,string_seven
	syscall

	j next_function

eight:
	li $v0,4
	la $a0,string_eight
	syscall

	j next_function

invalid: 
	li $v0,4
	la $a0,message_invalid
	syscall

	j final

final:
	li $v0, 10					#end program
	syscall
