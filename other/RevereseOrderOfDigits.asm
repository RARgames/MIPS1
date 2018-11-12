.data

keyboardBuffer:	.space 		50
test1: 		.asciiz 	"wind oo34ooon the hill"
test2: 		.asciiz 	"123456789"
test3: 		.asciiz 	"12:wi3n34d on6t7e8 h9ll"
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
# %t0 - pointer to current char
# %t1 - current char
# $t2 - current number from buffer
# $fp - buffer for digits
# $sp - pointer to start of the buffer
subroutine:
	move 	$t0, $a0		# Copy address of string
	move	$fp, $sp		# Set frame pointer
findLoop:
	lbu	$t1, ($t0)		# Load char
	bltu	$t1, ' ', endFindLoop	# End loop if char is less than white space
	bltu	$t1, '0', skipSave	# Skip saving char if NaN
	bgtu	$t1, '9', skipSave
	sb	$t1, ($fp)		# Push number on the stack
	addiu	$fp, $fp, -1		# Decrement stack
skipSave:
	addiu	$t0, $t0, 1
	j 	findLoop
endFindLoop:
	move 	$t0, $a0		# Set pointer to begin of the string
replceLoop:
	lbu	$t1, ($t0)		# Load char
	bltu	$t1, ' ', return	# End loop if char is less than white space
	bltu	$t1, '0', skipReplace	# Skip saving char if NaN
	bgtu	$t1, '9', skipReplace
	addiu	$fp, $fp, 1		# Increment stack
	lbu	$t2, ($fp)
	sb	$t2, ($t0)
skipReplace:
	addiu	$t0, $t0, 1
	j 	replceLoop
return:
	jr 	$ra
