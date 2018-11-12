.data

keyboardBuffer:	.space 		50
outputBuffer:   .space 		50
test1: 		.asciiz 	"123456789"
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
# $t7 - address to the last char of the string
subroutine:
	la 	$t0, outputBuffer
	move 	$t7, $a0
# set address of last char
strln:
	lb	$t1, 1($t7)
	bltu	$t1, ' ', loop
	addiu	$t7, $t7, 1		# Increment address
	j 	strln	
loop:
	######## Task logic here #########
	lb	$t1, ($t7)		# Load char
	sb	$t1, ($t0)
	##################################
	beq	$t7, $a0, endLoop	# Addresses are the same
incrementation:
	addiu	$t7, $t7, -1		# Increment address
	addiu	$t0, $t0, 1		# Increment address
	j 	loop			
endLoop:
	sb	$zero, 1($t0)
	la	$a0, outputBuffer
	jr 	$ra
