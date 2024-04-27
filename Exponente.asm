.data
tab: .asciiz "\t"
endl: .asciiz "\n"
error_mensaje: .asciiz "Hubo un error al mandar los numeros."
base: .asciiz "Ingrese la base: "
exponente: .asciiz "Ingrese el exponente: "
resultado: .asciiz "El resultado es: "

.text
.globl start


start:

#Pedir base
la $a0, base
li $v0, 4
syscall
li $v0, 5
syscall
add $t4, $v0, $zero #Guardo v0 en t2 mientras tanto

#Pedir exponente
la $a0, exponente
li $v0, 4
syscall
li $v0, 5
syscall
add $t5, $v0, $zero #Guardo v0 en t3 mientras tanto

add $a0, $t4, $zero
add $a1, $t5, $zero

jal pot

bltz $v0, done_program

#Cargar v0 en t2
add $t2, $v0, $zero

#MOSTRAR RESULTADO
la $a0, resultado
li $v0, 4
syscall

add $a0, $t2, $zero
li $v0, 1
syscall

done_program:

li $v0, 10
syscall


pot:

sw $fp, -4($sp)
add $fp, $sp, 0
addi $sp, $sp, -16 #guardar espacio para stack
sw $ra, -8($fp)
sw $a0, -12($fp)
sw $a1, -16($fp)

#a0 = base
#a1 = exponente
#v0 = resultado
add $t7, $a0, $zero #a0
add $t8, $a1, $zero #a1

li $t4, 1
slt $t2,$t8, $zero #Exponente negativo
beq $t2, $t4, errors
seq $t3, $t2, $t7  #Si ambos son 0 
beq $t3, $t4, errors

add $a0, $t7, $zero
add $a1, $t8, $zero

#CODIGO
addi $t0, $zero, 0
addi $v0, $zero, 1 #Inicializo el numero en a0
#t0 = contador
loop:
beq $t0, $a1, done #Compara si el contador es igual

add $t3, $v0, $zero
mul $v0, $a0, $v0 #n * n
blt $v0, $t3, errors #Si el valor nuevo es menor que el anterior
addi $t0, $t0, 1  #Incremento contador en 1
j loop


errors:
la $a0, error_mensaje
li $v0, 4
syscall
li $v0, 1
neg $v0, $v0

done:
#CARGA DE NUEVO
lw $a1,-16($fp) # put top stack elem in $s0
lw $a0,-12($fp) # put top stack elem in $s0
lw $ra, -8($fp)
addi $sp, $fp, 0
lw $fp, -4($sp)

jr $ra