.data
_MASK_MANTI:	
	.word	0x007fffff
.text
	.globl	min_caml_float_of_int	
min_caml_float_of_int:
	beq	%r1,%r0,.itof_ret_zero
	slt	%r2,%r1,%r0
	beq	%r2,%r0,.itof_search_upper
	sub	%r1,%r0,%r1
.itof_search_upper:
	addi	%r3,%r0,0x7f
	sll	%r3,%r3,24
	and	%r3,%r1,%r3
	beq	%r3,%r0,.itof_search_upper_l
.itof_search_upper_g:
	addi	%r3,%r0,1
	sll	%r3,%r3,30
	addi	%r4,%r0,0x80
	addi	%r5,%r0,0x7f
	addi	%r6,%r0,30
.itof_loop1:
	and	%r7,%r1,%r3
	bne	%r7,%r0,.itof_calc_manti
	srl	%r3,%r3,1
	srl	%r4,%r4,1
	srl	%r5,%r5,1
	addi	%r6,%r6,-1
	j	.itof_loop1
.itof_calc_manti:
	addi	%r7,%r6,-23
	and	%r4,%r1,%r4
	slt	%r4,%r0,%r4
	and	%r5,%r1,%r5
	slt	%r5,%r0,%r5
.itof_loop2:
	srl	%r1,%r1,1
	addi	%r7,%r7,-1
	slt	%r8,%r0,%r7
	bne	%r8,%r0,.itof_loop2
.itof_ret:
	and	%r7,%r4,%r5
	andi	%r8,%r1,1
	or	%r7,%r8,%r7
	add	%r1,%r1,%r7
	addi	%r8,%r0,1
	sll	%r8,%r8,24
	and	%r8,%r1,%r8
	beq	%r8,%r0,.itof_L1
	srl	%r1,%r1,1
	addi	%r6,%r6,1
.itof_L1:
	la	%r3,_MASK_MANTI
	lw	%r3,0(%r3)
	and	%r1,%r3,%r1
	addi	%r6,%r6,127
	andi	%r6,%r6,0xff
	sll	%r6,%r6,23
	sll	%r2,%r2,31
	or	%r1,%r1,%r6
	or	%r1,%r1,%r2
	sw	%r1,0(%r30)
	lwc1	%f0,0(%r30)
	jr	%r31
.itof_search_upper_l:
	addi	%r3,%r0,1
	sll	%r3,%r3,23
	addi	%r4,%r0,150
.itof_loop3:
	and	%r5,%r3,%r1
	bne	%r5,%r0,.itof_ret_l
	sll	%r1,%r1,1
	addi	%r4,%r4,-1
	j	.itof_loop3
.itof_ret_l:	
	la	%r3,_MASK_MANTI
	lw	%r3,0(%r3)
	and	%r1,%r3,%r1
	sll	%r4,%r4,23
	or	%r1,%r4,%r1
	sll	%r2,%r2,31
	or	%r1,%r2,%r1
	sw	%r1,0(%r30)
	lwc1	%f1,0(%r30)
	jr	%r31
.itof_ret_zero:
	sub.s	%f1,%f1,%f1
	jr	%r31
	.globl min_caml_create_array
min_caml_create_array:
	slt	%r27,%r1,%r0
	beq	%r27,%r0,2
	jr	%r31
	move	%r29,%r28
	add	%r28,%r28,%r1
	slt	%r27,%r0,%r1
	beq	%r27,%r0,_create_array_exit
	move	%r3,%r29
_create_array_loop:
	sw	%r2,0(%r3)
	addi	%r3,%r3,1
	addi	%r1,%r1,-1
	slt	%r27,%r0,%r1
	bne	%r27,%r0,_create_array_loop
_create_array_exit:	
	move	%r1,%r29
	jr	%r31

	.globl min_caml_create_float_array
min_caml_create_float_array:
	slt	%r27,%r1,%r0
	beq	%r27,%r0,2
	jr	%r31
	move	%r29,%r28
	add	%r28,%r28,%r1
	slt	%r27,%r0,%r1
	beq	%r27,%r0,_create_array_float_exit
	move	%r2,%r29
_create_array_float_loop:
	swc1	%f1,0(%r2)
	addi	%r2,%r2,1
	addi	%r1,%r1,-1
	slt	%r27,%r0,%r1
	bne	%r27,%r0,_create_array_float_loop
_create_array_float_exit:	
	move	%r1,%r29
	jr	%r31
	.data
	.align 2
_BUF:
	.word 0		#buffer本体
	.word 0		#カウンタ
.text
	.globl min_caml_print_char
min_caml_print_char:
	outb	%r1
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
	addi	%r8,%r30,1
	slt	%r27,%r1,%r0
	beq	%r27,%r0,_print_int_loop
	sub	%r9,%r0,%r1
	addi	%r1,%r0,45
	jal	min_caml_print_char
	addi	%r1,%r9,0
_print_int_loop:
	jal	div10
	sw	%r2,0(%r8)
	addi	%r8,%r8,1
	bne	%r1,%r0,_print_int_loop
_print_int_out:
	addi	%r8,%r8,-1
	beq	%r8,%r30,_print_int_exit
	lw	%r1,0(%r8)
	addi	%r1,%r1,0x30
	outb	%r1
	j	_print_int_out
_print_int_exit:
	lw	%r31,0(%r30)
	jr	%r31
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
	lw	%r4,1(%r2)
	lw	%r5,2(%r2)
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
	sw	%r4,1(%r2)
	sw	%r5,2(%r2)
	jr	%r31
	.globl	min_caml_read_int
min_caml_read_int:
	in	%r1
	jr	%r31
	.globl	min_caml_read_float
min_caml_read_float:
	in	%r29	
	sw	%r29,0(%r30)
	lwc1	%f1,0(%r30)
	jr	%r31
