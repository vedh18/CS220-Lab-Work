.data
string1: .asciiz "Enter the value of n: "

.text
main: 
    li $v0, 4
    la $a0, string1
    syscall

    li $v0, 5
    syscall
    move $t0, $v0
    li $t1, 1
    add $s0, $t0, $zero
    jal fibonacci
    j exit

fibonacci:
    beq $s0, $zero, ret_zero
    beq $s0, $t1, return_fibonacci

    addi $sp, $sp, -8
    sw $ra, 4($sp)
    sw $s0, 0($sp)

    addi $s0, $s0, -1
    jal fibonacci
    move $t2, $v0

    lw $ra, 4($sp)
    lw $s0, 0($sp)
    addi $sp, $sp, 8

    addi $sp, $sp, -12
    sw $ra, 8($sp)
    sw $s0, 4($sp)
    sw $t2, 0($sp)

    addi $s0, $s0, -2
    jal fibonacci

    lw $ra, 8($sp) 
    lw $s0, 4($sp)
    lw $t2, 0($sp)
    addi $sp, $sp, 12
    
    add $v0, $t2, $v0
    jr $ra

return_fibonacci:
    li $v0, 1
    jr $ra

ret_zero:
    li $v0, 0
    jr $ra

exit:
    move $a0, $v0   
    li $v0, 1         
    syscall

    li $v0, 10
    syscall
