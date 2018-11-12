# 2c. Reverse the order of characters in the string

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
	
preodd:
	li	$t0, 0			# Set t0 = 0
	li	$t3, 0			# t3 = 0
	li	$t5, 0			# other counter

	odd:
		add	$t3, $t2, $t5		# $t2 is the base address for our 'input' array, add loop index
		lb	$t4, 0($t3)		# load a byte at a time according to counter
		bltu	$t4, ' ', preeven	# We found end string
	
		sb	$t4, output($t0)	# Overwrite this byte address in memory	
	
		addi	$t0, $t0, 1		# Advance our counter (i++)
		addi	$t5, $t5, 2		# Advance our counter (i++)
	
		j 	odd

preeven:
	li	$t3, 0			# and the same for t3
	li	$t5, 1			# other counter
	la	$t2, ($a0)
	
	even:
	
		add	$t3, $t2, $t5		# $t2 is the base address for our 'input' array, add loop index
		lb	$t4, 0($t3)		# load a byte at a time according to counter
		bltu	$t4, ' ', exit		# We found end string
	
		sb	$t4, output($t0)	# Overwrite this byte address in memory	
	
		addi	$t0, $t0, 1		# Advance our counter (i++)
		addi	$t5, $t5, 2		# Advance our counter (i++)
	
		j 	even
		
exit:
	li	$v0, 4			# Print msgout
	la	$a0, msgout
	syscall

	li	$v0, 4			# Print the output string!
	la	$a0, output
	syscall
		
	li	$v0, 10			# exit()
	syscall