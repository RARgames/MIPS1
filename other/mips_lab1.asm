#-------------------------------------------------------------------------------
#author       : Karol Koniecki 
#description  : Delete all digits from the testcase_1 string. 
#		Implemented using 'jal' function call.
#-------------------------------------------------------------------------------

		.data
testcase_1: 	.asciiz "7 plus 8 is 15"
source_msg:	.asciiz "\nSource> "
result_msg:	.asciiz "\nResult> "
		.text
main:

#DISPLAY PROMPT AND SOURCE
        li $v0, 4				# SYSTEM CALL FOR PRINTING STRING
        la $a0, source_msg		 	# SYSCALL ARGUMENT
        syscall

        li $v0, 4				# SYSTEM CALL FOR PRINTING STRING
	la $a0, testcase_1			# SYSCALL ARGUMENT, LOADS TESTCASE_1 INTO $A0 WHICH WE USE LATER ON
	syscall   
	
 	jal remove				# FUNCTION CALL
	  
	
#DISPLAY PROMPT AND RESULT       
	li $v0, 4				# SYSTEM CALL FOR PRINTING STRING
        la $a0, result_msg			# SYSCALL ARGUMENT
        syscall
        
        li $v0, 4				# SYSTEM CALL FOR PRINTING STRING
        la $a0, testcase_1			# SYSCALL ARGUMENT
        syscall
 
 exit:
	li 	$v0, 10		
	syscall

#REMOVE FUNCTION	
remove: 
	move $t0, $a0				# COPY $A0 TO $T0
						# !!! WE USE $T0 AND $A0 IN PARALLEL
						# !!! WE READ FROM $T0 AND WE OVERWRITE $A0
						# !!! $A0 IS BOTH INPUT AND OUTPUT OF THE FUNCTION

	loop:
		lbu $t1, ($t0)			# LOAD BYTE FROM $T0 to $T1
		beqz $t1, exit_remove		# IF REACHED THE END OF STRING EXIT LOOP
	
		bge $t1, '0', upper_bound	# LOWER BOUND CHECK IF $T1 IS A DIGIT, IF YES CHECK UPPER BOUND
		
		sb $t1, ($a0)			# IF THE $T1 IS NOT A DIGIT WE SAVE THE CONTENTS OF BYTE $T1 AT $A0 BYTE
		addiu $a0, $a0, 1		# INCREMENT $A0
		
		j inc_t0	
		
	upper_bound:
		ble $t1, '9', inc_t0		# UPPER BOUND CHECK IF $T1 IS A DIGIT, IF YES GOTO INC_T0
		
		sb $t1, ($a0)			# IF THE $T1 IS NOT A DIGIT WE SAVE THE CONTENTS OF BYTE $T1 AT $A0 BYTE
		addiu $a0, $a0,1		# INCREMENT $A0
		
	inc_t0:
		addiu $t0, $t0, 1		# INCREMENT $T0 
						# !!! WHEN THE CURRENT BYTE ($T1) IS A DIGIT ONLY $T0 IS INCREASED
						# !!! $A0 IS NOT INCREASED NOR WE DONT OVERWRITE ANYTHING THERE, SO THAT
						# !!! NEXT OCCURENCE OF NON-DIGIT CHARACTER WILL BE OVERWRITTEN IN PLACE OF PREVIOUS DIGIT
		j loop
		
	exit_remove:
		li $t2, '\0'			# LOAD END OF STRING CHARACTER TO $T2
		sb $t2, ($a0)			# SAVE CONTENTS OF $T2 AT THE END OF $A0
		
		jr $ra				# EXIT FUNCTION
