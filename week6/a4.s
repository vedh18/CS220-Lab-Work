.data
string1: .asciiz "Enter a number:"
string2: .asciiz "Factorial of the entered Number: "


.text
main:
	li $s0, 1
	
	li $v0,4
	la $a0,string1
	syscall	
	
	li $v0,5
	syscall
	move $t0,$v0
	
loop:
	slt $t1, $t0, 1
	bne $t1, $zero, final
	
	mul $s0, $s0, $t0
	sub $t0, $t0, 1
	
	j loop

final:
	li $v0,4
	la $a0,string2
	syscall
	
	li $v0, 1
	move $a0, $s0
	syscall
	
	li $v0, 10					#end program
	syscall  
