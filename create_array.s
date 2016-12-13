.text
	.globl min_caml_create_array
min_caml_create_array:
	slt	%r27,%r1,%r0
	beq	%r27,%r0,2
	jr	%r31
	sll	%r1,%r1,2
	move	%r29,%r28
	add	%r28,%r28,%r1
	srl	%r1,%r1,2
	slt	%r27,%r0,%r1
	beq	%r27,%r0,_create_array_exit
	move	%r3,%r29
_create_array_loop:
	sw	%r2,0(%r3)
	addi	%r3,%r3,4
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
	sll	%r1,%r1,2
	move	%r29,%r28
	add	%r28,%r28,%r1
	srl	%r1,%r1,2
	slt	%r27,%r0,%r1
	beq	%r27,%r0,_create_array_float_exit
	move	%r2,%r29
_create_array_float_loop:
	swc1	%f1,0(%r2)
	addi	%r2,%r2,4
	addi	%r1,%r1,-1
	slt	%r27,%r0,%r1
	bne	%r27,%r0,_create_array_float_loop
_create_array_float_exit:	
	move	%r1,%r29
	jr	%r31
	
	#test
	.globl _min_caml_start
_min_caml_start:
	li	%r1,33
	li	%r2,-1023
	jal	min_caml_create_array
	move	%r3,%r1
	li	%r2,33
loop1:
	lw	%r1,0(%r3)
	add	%r1,%r1,%r2
	jal	min_caml_print_int
	li	%r1,10
	jal	min_caml_print_char
	addi	%r3,%r3,4
	addi	%r2,%r2,-1
	slt	%r27,%r2,%r0
	beq	%r27,%r0,loop1
	halt
	
