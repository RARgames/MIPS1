.data

keyboardBuffer:	.space 		50
test1: 		.asciiz 	"ABC123aas222ccz2299as"
test2: 		.asciiz 	"Abccc!23"
test3: 		.asciiz 	"aaa5aaaacD"
test4: 		.asciiz 	"**adc3A3A3A2133a5d63d434" 

.text

main:
# Test case 1
	la	$a0, test1
	jal	subroutine
	li	$v0, 1
	syscall
# Endline
	li	$a0, '\n'
	li	$v0, 11
	syscall
# Test case 2
	la	$a0, test2
	jal	subroutine
	li	$v0, 1
	syscall
# Endline
	li	$a0, '\n'
	li	$v0, 11
	syscall
# Test case 3
	la	$a0, test3
	jal	subroutine
	li	$v0, 1
	syscall
# Endline
	li	$a0, '\n'
	li	$v0, 11
	syscall
# Test case 4
	la	$a0, test4
	jal	subroutine
	li	$v0, 1
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
	li 	$v0, 1
	syscall
# Address of argument stored in $a0
# Return value also in $a0
# $t0 - address to current char
# $t1 - current char
# $t2 - is reading number
# $a0 - number of numbers
subroutine:
	move 	$t0, $a0
	li	$a0, 0			# Reset number of numbers
	li	$t2, 0			# Reset is reading number to zero
loop:
	lb	$t1, ($t0)		# Load char
	bltu	$t1, ' ', endLoop	# End if char is below white space
	bgtu	$t1, '9', notNumber	
	bltu	$t1, '0', notNumber
	bnez	$t2, isNotStarting	# Skip incrementation if char belongs to number subsequence
	addiu	$a0, $a0, 1		# Increment number of numbers	
isNotStarting:
	li	$t2, 1			# Set is reading number
	j incrementation
notNumber:
	li	$t2, 0			# Reset is reading number
incrementation:
	addiu	$t0, $t0, 1		# Increment address
	j 	loop			
endLoop:
	jr 	$ra
