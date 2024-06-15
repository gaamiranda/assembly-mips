.data
	output: .asciiz "####################################################################\n# PROJETO DE ARQUITETURA DE COMPUTADORES 2023/2024 - UAL\n# TEMA: Calculadora Científica Fase: 4\n# GRUPO:\n# 30012356 Gonçalo Miranda\n# 30012684 Guilherme Restolho\n# 30012583 Afonso Soeiro\n####################################################################"


.text
main:
    li $v0, 4
    la $a0, output
    syscall
    li $t0, 0xFFA500 # laranja
    li $t4, 0x000000 # preto
    li $t1, 0x10008000 # endereco inicial
    li $t2, 16384 # preencher tudo
    
    li $t3, 0
    
loop:
    sw $t0, 0($t1)
    addi $t1, $t1, 4
    addi $t3, $t3, 1
    bne $t3, $t2, loop

retangulo:
    li $t1, 0x1000C060
    li $t3, 0
    li $t2, 70 #80
    li $t5, 80 #66
    move $t6, $t1

rows:
    li $t3, 0
    
linha_retangulo:
    sw $t4, 0($t1)
    addi $t1, $t1, 4
    addi $t3, $t3, 1
    bne $t3, $t2, linha_retangulo
    
    addi $t6, $t6, 512
    move $t1, $t6
    addi $t5, $t5, -1 
    bnez $t5, rows

show_bar:
    li $t4, 0x53D8B9
    li $t7, 0x1000C060
    addi $t7, $t7, 4096
    move $t1, $t7
    li $t8, 10
    li $t3, 0
    li $t2, 70 #70

bar_rows:
    li $t3, 0
    
linha_branca:
    sw $t4, 0($t1)
    addi $t1, $t1, 4
    addi $t3, $t3, 1
    bne $t3, $t2, linha_branca 

    addi $t7, $t7, 512
    move $t1, $t7
    addi $t8, $t8, -1
    bnez $t8, bar_rows
    

draw_squares:
    li $t4, 0xFFFFFF
    li $t9, 0x1000F060
    li $t2, 10
    li $t6, 4
    li $t5, 3
    li $t7, 20
    li $t8, 0

row_loop:
    li $t0, 0
    move $t1, $t9

column_loop:
    li $t3, 0

draw_square_rows:
    li $t2, 0

draw_square_cols:
    sw $t4, 0($t9)
    addi $t9, $t9, 4
    addi $t2, $t2, 1
    bne $t2, 10, draw_square_cols

    addi $t9, $t9, 512
    subi $t9, $t9, 40
    addi $t3, $t3, 1
    bne $t3, 10, draw_square_rows

    #proxima coluna
    move $t9, $t1
    addi $t9, $t9, 80
    addi $t1, $t1, 80
    addi $t0, $t0, 1
    bne $t0, $t6, column_loop

    addi $t9, $t9, 8192
    subi $t9, $t9, 320
    addi $t8, $t8, 1
    bne $t8, $t5, row_loop 

end:
    li $v0, 10
    syscall









