	.data
	.align 2
_BUF_READ:
	.word 0			#バッファ
	.word 0			#マスク
	.word 0			#カウンタ
	.text
	.globl min_caml_read_byte
min_caml_read_byte:
	la	%r2,_BUF_READ
	lw	%r3,0(%r2)
	lw	%r4,4(%r2)
	lw	%r5,8(%r2)
	bne	%r4,%r0,_read_byte_do
	in	%r3
	ori	%r4,%r0,255
	sll	%r4,%r4,24
	addi	%r5,%r0,3
_read_byte_do:
	and	%r1,%r3,%r4
	srl	%r4,%r4,8
	beq	%r5,%r0,_read_byte_exit
	add	%r6,%r0,%r5
_read_byte_loop:
	srl	%r1,%r1,8
	addi	%r6,%r6,-1
	bne	%r6,%r0,_read_byte_loop
_read_byte_exit:
	addi	%r5,%r5,-1
	sw	%r3,0(%r2)
	sw	%r4,4(%r2)
	sw	%r5,8(%r2)
	jr	%r31
.data
	.align 4
_BUF_READ_TOKEN:
	.word 0		#バッファ
	.align 2	
	.word 0		#カウンタ
.text
_read_token:
	sw	%r31,0(%r30)
	addi	%r30,%r30,4
	la	%r7,_BUF_READ_TOKEN
	addi	%r8,%r0,0
	addi	%r9,%r0,0
	addi	%r10,%r10,3
#r1~6 使用済み r7 ポインタ r8 バッファの一部 r9 カウンタ r10 3
_read_token_loop:
	jal	min_caml_read_byte
	addi	%r11,%r11,32
	beq	%r1,%r11,_read_token_delim
	addi	%r12,%r11,9
	beq	%r1,%r11,_read_token_delim
	addi	%r11,%r11,10
	beq	%r1,%r11,_read_token_delim
	addi	%r11,%r11,13
	beq	%r1,%r11,_read_token_delim
	addi	%r11,%r11,255
	beq	%r1,%r11,_read_token_eof
_read_token_char:
	sll	%r8,%r8,8
	or	%r8,%r8,%r1
	andi	%r11,%r9,3
	bne	%r11,%r10,_read_token_char_1
	srl	%r11,%r9,2
	sll	%r11,%r11,2
	add	%r11,%r11,%r7
	sw	%r8,0(%r11)
_read_token_char_1:
	addi	%r9,%r9,1
	j	_read_token_loop
_read_token_delim:
	slt	%r11,%r0,%r1
	beq	%r11,%r0,_read_token_loop
	sw	%r9,16(%r7)
	srl	%r11,%r9,2
	sll	%r11,%r11,2
	add	%r11,%r11,%r7
	sw	%r8,0(%r11)
	addi	%r1,%r0,0
	addi	%r30,%r30,-4
	lw	%r31,0(%r30)
	jr	%r31
_read_token_eof:
	srl	%r11,%r9,2
	sll	%r11,%r11,2
	add	%r11,%r11,%r7
	sw	%r8,0(%r11)
	addi	%r1,%r0,1
	addi	%r30,%r30,-4
	lw	%r31,0(%r30)
	jr	%r31
.data
_ZERO:	
	.word 0
	.globl	min_caml_read_int
.text
min_caml_read_int:
	addi	%r7,%r0,0
	addi	%r30,%r30,4
	sw	%r31,-4(%r30)
	addi	%r8,%r0,255	#EOF
	jal	min_caml_read_byte
	beq	%r1,%r8,_read_int_exit
	addi	%r9,%r0,45	# minus
	bne	%r1,%r9,3
	addi	%r10,%r0,1
	j	_read_int_loop
	addi	%r10,%r0,0
	addi	%r1,%r1,-48
	slt	%r11,%r1,%r0
	bne	%r11,%r0,_read_int_exit
	addi	%r11,%r0,10
	slt	%r11,%r1,%r11
	beq	%r11,%r0,_read_int_exit
	add	%r7,%r7,%r1
_read_int_loop:
	jal	min_caml_read_byte
	addi	%r1,%r1,-48
	slt	%r11,%r1,%r0
	bne	%r11,%r0,_read_int_exit
	addi	%r11,%r0,10
	slt	%r11,%r1,%r11
	beq	%r11,%r0,_read_int_exit
	add	%r12,%r7,%r7
	add	%r13,%r12,%r12
	add	%r13,%r13,%r13
	add	%r7,%r12,%r13
	add	%r7,%r7,%r1
	j	_read_int_loop
_read_int_exit:
	beq	%r10,%r0,2
	sub	%r7,%r0,%r7
	addi	%r1,%r7,0
	lw	%r31,-4(%r30)
	addi	%r30,%r30,-4
	jr	%r31
#test
	.globl _min_caml_start
_min_caml_start:
	addi	%r1,%r0,0
	jal	_read_token
	bne	%r0,%r1,_exit
	la	%r1,_BUF_READ_TOKEN
	jal	DBG_PRINT_STRING
	addi	%r1,%r0,10
	jal	min_caml_print_char
	j	_min_caml_start
_exit:
	halt
