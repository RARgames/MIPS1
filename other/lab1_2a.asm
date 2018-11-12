.data

keyboardBuffer:	.space 		50
test1: 		.asciiz 	"12121212"
test2: 		.asciiz 	"Abc$$!cc!23"
test3: 		.asciiz 	"aaa$$5aa$%^^aacD"
test4: 		.asciiz 	"**adc**AAA5@@6"

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
# $t1 - current char
# $t2 - next char buffer
subroutine:
	move 	$t0, $a0
loop:
	lb	$t1, ($t0)		# Load char
	lb	$t2, 1($t0)		# Save next char
	bltu	$t1, ' ', endLoop	# End if char is below white space
	bltu	$t2, ' ', endLoop	# End if char is below white space
	######## Task logic here #########
	sb	$t2, ($t0)		# Save next char to current char.
	sb	$t1, 1($t0)
	##################################
incrementation:
	addiu	$t0, $t0, 2		# Increment address
	j 	loop			
endLoop:
	jr 	$ra
