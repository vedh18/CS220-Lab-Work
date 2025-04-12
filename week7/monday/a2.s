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
    move $s1, $s3
    move $s2, $s2
    move $s3, $s1
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

    addi $s0, $s0, -1
    move $s1, $s3
    move $s2, $s2
    move $s3, $s1
    jal hanoi

    jr $ra

return_hanoi:
    jr $ra

end_hanoi:
    li $v0, 10
    syscall
