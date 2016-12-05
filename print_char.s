	.data
	.align 2
_BUF:
	.word 0		#buffer本体
	.word 0		#カウンタ
.text
	.globl min_caml_print_char
min_caml_print_char:
	la	%r2,_BUF
	lw	%r3,0(%r2)
	lw	%r4,4(%r2)
	sll	%r3,%r3,8
	andi	%r1,%r1,255	#念の為マスク
	or	%r3,%r1,%r3
	addi	%r27,%r0,3
	slt	%r27,%r4,%r27
	beq	%r27,%r0,_print_char_flush_4
	addi	%r4,%r4,1
	sw	%r3,0(%r2)
	sw	%r4,4(%r2)
	jr	%r31
_print_char_flush_4:
	out	%r3
	ori	%r4,%r0,0
	ori	%r3,%r0,0
	sw	%r3,0(%r2)
	sw	%r4,4(%r2)
	jr	%r31
	.globl _print_char_flush
_print_char_flush:	
	la	%r2,_BUF
	lw	%r3,0(%r2)
	lw	%r4,4(%r2)
	addi	%r5,%r0,3
	beq	%r4,%r5,_print_char_flush_do
	addi	%r5,%r5,1
_print_char_flush_loop:		#4バイトに足りない分の空白を詰める(今回はそれで一応問題ない
	sll	%r3,%r3,8
	ori	%r3,%r3,0x20
	addi	%r4,%r4,1
	bne	%r4,%r5,_print_char_flush_loop
_print_char_flush_do:
	out	%r3
	sw	%r0,0(%r2)
	sw	%r0,4(%r2)
	jr	%r31
div10:
	move	%r3,%r1
	ori	%r4,%r0,1
	addi	%r2,%r0,255
	sll	%r2,%r2,24
	and	%r7,%r3,%r2
	beq	%r7,%r0,3
	sll	%r4,%r4,30
	j	div10_init2
	srl	%r2,%r2,8
	and	%r7,%r3,%r2
	beq	%r7,%r0,3
	sll	%r4,%r4,23
	j	div10_init2
	srl	%r2,%r2,8
	and	%r7,%r3,%r2
	beq	%r7,%r0,3
	sll	%r4,%r4,15
	j	div10_init2
	sll	%r4,%r4,7
div10_init2:	
	andi	%r1,%r1,0
div10_0:
	and	%r27,%r3,%r4
	beq	%r27,%r0,4
	sll	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_1
	bne	%r4,%r0,3
	addi	%r2,%r0,0
	jr	%r31
	sll	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_0
div10_1:
	and	%r27,%r3,%r4
	beq	%r27,%r0,4
	sll	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_3
	bne	%r4,%r0,3
	addi	%r2,%r0,1
	jr	%r31
	sll	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_2
div10_2:
	and	%r27,%r3,%r4
	beq	%r27,%r0,4
	sll	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_5
	bne	%r4,%r0,3
	addi	%r2,%r0,2
	jr	%r31
	sll	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_4
div10_3:
	and	%r27,%r3,%r4
	beq	%r27,%r0,4
	sll	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_7
	bne	%r4,%r0,3
	addi	%r2,%r0,3
	jr	%r31
	sll	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_6
div10_4:
	and	%r27,%r3,%r4
	beq	%r27,%r0,4
	sll	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_9
	bne	%r4,%r0,3
	addi	%r2,%r0,4
	jr	%r31
	sll	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_8
div10_5:
	and	%r27,%r3,%r4
	beq	%r27,%r0,5
	sll	%r1,%r1,1
	addi	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_1
	bne	%r4,%r0,3
	addi	%r2,%r0,5
	jr	%r31
	sll	%r1,%r1,1
	addi	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_0
div10_6:
	and	%r27,%r3,%r4
	beq	%r27,%r0,5
	sll	%r1,%r1,1
	addi	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_3
	bne	%r4,%r0,3
	addi	%r2,%r0,6
	jr	%r31
	sll	%r1,%r1,1
	addi	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_2
div10_7:
	and	%r27,%r3,%r4
	beq	%r27,%r0,5
	sll	%r1,%r1,1
	addi	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_5
	bne	%r4,%r0,3
	addi	%r2,%r0,7
	jr	%r31
	sll	%r1,%r1,1
	addi	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_4
div10_8:
	and	%r27,%r3,%r4
	beq	%r27,%r0,5
	sll	%r1,%r1,1
	addi	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_7
	bne	%r4,%r0,3
	addi	%r2,%r0,8
	jr	%r31
	sll	%r1,%r1,1
	addi	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_6
div10_9:
	and	%r27,%r3,%r4
	beq	%r27,%r0,5
	sll	%r1,%r1,1
	addi	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_9
	bne	%r4,%r0,3
	addi	%r2,%r0,9
	jr	%r31
	sll	%r1,%r1,1
	addi	%r1,%r1,1
	srl	%r4,%r4,1
	j	div10_8
	.globl min_caml_print_int
min_caml_print_int:
	bne	%r0,%r1,_print_int_init
	addi	%r1,%r1,48
	j	min_caml_print_char
_print_int_init:
	slt	%r27,%r1,%r0
	sw	%r31,0(%r30)
	addi	%r8,%r30,4
	slt	%r27,%r1,%r0
	beq	%r27,%r0,_print_int_loop
	sub	%r9,%r0,%r1
	addi	%r1,%r0,45
	jal	min_caml_print_char
	addi	%r1,%r9,0
_print_int_loop:
	jal	div10
	sw	%r2,0(%r8)
	addi	%r8,%r8,4
	bne	%r1,%r0,_print_int_loop
_print_int_out:
	addi	%r8,%r8,-4
	beq	%r8,%r30,_print_int_exit
	lw	%r1,0(%r8)
	addi	%r1,%r1,0x30
	jal	min_caml_print_char
	j	_print_int_out
_print_int_exit:
	lw	%r31,0(%r30)
	jr	%r31
#test
	.globl _min_caml_start
_min_caml_start:
	addi	%r1,%r0,0x41
	jal	min_caml_print_char
	addi	%r1,%r0,0x72
	jal	min_caml_print_char
	jal	_print_char_flush
	addi	%r1,%r0,0x6f
	jal	min_caml_print_char
	addi	%r1,%r0,0x6e
	jal	min_caml_print_char
	addi	%r1,%r0,0x0a
	jal 	min_caml_print_char
	jal	_print_char_flush
	addi	%r1,%r0,765
	jal	min_caml_print_int
	addi	%r1,%r0,0x0a
	jal 	min_caml_print_char
	addi	%r1,%r0,0
	jal	min_caml_print_int
	addi	%r1,%r0,0x0a
	jal 	min_caml_print_char
	addi	%r1,%r0,-216
	jal	min_caml_print_int
	addi	%r1,%r0,0x0a
	jal 	min_caml_print_char
	jal	_print_char_flush
	
	halt

	

