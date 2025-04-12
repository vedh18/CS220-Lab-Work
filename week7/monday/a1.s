.data
string1: .asciiz "Enter a the value of x: "
string2: .asciiz "Enter a the value of y: "
string3: .asciiz "The result x^y is: "

.text
main:
	li $v0,4
	la $a0,string1
	syscall

	li $v0,5
	syscall
	move $t0,$v0

	li $v0,4
	la $a0,string2
	syscall

	li $v0,5
	syscall
	move $t1,$v0

	li $t5, 1
	# x^y
	# if (y == 0) return 1
	# if (y %2) x * f(x, y/2) * f(x, y/2)
	# else f(x, y/2) * f(x, y/2)
	
	# result = 1
	# while (y >0){
	#	if (y & 1) {
	#		result *= x
	#	}
	#	x *= x
	#	y = y>>1	
	#}
f:
	# $t0, $t1
	beq $t1, $zero, exit
	andi $t3, $t1, 1
	bne $t3, $zero, extra
	mul $t0, $t0, $t0
	srl $t1, $t1, 1
	j f

extra:
	mul $t5, $t5, $t0
	mul $t0, $t0, $t0
	srl $t1, $t1, 1
	j f

exit:
	li $v0,4
	la $a0,string3
	syscall

	li $v0,1
	move $a0,$t5
	syscall

	li $v0,10
	syscall
