.data

keyboardBuffer:	.space 		50
test1: 		.asciiz 	"no:wind ooooon the hill"
test2: 		.asciiz 	"12:wind on the hill"
test3: 		.asciiz 	"w2:wind on the hill"
test4: 		.asciiz 	"wl:wind on the hill"

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
# $t2 - address of char to copy
# $t3 - char to copy
# $t4 - address to start asterisk char
# $t5 - address to end asterisk char
# $t6 - starting char
# $t7 - ending char
subroutine:
	move 	$t0, $a0
	lbu	$t6, ($t0)		# Save staring char
	lbu	$t7, 1($t0)		# Save ending char
	li	$t4, 0			# Reset start address
	li	$t5, 0			# Reset end address
	addiu	$t0, $t0, 3		# Skip first three chars
searchLoop:
	lb	$t1, ($t0)		# Load char
	bltu	$t1, ' ', endSearchLoop	# End if char is below white space
	beq	$t1, $t6, setStartChar
	beq	$t1, $t7, setEndChar
	j	endSettingChars
setStartChar:
	bnez	$t4, endSettingChars 	# Skip setting if address already determined
	move	$t4, $t0
	j	endSettingChars
setEndChar:
	bnez	$t5, endSettingChars 	# Skip setting if address already determined
	move	$t5, $t0
endSettingChars:
	addiu	$t0, $t0, 1		# Increment address
	j 	searchLoop			
endSearchLoop:
	beqz	$t4, return		# Return if starting char not encounterd
	beqz	$t5, return		# Return if ending char not encounterd
	move 	$t0, $a0
	addiu	$t2, $a0, 3
asteriskLoop:
	lb	$t3, ($t2)		# Load char
	bltu	$t3, ' ', endCopyLoop	# End if char is below white
	bltu	$t2, $t4, skipAsteriskChange
	bgtu	$t2, $t5, skipAsteriskChange
	li	$t3, '*'		# Set char to *
skipAsteriskChange:
	sb	$t3, ($t0)		# Store char
	addiu	$t2, $t2, 1		# Increment address
	addiu	$t0, $t0, 1		# Increment address
	j	asteriskLoop
endCopyLoop:
	sb	$zero, ($t0)
return:
	jr 	$ra
