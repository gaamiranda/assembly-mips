.data
	output: .asciiz "####################################################################\n# PROJETO DE ARQUITETURA DE COMPUTADORES 2023/2024 - UAL\n# TEMA: Calculadora Científica Fase: 1\n# GRUPO:\n# 30012356 Gonçalo Miranda\n# 30012684 Guilherme Restolho\n# 30012583 Afonso Soeiro\n####################################################################"
	output1: .asciiz "\n1- Adição"
	output2: .asciiz "\n2- Subtração"
	output3: .asciiz "\n3- Multiplicação"
	output4: .asciiz "\n4- Divisão"
	output5: .asciiz "\n5- Conversão decimal binário"
	output6: .asciiz "\n6- Conversão decimal hexadecimal"
	output7: .asciiz "\n7- Conversão binário decimal"
	output8: .asciiz "\n8- Conversão binário hexadecimal"
	output9: .asciiz "\n9- Conversão hexadecimal decimal"
	output0: .asciiz "\n10- Conversão hexadecimal binário"
	end: .asciiz "\n0- Fim do programa"
	prompt1: .asciiz "\nInsira uma opção: "
	prompt2: .asciiz "Insira um número: "
	resultado: .asciiz "O resultado é: "
	x: .asciiz "0x"
	buffer: .space 33
	erro_zero_msg: .asciiz "Erro, não é possível dividir por zero!"
	zero: .float 0.0
	empty: .space 16
	prompt_binario: .asciiz "Insira um número em binário: "
	cv_array2:      .space 16
	cv_bin_num:     .space 16
	bufferr: .space 10
	erro: .asciiz "\nErro, valor inválido"

.text

main:
	li $v0, 4
	la $a0, output
	syscall
__loop:
	li $t1, 1
	li $t2, 2
	li $t3, 3
	li $t4, 4
	li $t5, 5
	li $t6, 6
	li $t7, 7
	li $t8, 8
	li $t9, 9
	li $s0, 10
	li $v0, 4
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
	la $a0, output6
	syscall
	la $a0, output7
	syscall
	la $a0, output8
	syscall
	la $a0, output9
	syscall
	la $a0, output0
	syscall
	la $a0, end
	syscall
	la $a0, prompt1
	syscall
	li $v0, 5
	syscall
	move $t0, $v0 # opcao que vem do utilizador
	#diferentes opcoes
	beq $t0, $t1, adicao
	beq $t0, $t2, subtracao
	beq $t0, $t3, multiplicacao
	beq $t0, $t4, divisao
	beq $t0, $t5, db
	beq $t0, $t6, dh
	beq $t0, $t7, bd
	beq $t0, $t8, bh
	beq $t0, $t9, hd
	#beq $t0, $s0, hb
	#fim do programa aqui
	beq $t0, $zero, fim
	j __loop

hd:
    li $v0, 4
    la $a0, prompt2
    syscall

    li $v0, 8
    la $a0, bufferr
    li $a1, 10 # numero maximo de caracteres a ler
    syscall

    la $t0, bufferr       # Load address of input buffer
    li $t1, 0            # Initialize the result to 0

convert_loopp:
    lb $t2, 0($t0)       # Load the next character
    beqz $t2, end_convert # If null terminator, end loop

    # Check if character is a digit (0-9)
    li $t3, '0'
    li $t4, '9'
    blt $t2, $t3, not_digit
    bgt $t2, $t4, not_digit

    sub $t2, $t2, $t3    # Convert ASCII to integer (0-9)
    j add_to_result

not_digit:
    # Check if character is a letter (A-F or a-f)
    li $t3, 'A'
    li $t4, 'F'
    blt $t2, $t3, lower_case
    ble $t2, $t4, upper_case

lower_case:
    li $t3, 'a'
    li $t4, 'f'
    blt $t2, $t3, invalid_char
    bgt $t2, $t4, invalid_char

    sub $t2, $t2, 'a'
    addi $t2, $t2, 10
    j add_to_result

upper_case:
    sub $t2, $t2, 'A'
    addi $t2, $t2, 10
    j add_to_result

invalid_char:
	li $v0, 4
	la $a0, erro
	syscall
	j __loop


add_to_result:
    sll $t1, $t1, 4     # Multiply current result by 16
    add $t1, $t1, $t2   # Add the new digit
    addi $t0, $t0, 1    # Move to the next character
    j convert_loopp

end_convert:
    # Print the result
    li $v0, 4
    la $a0, resultado
    syscall

    li $v0, 1
    move $a0, $t1
    syscall

    j __loop
		
	
bh:
  	j bindec

dechex:
    move $a1, $s1
    li $v0, 4
    la $a0, resultado
    syscall

    li $t0, 8
    la $t3, cv_array2
    j escrever_hex

escrever_hex:
    beqz $t0, escrever_hex3 # Exit branch if counter is zero
    rol $a1, $a1, 4 # Rotate left 4 bits
    and $t4, $a1, 0xf # Variable with 1111
    ble $t4, 9, soma_hex # If less than or equal to 9, jump to sum
    addi $t4, $t4, 55 # If greater than 9, add 55 to $t4
    b escrever_hex2

soma_hex:
    addi $t4, $t4, 48 # Add 48 to $t4

escrever_hex2:
    sb $t4, 0($t3) # Store hexadecimal digit in result
    addi $t3, $t3, 1 # Increment counter
    addi $t0, $t0, -1 # Decrement counter loop
    j escrever_hex

escrever_hex3:
    # Print hexadecimal result
    li $v0, 4
    la $a0, x
    syscall
    la $a0, cv_array2
    syscall

    j __loop

bindec:
    li $v0, 4
    la $a0, prompt_binario
    syscall

    la $a0, cv_bin_num
    li $a1, 16 # Load 16 bits max length in $a1
    li $v0, 8
    syscall

    li $t4, 0

startConver:
    la $t1, cv_bin_num
    li $t9, 16 # Start counter

firstByt:
    lb $a0, ($t1) # Load the first byte
    blt $a0, 48, printSu
    addi $t1, $t1, 1
    subi $a0, $a0, 48 # Subtract 48 to convert to integer
    subi $t9, $t9, 1
    beq $a0, 0, isZer
    beq $a0, 1, isOn
    j printSu

isZer:
    j firstByt

isOn:
    li $t8, 1
    sllv $t5, $t8, $t9
    add $t4, $t4, $t5 # Add $t5 to $t4

    move $a0, $t4
    j firstByt

printSu:
    srlv $t4, $t4, $t9
    move $s1, $t4
    j dechex	


bd:

	li $v0, 4        # Print string system call
	la $a0, prompt_binario         #"Please insert value (A > 0) : "
	syscall

	la $a0, empty
	li $a1, 16              # load 16 as max length to read into $a1
	li $v0,8                # 8 is string system call
	syscall

	li $t4, 0               # initialize sum to 0

startConvert:
  	la $t1, empty
  	li $t9, 16             # initialize counter to 16

firstByte:
  	lb $a0, ($t1)      # load the first byte
  	blt $a0, 48, printSum    # I don't think this line works 
  	addi $t1, $t1, 1          # increment offset
  	subi $a0, $a0, 48         # subtract 48 to convert to int value
  	subi $t9, $t9, 1          # decrement counter
  	beq $a0, 0, isZero
  	beq $a0, 1, isOne
  	j convert     # 

isZero:
   	j firstByte

 isOne:                   # do 2^counter 
   	li $t8, 1               # load 1
   	sllv $t5, $t8, $t9    # shift left by counter = 1 * 2^counter, store in $t5
   	add $t4, $t4, $t5         # add sum to previous sum 
   	j firstByte

convert:

printSum:
   	srlv $t4, $t4, $t9

   	la $a0, resultado
   	li $v0, 4
   	syscall

 	move $a0, $t4      # load sum
 	li $v0, 1      # print int
 	syscall
 	j __loop
dh:
	#decimal->hexadecimal
	li $v0, 4
	la $a0, prompt2
	syscall
	li $v0, 5
	syscall
	move $t5, $v0 #numero a passar para binario
	li $v0, 4
	la $a0, resultado
	syscall
	la $t1, buffer
	li $t2, 8

__convert_loop_hex:
	beqz $t2, __print_hexadecimal
	addi $t2, $t2, -1
	mul $t4, $t2, 4 
	srlv $t3, $t5, $t4
	andi $t3, $t3, 0xF
	blt $t3, 10, __convert_digit
	addi $t3, $t3, 55
	sb $t3, 0($t1)
	addi $t1, $t1, 1
	j __convert_loop_hex

__convert_digit:
	addi $t3, $t3, 48
	sb $t3, 0($t1)
	addi $t1, $t1, 1
	j __convert_loop_hex

__print_hexadecimal:
	sb $zero, 0($t1)
	li $v0, 4
	la $a0, x
	syscall
	la $a0, buffer
	syscall
	j __loop

db:
	#decimal->binario
	li $v0, 4
	la $a0, prompt2
	syscall
	li $v0, 5
	syscall
	move $t5, $v0 #numero a passar para binario
	li $v0, 4
	la $a0, resultado
	syscall
	la $t1, buffer
	li $t2, 32
__convert_loop:
	beqz $t2, __print_binary
    	addi $t2, $t2, -1
    	srlv $t3, $t5, $t2
  	andi $t3, $t3, 1
 	addi $t3, $t3, 48
   	sb $t3, 0($t1)
   	addi $t1, $t1, 1
   	j __convert_loop

__print_binary:
	sb $zero, 0($t1)
	li $v0, 4
	la $a0, buffer
	syscall
	j __loop
		
fim:
	li $v0, 10
	syscall

adicao: #numero1->$f1, numero2->$f2
	li $v0, 4
	la $a0, prompt2
	syscall
	li $v0, 6
	syscall
	mov.s $f1, $f0
	li $v0, 4
	la $a0, prompt2
	syscall
	li $v0, 6
	syscall
	mov.s $f2, $f0
	add.s $f2, $f2, $f1
	li $v0, 4
	la $a0, resultado
	syscall
	li $v0, 2
	mov.s $f12, $f2
	syscall
	j __loop
	
subtracao:
	li $v0, 4
	la $a0, prompt2
	syscall
	li $v0, 6
	syscall
	mov.s $f1, $f0
	li $v0, 4
	la $a0, prompt2
	syscall
	li $v0, 6
	syscall
	mov.s $f2, $f0
	sub.s $f2, $f1, $f2
	li $v0, 4
	la $a0, resultado
	syscall
	li $v0, 2
	mov.s $f12, $f2
	syscall
	j __loop
	
multiplicacao:
	li $v0, 4
	la $a0, prompt2
	syscall
	li $v0, 6
	syscall
	mov.s $f1, $f0
	li $v0, 4
	la $a0, prompt2
	syscall
	li $v0, 6
	syscall
	mov.s $f2, $f0
	mul.s $f2, $f2, $f1
	li $v0, 4
	la $a0, resultado
	syscall
	li $v0, 2
	mov.s $f12, $f2
	syscall
	j __loop
	
divisao:
	li $v0, 4
	la $a0, prompt2
	syscall
	li $v0, 6
	syscall
	mov.s $f1, $f0
	li $v0, 4
	la $a0, prompt2
	syscall
	li $v0, 6
	syscall
	mov.s $f2, $f0
	la $t0, zero
	l.s $f0, 0($t0)
	c.eq.s $f2, $f0
	bc1t __divisao_por_zero
	div.s $f3, $f1, $f2
	mul.s $f4, $f3, $f2
    	sub.s $f5, $f1, $f4
	li $v0, 4
	la $a0, resultado
	syscall
	li $v0, 2
	mov.s $f12, $f3
	syscall
	j __loop

__divisao_por_zero:
	li $v0, 4
	la $a0, erro_zero_msg
	syscall
	j __loop
