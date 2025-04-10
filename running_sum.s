.data
string1: .asciiz "Enter a number:"
string2: .asciiz "Sum of numbers entered: "

.text
main:
	li $s0, 0   
	
process:
	li $v0,4
	la $a0,string1
	syscall
	
	li $v0,5
	syscall
	move $t0,$v0
	
	beq $t0, $zero, final
	add $s0, $s0, $t0
	j process

final:
	li $v0,4
	la $a0,string2
	syscall
	
	li $v0, 1
	move $a0, $s0
	syscall
	
	li $v0, 10					#end program
	syscall
	
