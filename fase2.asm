.data
	output: .asciiz "####################################################################\n# PROJETO DE ARQUITETURA DE COMPUTADORES 2023/2024 - UAL\n# TEMA: Calculadora Científica Fase: 2\n# GRUPO:\n# 30012356 Gonçalo Miranda\n# 30012684 Guilherme Restolho\n# 30012583 Afonso Soeiro\n####################################################################"
	saida: .asciiz "\n0- Fim programa"
	output1: .asciiz "\n1- Logaritmo"
	output2: .asciiz "\n2- Potência"
	output3: .asciiz "\n3- Raíz"
	output4: .asciiz "\n4- Seno"
	output5: .asciiz "\n5- Cosseno"
	prompt: .asciiz "\nInsira um número: "
	seno_prompt: .asciiz "Insira um ângulo em graus: "
	raiz_prompt: .asciiz "\nInsira uma raiz: "
	expoente: .asciiz "\nInsira um expoente: "
	resultado: .asciiz "\nO resultado é: "
	erro: .asciiz "\nValor não aceite"
	result_10: .asciiz "\nLogaritmo 10: "
	result_2: .asciiz "\nLogaritmo 2: "
	epsilon: .float 0.00001
    	one: .float 1.0
    	float_zero: .float 0.1
    	pi: .float 3.14159265
	degree_to_radian: .float 0.0174532925
	two: .float 2.0
	four: .float 4.0
	six: .float 6.0
	twelve: .float 12.0
	twentyfour: .float 24.0
	seven_twenty: .float 720.0
	pi_div_180: .float 0.0174532925199433
	um: .float 1.0
.text

main:
	li $v0, 4
	la $a0, output
	syscall

__loop_principal:
	li $t1, 1
	li $t2, 2
	li $t3, 3
	li $t4, 4
	li $t5, 5
	li $v0, 4
	la $a0, output1
	syscall
	la $a0, output2
	syscall
	la $a0, output3
	syscall
	la $a0, output4
	syscall
	la $a0, output5
	syscall
	la $a0, saida
	syscall
	la $a0, prompt
	syscall
	li $v0, 5
	syscall
	move $t0, $v0
	beq $t0, $zero, __fim
	beq $t0, $t1, logaritmo
	beq $t0, $t2, potencia
	beq $t0, $t3, raiz
	beq $t0, $t4, seno
	beq $t0, $t5, cosseno
	j __loop_principal


cosseno:
	li $v0, 4
    	la $a0, seno_prompt
    	syscall

    	li $v0, 6
    	syscall
    	mov.s $f12, $f0  #input vai para f12

    	#graus para radianos
    	l.s $f1, pi_div_180
    	mul.s $f12, $f12, $f1

	#taylor serie expansion
    	l.s $f2, one      # $f2 = 1.0
   	 l.s $f10, two     # $f10 = 2.0
   	 l.s $f16, twentyfour  # $f16 = 24.0
    	l.s $f18, seven_twenty  # $f18 = 720.0

    	# primeiro termo (1.0)
    	mov.s $f6, $f2   # $f6 = 1.0

    	# segundo termo (-x^2 / 2!)
    	mul.s $f8, $f12, $f12    # $f8 = x^2
    	div.s $f8, $f8, $f10     # $f8 = x^2 / 2
    	sub.s $f2, $f2, $f8      # sum = sum - x^2 / 2

    	# terceiro termo (x^4 / 4!)
    	mul.s $f8, $f8, $f12     # $f8 = x^3 / 2
   	mul.s $f8, $f8, $f12     # $f8 = x^4 / 2
    	div.s $f8, $f8, $f16     # $f8 = x^4 / 24
    	add.s $f2, $f2, $f8      # sum = sum + x^4 / 24

    	# quarto termo (-x^6 / 6!)
    	mul.s $f8, $f8, $f12     # $f8 = x^5 / 24
    	mul.s $f8, $f8, $f12     # $f8 = x^6 / 24
    	div.s $f8, $f8, $f18     # $f8 = x^6 / 720
    	sub.s $f2, $f2, $f8      # sum = sum - x^6 / 720

    	# Print
    	li $v0, 4
    	la $a0, resultado
    	syscall

    	mov.s $f12, $f2
    	li $v0, 2
    	syscall
    	
    	j __loop_principal

seno:
    	li $v0, 4
    	la $a0, seno_prompt
    	syscall
    	
    	li $v0, 6
    	syscall
    	mov.s $f12, $f0

    la $t0, degree_to_radian
    l.s $f1, 0($t0)
    mul.s $f12, $f12, $f1

    # taylor series
    mov.s $f0, $f12          # x
    mov.s $f1, $f12          # x^1
    mul.s $f2, $f12, $f12    # x^2

    # x^3 / 3!
    mul.s $f3, $f1, $f2      # x^3
    li $t1, 6
    mtc1 $t1, $f4
    cvt.s.w $f4, $f4
    div.s $f3, $f3, $f4
    sub.s $f0, $f0, $f3

    # x^5 / 5!
    mul.s $f3, $f3, $f2      # x^5
    li $t1, 120
    mtc1 $t1, $f4
    cvt.s.w $f4, $f4
    div.s $f3, $f3, $f4
    add.s $f0, $f0, $f3

    # x^7 / 7!
    mul.s $f3, $f3, $f2      # x^7
    li $t1, 5040
    mtc1 $t1, $f4
    cvt.s.w $f4, $f4
    div.s $f3, $f3, $f4
    sub.s $f0, $f0, $f3

    li $v0, 4
    la $a0, resultado
    syscall
    li $v0, 2
    mov.s $f12, $f0
    syscall
    j __loop_principal


raiz: # numero -> $f12, raiz -> $t3
	# Print prompt for number
    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 6
    syscall
    mov.s $f12, $f0
    la $t0, float_zero
    l.s $f0, 0($t0)
    c.lt.s $f12, $f0
    bc1t  __valor_invalido

   
    li $v0, 4
    la $a0, raiz_prompt
    syscall

    li $v0, 5
    syscall
    move $t3, $v0
    ble $t3, $zero, __valor_invalido

    mtc1 $t3, $f16
    cvt.s.w $f16, $f16

    div.s $f4, $f12, $f16

    la $t1, epsilon
    l.s $f6, 0($t1)

babylonian_iter:
    la $t2, one
    l.s $f18, 0($t2)
    sub.s $f18, $f16, $f18  # $f18 = root_number - 1

    mul.s $f8, $f18, $f4

    move $t4, $t3  # $t4 = root number
    sub $t4, $t4, 1  # $t4 = root number - 1
    mov.s $f20, $f4  # $f20 = x0
    pow_loop:
        sub $t4, $t4, 1
        beqz $t4, pow_end
        mul.s $f20, $f20, $f4  # $f20 = $f20 * x0
        j pow_loop
    pow_end:

    div.s $f20, $f12, $f20

    add.s $f8, $f8, $f20

    
    div.s $f10, $f8, $f16

    sub.s $f8, $f10, $f4
    abs.s $f8, $f8
    c.lt.s $f8, $f6
    bc1t __print_result_raiz

    mov.s $f4, $f10
    j babylonian_iter

__print_result_raiz:
    li $v0, 4
    la $a0, resultado
    syscall

    mov.s $f12, $f10
    li $v0, 2
    syscall
    j __loop_principal

potencia: #numero -> $f0, expoente -> $t1, total -> $f2
	li $v0, 4
	la $a0, prompt
	syscall
	li $v0, 6
	syscall
	mov.s $f0, $f0 #numero
	li $v0, 4
	la $a0, expoente
	syscall
	li $v0, 5
	syscall
	move $t1, $v0 #expoente
	beqz $t1, __valor_zero
	blt $t1, $zero, __valor_invalido
	li $t2, 1
	mtc1 $t2, $f2
	cvt.s.w $f2, $f2
	j __loop_potencia

__valor_zero:
	li $v0, 4
	la $a0, resultado
	syscall
	li $v0, 2
	mov.s $f12, $f0
	syscall
	j __loop_principal

__loop_potencia:
	beq $t1, $zero, __saida_potencia
	mul.s $f2, $f2, $f0
	subi $t1, $t1, 1
	j __loop_potencia
	
__saida_potencia:
	li $v0, 4
	la $a0, resultado
	syscall
	li $v0, 2
	mov.s $f12, $f2
	syscall
	j __loop_principal

__valor_invalido:
	li $v0, 4
	la $a0, erro
	syscall
	j __loop_principal

__fim:
	li $v0, 10	
	syscall


logaritmo:  # Label para o in�cio da fun��o de logaritmo

li $v0, 4  # Carrega o c�digo de syscall para imprimir string
la $a0, prompt  # Carrega o endere�o da mensagem prompt em $a0
syscall  # Chamada de sistema para imprimir a mensagem

# Ler n�mero flutuante
li $v0, 6  # Carrega o c�digo de syscall para ler um float
syscall  # Chamada de sistema para ler o n�mero
mov.s $f12, $f0  # Move o n�mero lido para $f12
mov.s $f3, $f0  # Move o n�mero lido para $f3 (para uso posterior)

# Chamada da fun��o log2
jal log2  # Chama a fun��o log2

# Imprimir resultado log2
li $v0, 4  # Carrega o c�digo de syscall para imprimir string
la $a0, result_2  # Carrega o endere�o da mensagem result_2 em $a0
syscall  # Chamada de sistema para imprimir a mensagem

# Imprimir log base 2
li $v0, 2  # Carrega o c�digo de syscall para imprimir um float
mov.s $f12, $f0  # Move o resultado de log2 para $f12
syscall  # Chamada de sistema para imprimir o n�mero

mov.s $f12, $f3  # Move o n�mero original lido para $f12

# Chamada da fun��o log10
jal log10  # Chama a fun��o log10

# Imprimir resultado log10
li $v0, 4  # Carrega o c�digo de syscall para imprimir string
la $a0, result_10  # Carrega o endere�o da mensagem result_10 em $a0
syscall  # Chamada de sistema para imprimir a mensagem

# Imprimir log base 10
li $v0, 2  # Carrega o c�digo de syscall para imprimir um float
mov.s $f12, $f0  # Move o resultado de log10 para $f12
syscall  # Chamada de sistema para imprimir o n�mero

j __loop_principal  # Salta para a label 'sair' para terminar o programa

# Procedimento para calcular o logaritmo natural (ln)
lnx:

# Iniciar os registradores
li $t1, 1000  # Carrega o limite superior para o loop

# Converter 1 para float
li $t5, 1  # Carrega o valor 1 em $t5
mtc1 $t5, $f5  # Move o valor 1 para o registrador de ponto flutuante $f5
cvt.s.w $f5, $f5  # Converte o inteiro em $f5 para float

# Armazenar x
mov.s $f4, $f12  # Move x para $f4
sub.s $f4, $f4, $f5  # Calcula (x - 1)
add.s $f6, $f12, $f5  # Calcula (x + 1)
div.s $f4, $f4, $f6  # Calcula t = (x-1)/(x+1)

mul.s $f9, $f4, $f4  # Calcula n = t * t

mov.s $f10, $f4  # Inicializa a soma com t

# Contador
li $t0, 3  # Inicializa o contador com 3

# Loop
loop:
bge $t0, $t1, ExitLoop1  # Se o contador for maior ou igual a 1000, sai do loop

# Atualiza t = t * n
mul.s $f4, $f4, $f9  # Calcula t = t * n

# Converte $t0 para float
mtc1 $t0, $f7  # Move o contador para $f7
cvt.s.w $f7, $f7  # Converte o contador para float

# Atualiza a soma (sum)
div.s $f6, $f4, $f7  # Calcula t/i
add.s $f10, $f10, $f6  # Atualiza a soma

addi $t0, $t0, 2  # Incrementa o contador em 2

j loop  # Volta para o in�cio do loop

# Sair do loop
ExitLoop1:
add.s $f10, $f10, $f10  # Multiplica a soma por 2
mov.s $f0, $f10  # Move o resultado final para $f0

# Retorna para a fun��o chamadora
jr $ra  # Retorna para o endere�o de retorno

# Fun��o para calcular log2(x)
log2:
addi $sp, $sp, -4  # Reserva espa�o na pilha para armazenar o endere�o de retorno
sw $ra, 0($sp)  # Salva o endere�o de retorno na pilha

jal lnx  # Chama a fun��o lnx para calcular ln(x)
mov.s $f1, $f0  # Armazena o resultado de ln(x) em $f1

lw $ra, 0($sp)  # Restaura o endere�o de retorno
addi $sp, $sp, 4  # Libera o espa�o na pilha

# Converte 2 para float
li $t5, 2  # Carrega o valor 2 em $t5
mtc1 $t5, $f12  # Move o valor 2 para o registrador de ponto flutuante $f12
cvt.s.w $f12, $f12  # Converte o inteiro 2 para float

addi $sp, $sp, -4  # Reserva espa�o na pilha para armazenar o endere�o de retorno
sw $ra, 0($sp)  # Salva o endere�o de retorno na pilha

jal lnx  # Chama a fun��o lnx para calcular ln(2)
mov.s $f2, $f0  # Armazena o resultado de ln(2) em $f2

lw $ra, 0($sp)  # Restaura o endere�o de retorno
addi $sp, $sp, 4  # Libera o espa�o na pilha

div.s $f0, $f1, $f2  # Calcula log2(x) = ln(x) / ln(2)
jr $ra  # Retorna para a fun��o chamadora

# Fun��o para calcular log10(x)
log10:
addi $sp, $sp, -4  # Reserva espa�o na pilha para armazenar o endere�o de retorno
sw $ra, 0($sp)  # Salva o endere�o de retorno na pilha

jal lnx  # Chama a fun��o lnx para calcular ln(x)
mov.s $f1, $f0  # Armazena o resultado de ln(x) em $f1

lw $ra, 0($sp)  # Restaura o endere�o de retorno
addi $sp, $sp, 4  # Libera o espa�o na pilha

# Converte 10 para float
li $t5, 10  # Carrega o valor 10 em $t5
mtc1 $t5, $f12  # Move o valor 10 para o registrador de ponto flutuante $f12
cvt.s.w $f12, $f12  # Converte o inteiro 10 para float

addi $sp, $sp, -4  # Reserva espa�o na pilha para armazenar o endere�o de retorno
sw $ra, 0($sp)  # Salva o endere�o de retorno na pilha

jal lnx  # Chama a fun��o lnx para calcular ln(10)
mov.s $f2, $f0  # Armazena o resultado de ln(10) em $f2

lw $ra, 0($sp)  # Restaura o endere�o de retorno
addi $sp, $sp, 4  # Libera o espa�o na pilha

div.s $f0, $f1, $f2  # Calcula log10(x) = ln(x) / ln(10)
jr $ra  # Retorna para a fun��o chamadora


