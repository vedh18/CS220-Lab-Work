.data
numbers: .word 8, 100, 87, 3, 7, 9, 2, 7, 23, 32	#create array which holds numbers
message1: .asciiz "Second Maximum: "			#message to be printed
message2: .asciiz "Second Minimum: "			#message to be printed

.text
main:
		la $s7, numbers			#load address of numbers into $s7
		
		li $s0, 0				#initialize counter 1 for loop 1
		li $s6, 10 				#n - 1
		
		li $s3, 200				# Minimum                           
		li $s4, 300				# Second Minimum
		
		li $s1, 0				# Maximum
		li $s2, -1				# Second Maximum

loop:
	slt $t2, $s0, $s6
	beq $t2, $zero, final 
	
	sll $t7, $s0, 2				#multiply $s1 by 4 and put it in t7
	add $t7, $s7, $t7 				#add the address of numbers to t7
	
	lw $t0, 0($t7)  				#load numbers[j]
	
	slt $t2, $t0, $s3  				# t0 < s3
	bne $t2, $zero, less_than_min
	
	slt $t2, $t0, $s4
	bne $t2, $zero, less_than_second_min
	
	j check_max

less_than_min:
	move $s4, $s3
	move $s3, $t0
	
	j check_max
	
less_than_second_min:
	move $s4, $t0
	
check_max:
	slt $t2, $s2, $t0
	bne $t2, $zero, more_than_max
	
	slt $t2, $s1, $t0
	bne $t2, $zero, more_than_second_max
	
	addi $s0, $s0, 1
	j loop
	
more_than_max:
	move $s1, $s2
	move $s2, $t0
	
	addi $s0, $s0, 1
	j loop

more_than_second_max:
	move $s1, $t0
	
	addi $s0, $s0, 1
	j loop
	
final:
	li $v0,4
	la $a0,message1
	syscall
	
	li $v0, 1
	move $a0, $s1
	syscall
	
	li $v0,4
	la $a0,message2
	syscall	
	
	li $v0, 1
	move $a0, $s4
	syscall	
	
	li $v0,10
	syscall
	
	

