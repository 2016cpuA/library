.data
_CONST_NEG:
	.word	0xbf800000
.text
	.globl min_caml_print_newline
min_caml_print_newline:	
	addi	%r1,%r0,$10
	out	%r1
	jr 	%r31
	.globl min_caml_abs_float	
min_caml_abs_float:
	sub.s 	%f1,%f1,%f1
	c.lt.s	%r1,%f0,%f1
	beq	%r1,%r0,.ret_abs
.lt0_abs:
	la 	%r1,_CONST_NEG
	lwc1	%f1,0(%r1)
	mul.s	%f0,%f0,%f1
.ret_abs:
	jr 	%r31
	.globl 	min_caml_sqrt
#test
.data
	.align 	2
_test_case_abs:
	.word 	0x3f212345
	.word	0xbf212345
_test_OK:
	.word	0x214b4f09 #"\tOK!"
_test_NG:
	.word	0x2e474e09 #"\tNG."
_test_result_abs:
	.word	0x3a736261 #"abs"
.text
_test_abs:
	sub.s	%f0,%f0,%f0
	la	%r1,_test_result_abs
	lw 	%r1,0(%r1)
	out	%r1
	la 	%r1,_test_case_abs
	lwc1	%f2,0(%r1)
	lwc1	%f3,4(%r1)
	add.s	%f0,%f0,%f2
	sw	%r31,0(%r30)
	jal	min_caml_abs_float
	c.eq.s	%r1,%f0,%f2
	beq	%r1,%r0,_test_result_NG
	sub.s 	%f0,%f0,%f0
	add.s	%f0,%f0,%f3
	jal	min_caml_abs_float
	c.eq.s	%r1,%f0,%f2
	beq	%r1,%r0,_test_result_NG
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
	jal	_test_abs
	j	SYS_EXIT
