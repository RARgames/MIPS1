# 3a. Replace each character belonging to a word by the number of upper case characters in this word (mod 10)

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
	
	li	$t1, 0					# Normal counter
	rewriteoutput:
		add	$t3, $t2, $t1			# $t2 is the base address for our 'input' array, add loop index
		lb	$t4, 0($t3)			# load a byte at a time according to counter
		
		bltu 	$t4, ' ', word			# We found end of string
		
		sb	$t4, output($t1)		# Overwrite this byte address in memory
		addi	$t1, $t1, 1 			# Advance our counter (i++)
		j rewriteoutput
			
	word:
		li	$t1, 0				# Normal counter
		li	$t5, 0				# Uppercase counter
		li 	$t6, 0 				# First letter of word
		j 	word_countUppercase
		word_precountUppercase:
			addi 	$t1, $t1, 1				# Add 1 to index to avoid space in next word
			la	$t6, ($t1)				# Set t6 to the first index of t2 (start of word)
			la	$t5, 0					# $t5 - 0
		word_countUppercase:
			#addi	$t1, $t1, $t7
			add	$t3, $t2, $t1				# $t2 is the base address for our 'input' array, add loop index
			lb	$t4, 0($t3)				# load a byte at a time according to counter
			
			beq 	$t4, ' ', word_prereplace 	 	# We found end of word
			bltu 	$t4, ' ', word_prereplace		# We found end of string	
			
			addi	$t1, $t1, 1				# Advance our counter (i++)
					
			bltu	$t4, 'A', word_countUppercase
			bgtu	$t4, 'Z', word_countUppercase
			
			addi	$t5, $t5, 1 				# Advance our counter (i++)
			j 	word_countUppercase
			
		word_prereplace:
			#la	$t2, ($a0)				# t2 - input string
			la	$t1, ($t6)				# Normal counter
			addi 	$t5, $t5, '0'				# Added just to print ints in string

			word_replace:
				add	$t3, $t2, $t1			# $t2 is the base address for our 'input' array, add loop index
				lb	$t4, 0($t3)			# load a byte at a time according to counter	
			
				beq	$t4, ' ', word_replaceExit	# end of the word
				bltu 	$t4, ' ', exit			# We found end of string	
						
				sb	$t5, output($t1)		# Overwrite this byte address in memory	
			
				addi	$t1, $t1, 1 			# Advance our counter (i++)
				j 	word_replace
			word_replaceExit:
				j	word_precountUppercase
			
		
		
exit:
	li	$v0, 4			# Print msgout
	la	$a0, msgout
	syscall

	li	$v0, 4			# Print the output string!
	la	$a0, output
	syscall
		
	li	$v0, 10			# exit()
	syscall
