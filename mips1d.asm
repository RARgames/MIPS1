# 1d. Convert all non letter characters to *

	.data
prompt:	.asciiz	"Enter a string: "
lenmsg:	.asciiz	"\nString length is "
buf:	.space	80
	.text
	.globl	main
main:
	li	$v0, 4			# print string
	la	$a0, prompt
	syscall
	
	# input a string
	li	$v0, 8			# read string
	la	$a0, buf
	li	$a1, 80
	syscall
	
	la	$t0, buf
	move	$t1, $t0
nextchar:
	lbu	$t2, ($t0)
	bltu	$t2, ' ', finish	# end of string
	# check for lowercase letter
	bltu	$t2, 'A', change
	bgtu	$t2, 'Z', Zcase
	addiu	$t0, $t0, 1		# move the pointer
	b	nextchar

Zcase:
	bltu	$t2, 'a', change
	bgtu	$t2, 'z', change
	addiu	$t0, $t0, 1		# move the pointer
	b	nextchar

change:
	li 	$t2, '*'
	sb	$t2, ($t0)
	addiu	$t0, $t0, 1		# move the pointer
	b	nextchar
	
finish:
	# display the result string
	li	$v0, 4			# print string
	la	$a0, buf
	syscall

	li	$v0, 10			# exit
	syscall