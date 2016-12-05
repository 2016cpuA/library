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
#test
.data
	.align 	2
_test_OK:
	.word	0x214b4f09 #"\tOK!"
_test_NG:
	.word	0x2e474e09 #"\tNG."
_2_i:
	.word	0x00000009
_2_f:
	.word   0x41100000
_-2147483647_i:
	.word	0x80000001
_-2147483648_f:
	.word	0xcf000000
_test_result_atoi:
	.word	0x3a693261
.text
_test_itof:
	sw	%r31,0(%r30)
	addi	%r30,%r30,4
	la	%r1,_test_result_atoi
	lw	%r1,0(%r1)
	out	%r1
	la 	%r1,_2_i
	lw	%r1,0(%r1)
	jal	min_caml_itof
	la 	%r1,_2_f
	lwc1	%f1,0(%r1)
	c.eq.s	%r1,%f1,%f0
	addi	%r30,%r30,-4
	beq	%r1,%r0,_test_result_NG
	j	_test_result_OK
_test_result_OK:
	la 	%r1,_test_OK
	lw 	%r1,0(%r1)
	out	%r1
	jal	min_caml_print_newline
	lw	%r31,0(%r30)
	jr	%r31
_test_result_NG:
	la 	%r1,_test_NG
	lw 	%r1,0(%r1)
	out	%r1
	jal	min_caml_print_newline
	lw	%r31,0(%r30)
	jr	%r31
	.globl _min_caml_start
_min_caml_start:
	jal	_test_itof
	j	SYS_EXIT
