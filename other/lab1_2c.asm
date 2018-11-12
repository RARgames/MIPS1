.data

test1: 		.asciiz 	"1a2b3c4d"
test2: 		.asciiz 	"Abc$$!cc!23"
test3: 		.asciiz 	"aaa$$5aa$%^^aacD"
test4: 		.asciiz 	"1a2b3c4d"

testBuffer1: 	.space		50
testBuffer2: 	.space		50
testBuffer3: 	.space		50
testBuffer4: 	.space		50

.text

main:
# Test case 1
	la	$a0, test1
	la	$a1, testBuffer1
	jal	subroutine
	move	$a0, $v0
	li	$v0, 4
	syscall
# Endline
	li	$a0, '\n'
	li	$v0, 11
	syscall
# Test case 2
	la	$a0, test2
	la	$a1, testBuffer2
	jal	subroutine
	move	$a0, $v0
	li	$v0, 4
	syscall
# Endline
	li	$a0, '\n'
	li	$v0, 11
	syscall
# Test case 3
	la	$a0, test3
	la	$a1, testBuffer3
	jal	subroutine
	move	$a0, $v0
	li	$v0, 4
	syscall
# Endline
	li	$a0, '\n'
	li	$v0, 11
	syscall
# Test case 4
	la	$a0, test4
	la	$a1, testBuffer4
	jal	subroutine
	move	$a0, $v0
	li	$v0, 4
	syscall
# Endline
	li	$a0, '\n'
	li	$v0, 11
	syscall
# Exit
	li 	$v0, 10
	syscall
	
# Address of argument passed in $a0
# Address of output buffer passed in $a1
# Return value also in $v0
# $t0 - address to current char. 
# $t2 - current char of evenLoop
# $t3 - current char of oddLoop
# $t7 - buffer for output
subroutine:
	move	$t7, $a1
	move 	$t0, $a0
evenLoop:
	lbu	$t1, ($t0)		# Load char
	bltu	$t1, ' ', endEvenLoop	# End if char is below white space
	######## Even logic here ########
	sb	$t1, ($t7)
	lbu	$t1, 1($t0)
	bltu	$t1, ' ', endEvenLoop
	##################################
evenIncrementation:
	addiu	$t0, $t0, 2		# Increment address
	addiu	$t7, $t7, 1		# Increment address
	j 	evenLoop			
endEvenLoop:
	move 	$t0, $a0
	addiu	$t0, $t0, 1
oddLoop:
	lbu	$t1, ($t0)		# Load char
	bltu	$t1, ' ', endOddLoop	# End if char is below white space
	######## Even logic here ########
	sb	$t1, ($t7)
	lbu	$t1, 1($t0)
	bltu	$t1, ' ', endOddLoop
	##################################
oddIncrementation:
	addiu	$t0, $t0, 2		# Increment address
	addiu	$t7, $t7, 1		# Increment address
	j 	oddLoop			
endOddLoop:
subroutineEnd:
	move	$v0, $a1
	jr 	$ra
