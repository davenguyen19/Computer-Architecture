	.data
input1:	.asciiz "\n First number: "
input2:	.asciiz "\n Second number: "
product: .asciiz "\n Product: "
	.code

main:
	la	$a0,input1
	syscall	$print_string
	syscall $read_int
	move	$a1,$v0

	la	$a0,input2
	syscall	$print_string
	syscall $read_int
	move	$a0,$v0

	mult	$a0,$a1
	jal	mult
	move	$a0,$v0
	syscall	$print_int
	b	main

# unsigned multiply routine
multu:	move	$v0,$a1
	li	$t1,32		#loop counter
	move	$v1,$0

1:	andi	$t2,$v0,1
	beqz	$t2,2f
	addu	$v1,$v1,$a0

2:	srl	$v0,$v0,1
	sll	$t0,$v1,31
	or	$v0,$v0,$t0
	srl	$v1,$v1,1
	addi	$t1,$t1,-1
	bgtz	$t1,1b
	jr	$ra

# signed multiply routine
mult:	addi	$sp,$sp,-4
	sw	$ra,($sp)
	xor	$t3,$a0,$a1		#calculate sign bit
	abs	$a0,$a0
	abs	$a1,$a1
	jal	multu
	bgez	$t3,3f
	
	nor	$v1,$v1,$0		#negation
	bnez	$v0,4f
	addi	$v1,$v1,1
4:	negu	$v0,$v0

3:	lw	$ra,($sp)
	addi	$sp,$sp,4
	jr	$ra		

	