.data
	output: .asciiz "####################################################################\n# PROJETO DE ARQUITETURA DE COMPUTADORES 2023/2024 - UAL\n# TEMA: Calculadora Científica Fase: 3\n# GRUPO:\n# 30012356 Gonçalo Miranda\n# 30012684 Guilherme Restolho\n# 30012583 Afonso Soeiro\n####################################################################"
	prompt: .asciiz "\nInsira um número: "
	sair: .asciiz "\n0- Sair"
	help: .asciiz "\nBem-vindo ao sistema Help"
	output1: .asciiz "\n1- Como foi calculado o logaritmo?"
	output2: .asciiz "\n2- Como foi calculado o seno?"
	output3: .asciiz "\n3- Como foi calculado o cosseno?"
	output4: .asciiz "\n4- Como foi calculado a potência?"
	file_log: .asciiz "logaritmo.txt"
	file_seno: .asciiz "seno.txt"
	file_cosseno: .asciiz "cosseno.txt"
	file_potencia: .asciiz "potencia.txt"
	buffer: .space 256
	buffer_len: .word 256
	erro: .asciiz "\nErro ao tentar abrir ficheiro"

.text

main:
	li $v0, 4
	la $a0, output
	syscall
	la $a0, help
	syscall

__loop_principal:
	li $t1, 1
	li $t2, 2
	li $t3, 3
	li $t4, 4
	li $v0, 4
	la $a0, output1
	syscall
	la $a0, output2
	syscall
	la $a0, output3
	syscall
	la $a0, output4
	syscall
	la $a0, sair
	syscall
	la $a0, prompt
	syscall
	li $v0, 5
	syscall
	move $t0, $v0
	beqz $t0, __fim
	beq $t1, $t0, calc_log
	beq $t2, $t0, calc_sen
	beq $t3, $t0, calc_cos
	beq $t4, $t0, calc_potencia
	j __loop_principal

calc_potencia:
	li $v0, 13 #abrir
    	la $a0, file_potencia
    	li $a1, 0 # Mode: read-only
    	li $a2, 0
    	syscall
	move $s0, $v0
	bltz $s0, __sair_erro
	j loop_ler

calc_cos:
	li $v0, 13 #abrir
    	la $a0, file_cosseno
    	li $a1, 0 # Mode: read-only
    	li $a2, 0
    	syscall
	move $s0, $v0
	bltz $s0, __sair_erro
	j loop_ler

calc_sen:
	li $v0, 13 #abrir
    	la $a0, file_seno
    	li $a1, 0 # Mode: read-only
    	li $a2, 0
    	syscall
	move $s0, $v0
	bltz $s0, __sair_erro
	j loop_ler

calc_log:
	li $v0, 13 #abrir
    	la $a0, file_log
    	li $a1, 0 # Mode: read-only
    	li $a2, 0
    	syscall
	move $s0, $v0
	bltz $s0, __sair_erro

loop_ler:
	li $v0, 14 #ler
	move $a0, $s0
	la $a1, buffer
	lw $a2, buffer_len
	syscall
	
	move $s1, $v0  #numero de bytes lido
	beqz $s1, __fechar_ficheiro
	la $t0, buffer
	add $t0, $t0, $s1 # ir para o ultimo caracter
	sb $zero, 0($t0) # null terminate
	
	li $v0, 4
	la $a0, buffer
	syscall
	
	j loop_ler


__fechar_ficheiro:
	li $v0, 16 #fechar 
	move $a0, $s0
	syscall
	j __loop_principal
	
	
__sair_erro:
	li $v0, 4
	la $a0, erro
	syscall
	j __fim
__fim:
	li $v0, 10
	syscall
