.data
_QNAN:
	.word   0x7fc00000
_HALF:
	.word	0x3f000000
.text
	.globl min_caml_print_newline
min_caml_print_newline:	
	addi	%r1,%r0,$10
	out	%r1
	jr 	%r31
	.globl min_caml_abs_float
min_caml_sqrt:
	sub.s	%f4,%f4,%f4
	c.le.s	%r1,%f4,%f0
	beq	%r1,%r0,.catch_nan
.set_sqrt:
	add.s	%f1,%f0,%f2
	la	%r1,_HALF
	lwc1	%f3,0(%r1)
.calc_sqrt:
#f0=a, f1=x_k, f2=x_(k+1), f3=0.5, f4=0.0
	div.s	%f2,%f0,%f1  #tmp=a/x0
	add.s	%f2,%f2,%f1  #
	mul.s	%f2,%f2,%f3
	c.eq.s	%r1,%f1,%f2
	bne	%r1,%r0,.ret_sqrt
	add.s	%f1,%f4,%f2
	j	.calc_sqrt
.ret_sqrt:
	add.s	%f0,%f2,%f4
	jr	%r31
.catch_nan:
	la	%r1,_QNAN
	lwc1	%f0,0(%r1)
	jr	%r31
#test
.data
_2:
	.word   0x40000000
_sqrt2:
	.word	0x3fb504f3
_sqrt0_5:
	.word	0x3f3504f3
_test_result_sqrt:	
	.word   0x3a747173 #"sqt"
_test_OK:
	.word	0x214b4f09 #"\tOK!"
_test_NG:
	.word	0x2e474e09 #"\tNG."
.text
_test_sqrt:
	sw	%r31,0(%r30)
	la 	%r1,_test_result_sqrt
	lw 	%r1,0(%r1)
	out 	%r1
	la	%r1,_2
	lwc1	%f0,0(%r1)
	jal	min_caml_sqrt
	la	%r1,_sqrt2
	lwc1	%f1,0(%r1)
	c.eq.s	%r1,%f0,%f1
	beq	%r1,%r0,_test_result_NG
	la	%r1,_HALF	
	lwc1	%f0,0(%r1)
	jal	min_caml_sqrt
	la	%r1,_sqrt0_5
	lwc1	%f1,0(%r1)
	c.eq.s	%r1,%f0,%f1
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
	jal	_test_sqrt
	j	SYS_EXIT
