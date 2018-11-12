.data

keyboardBuffer:	.space 		50
test1: 		.asciiz 	"34:wind ooooon the hill"
test2: 		.asciiz 	"12:wind on the hill"
test3: 		.asciiz 	"46:wind on the hill"
test4: 		.asciiz 	"99:wind on the hill"

.text

main:
# Test case 1
	la	$a0, test1
	jal	subroutine
	li	$v0, 4
	syscall
# Endline
	li	$a0, '\n'
	li	$v0, 11
	syscall
# Test case 2
	la	$a0, test2
	jal	subroutine
	li	$v0, 4
	syscall
# Endline
	li	$a0, '\n'
	li	$v0, 11
	syscall
# Test case 3
	la	$a0, test3
	jal	subroutine
	li	$v0, 4
	syscall
# Endline
	li	$a0, '\n'
	li	$v0, 11
	syscall
# Test case 4
	la	$a0, test4
	jal	subroutine
	li	$v0, 4
	syscall
# Endline
	li	$a0, '\n'
	li	$v0, 11
	syscall
# Test Case from keyboard
# Read string
	la	$a0, keyboardBuffer
	li	$a1, 49
	li	$v0, 8
	syscall
# Execute subroutine
	jal	subroutine
	li	$v0, 4
	syscall
# Endline
	li	$a0, '\n'
	li	$v0, 11
	syscall
# Exit
	li 	$v0, 10
	syscall
# Address of argument stored in $a0
# Return value also in $a0
# $t0 - address to current char
# $t1 -	current char
# $t2 - destination pointer
# $t3 - iterator = 1,2,3...
# $t5 - string length
# $t6 - starting position
# $t7 - ending position
subroutine:
	move 	$t0, $a0
	lbu	$t6, ($t0)
	addiu	$t6, $t6, -48		# Set staring position
	lbu	$t7, 1($t0)
	addiu	$t7, $t7, -48		# Set ending position
	addiu	$t0, $t0, 3		# Skip first three positions
	li	$t5, 0			# Reset string length
strlnLoop:
	lb	$t1, ($t0)		# Load char
	bltu	$t1, ' ', endStrlnLoop	# End if char is below white space
	addiu 	$t5, $t5, 1		# Increment string length
	addiu	$t0, $t0, 1		# Increment address
	j 	strlnLoop			
endStrlnLoop:
	addu 	$t1, $t6, $t7		# Add starting and ending position
	bgtu	$t1, $t5, return	# End if above sum is greater than string length
	subu	$t7, $t5, $t7		# Transfer ending position from right to left
	move	$t0, $a0		# Set source pointer to first char
	addiu	$t0, $t0, 3		# Skip first three chars in source pointer
	move	$t2, $a0		# Set destination pointer to first char
	li	$t3, 0			# Reset iterator
replaceLoop:
	lbu	$t1, ($t0)		# Load current char from source
	bltu	$t1, ' ', endReplaceLoop# End if char is below white space
	bltu	$t3, $t6, replacement
	bgeu	$t3, $t7, replacement
	sb	$t1, ($t2)		# Save char from source to destination
	j	endReplacement
replacement:
	li	$t1, '*'		# Load asterisk
	sb	$t1, ($t2)		# Save char from source to destination
endReplacement:
	addiu	$t0, $t0, 1		# Increment source pointer
	addiu	$t2, $t2, 1		# Increment destination pointer
	addiu	$t3, $t3, 1		# Increment iterator
	j	replaceLoop
endReplaceLoop:
	sb	$zero, ($t2)		# Add null terminator at the end of destination
return:
	jr 	$ra
