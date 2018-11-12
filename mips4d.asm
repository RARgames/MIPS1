# 4d.

	.data
prompt:	.asciiz	"Enter a string: "
msgout:	.asciiz	"Output string: "
input:	.space	256
output:	.space	256
	.text
	.globl main
	
main:
	li	$v0, 4			# Print enter a string prompt
	la	$a0, prompt		
	syscall
	
	li	$v0, 8			# Ask the user for the string they want to reverse
	la	$a0, input		# We'll store it in 'input'
	li	$a1, 256		# Only 256 chars/bytes allowed
	syscall
		
	la	$t2, ($a0)		# t2 - input string
	
	jal	strlen			# JAL to strlen function, saves return address to $ra
	
	la	$t7, ($v0)		# t7 - lenght
	la	$t2, ($a0)		# t2 - input string
	
	lbu	$t5, ($t2)				# t5 - start marker
	add	$t5, $t5, -48
	la	$s1, ($t5)				#saved just for exit loop
	add	$t5, $t5, 2
	
	lbu	$t6, 1($t2)				# t6 - end marker
	add	$t6, $t6, -48
	la	$s2, ($t6)				#saved just for exit loop
	sub	$t6, $t7, $t6
	sub 	$t6, $t6, 1
	
	li	$t1, 0					# t1 - Normal counter
	rewriteoutput:
		add	$t3, $t2, $t1			# $t2 is the base address for our 'input' array, add loop index
		lb	$t4, 0($t3)			# load a byte at a time according to counter
		
		bltu 	$t4, ' ', replace_start			# We found end of string
		ble	$t1, 2, add_space
	rewrite:	
		sb	$t4, output($t1)		# Overwrite this byte address in memory
		addi	$t1, $t1, 1 			# Advance our counter (i++)
		j 	rewriteoutput
	add_space:
		la	$t4, 32
		j	rewrite
			
	replace_start:
		li	$t1, 3				# Normal counter

		add	$t9, $s1, $s2			#exit when 23: is greater than string lenght
		sub	$t7, $t7, 3
		bgt	$t9, $t7, exit
		
		replace:
			add	$t3, $t2, $t1				# $t2 is the base address for our 'input' array, add loop index
			lb	$t4, 0($t3)				# load a byte at a time according to counter
			
			bltu 	$t4, ' ', exit				# We found end of string
			
			bleu	$t1, $t5, replace_aster
			bgtu	$t1, $t6, replace_aster
			
			addi	$t1, $t1, 1				# Advance our counter (i++)
			j 	replace
		replace_aster:
			la 	$t4, '*'
			sb	$t4, output($t1)			# Overwrite this byte address in memory
			addi	$t1, $t1, 1				# Advance our counter (i++)
			j 	replace
exit:
	li	$v0, 4			# Print msgout
	la	$a0, msgout
	syscall

	li	$v0, 4			# Print the output string!
	la	$a0, output
	syscall
		
	li	$v0, 10			# exit()
	syscall

# strlen:
# a0 is our input string
# v0 returns the length
# Function loops over the character array until it encounters the null byte

strlen:
	li	$t0, 0
	li	$t2, 0
	
	strlen_loop:
		add	$t2, $a0, $t0
		lb	$t1, 0($t2)
		beqz	$t1, strlen_exit
		addiu	$t0, $t0, 1
		j	strlen_loop
		
	strlen_exit:
		subi	$t0, $t0, 1
		
		la 	$v0, ($t0)
		jr	$ra
