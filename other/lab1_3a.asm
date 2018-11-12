.data

keyboardBuffer:	.space 		50
test1: 		.asciiz 	"ABC123 AaaA BBCCsss"
test2: 		.asciiz 	"Abcc c!23"
test3: 		.asciiz 	"aaa 5aaa acD"
test4: 		.asciiz 	"**adc AAA56"

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
# $t2 - current address for iterating word
# $t3 - current char for iterating word
# $t4 - current uppercase count
# $t5 - char correspoding to number of uppercase letters 
subroutine:
	move 	$t0, $a0
	li	$t4, 0
loop:
########### Loop for whole string
	lbu	$t1, ($t0)		# Load char
	bltu	$t1, ' ', endLoop	# End if char is below white space
	beq	$t1, ' ', iterate	# White space
	
	li	$t4, 0 			# Reset uppercase count
	move	$t2, $t0		# Set start of current word
	###### Loop for current word
currentWordLoop:
	lbu	$t3, ($t2)
	bleu	$t3, ' ', changeChars
	bltu	$t3, 'A', skipIncrementation
	bgtu	$t3, 'Z', skipIncrementation
	bne	$t4, 9, incrementNumber
changeToZero:
	li	$t4, 0
	j 	skipIncrementation
incrementNumber:
	addiu	$t4, $t4, 1
skipIncrementation:
	addiu	$t2, $t2, 1
	j currentWordLoop
	######
changeChars:
	li	$t5, '0'
	addu    $t5, $t5, $t4
	###### Loop for changing chars in current word
changeCharsLoop:
	lbu	$t6, ($t0)
	beqz	$t6, endLoop
	beq	$t0, $t2, iterate
	sb	$t5, ($t0)
	addiu	$t0, $t0, 1
	j changeCharsLoop
	######
iterate:
	addiu	$t0, $t0, 1		# Increment address
	j 	loop	
###########
endLoop:
	jr 	$ra
