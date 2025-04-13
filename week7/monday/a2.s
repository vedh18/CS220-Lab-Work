.data
string1: .asciiz "Enter the number of disks: "
string2: .asciiz "Move disk from ROD "
string3: .asciiz " to ROD "
string4: .asciiz "\n"
.text
main:
    li $v0, 4
    la $a0, string1
    syscall

    li $v0, 5
    syscall
    move $t0, $v0

    add $s0, $t0, $zero
    li $s1, 1
    li $s2, 3
    li $s3, 2

    jal hanoi
    j end_hanoi

hanoi:
    beq $s0, 0, return_hanoi

    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s2, 4($sp)
    sw $s3, 0($sp)

    addi $s0, $s0, -1
    # swap s2 and s3
    addi $t1, $s2, 0
    addi $s2, $s3, 0
    addi $s3, $t1, 0
    jal hanoi

    lw $ra, 16($sp)
    lw $s0, 12($sp)
    lw $s1, 8($sp)
    lw $s2, 4($sp)
    lw $s3, 0($sp)
    addi $sp, $sp, 20

    li $v0, 4
    la $a0, string2
    syscall

    li $v0, 1
    move $a0, $s1
    syscall

    li $v0, 4
    la $a0, string3
    syscall

    li $v0, 1
    move $a0, $s2
    syscall

    li $v0, 4
    la $a0, string4
    syscall

    addi $sp, $sp, -20
    sw $ra, 16($sp)
    sw $s0, 12($sp)
    sw $s1, 8($sp)
    sw $s2, 4($sp)
    sw $s3, 0($sp)

    addi $s0, $s0, -1
    # swap $s1 and $s3
    addi $t1, $s1, 0
    addi $s1, $s3, 0
    addi $s3, $t1, 0

    jal hanoi

    lw $ra, 16($sp)
    lw $s0, 12($sp)
    lw $s1, 8($sp)
    lw $s2, 4($sp)
    lw $s3, 0($sp)
    addi $sp, $sp, 20
    jr $ra

return_hanoi:
    jr $ra

end_hanoi:
    li $v0, 10
    syscall
