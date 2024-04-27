.data
tab: .asciiz "\t"
endl: .asciiz "\n"
producto: .asciiz "El resultado es: "
numero: .asciiz "Ingrese un numero: "
.text
.globl start


start:


addi $a0, $zero, 24
addi $a1, $zero, 4

#Pedir numero 1
la $a0, numero
li $v0, 4
syscall
li $v0, 5
syscall
add $s1, $v0, $zero #Guardo v0 en s1 mientras tanto

#Pedir numero 2
la $a0, numero
li $v0, 4
syscall
li $v0, 5
syscall
add $s2, $v0, $zero #Guardo v0 en s2 mientras tanto

add $a0, $s1, $zero
add $a1, $s2, $zero

jal booth

add $t2, $v0, $zero
add $t1, $v1, $zero


la $a0, producto
li $v0, 4
syscall

add $a0, $t2, $zero 
li $v0, 1
syscall

add $a0, $t1, $zero 
li $v0, 1
syscall

li $v0, 10
syscall




booth:
sw $fp, -4($sp)
add $fp, $sp, 0
addi $sp, $sp, -16 #guardar espacio para stack
sw $ra, -8($fp)
sw $a0, -12($fp)
sw $a1, -16($fp)

#t0 = a0 = M
#v1 = a1 = Q
#v0 = A

add $t0, $a0, $zero
add $v1, $a1, $zero
add $v0, $zero , $zero
#t4 = contador
addi $t4, $zero, 32

loop:
beq $t4, $zero, end_loop #comprueba si el contador ha llegado a 0
#Q - 1 = t5
#Q0 = t6
andi $t6, $v1, 1 #Q 0

blt $t6, $t5, suma # 0 1
bgt $t6, $t5, resta # 1 0
continue:


#CORRIMIENTO ARITMETICO
andi $t7, $v0, 1 # A[0]
sra $v0, $v0, 1 #A

andi $t5, $v1, 1 # Q - 1
srl $v1, $v1, 1 #Q se mueve a la derecha
sll $t7, $t7, 31

or $v1, $v1, $t7


addi $t4, $t4, -1 #Decremento el contador en 1
j loop

suma:
add $v0, $v0, $t0 #A + M

j continue

resta:
sub $v0, $v0, $t0 #A - M
j continue


end_loop:


lw $a1,-16($fp) # put top stack elem in $s0
lw $a0,-12($fp) # put top stack elem in $s0
lw $ra, -8($fp)
addi $sp, $fp, 0
lw $fp, -4($sp)

jr $ra
