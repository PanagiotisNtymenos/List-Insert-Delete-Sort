.text
.globl main
	
main:	

	#Print Menu
	li $v0, 4
	la $a0, Menu
	syscall
		
	#Read Answer
	li $v0, 5
	syscall	
	
	#Store Answer
	move $t7,$v0

	beq $t7, 0, EXIT
	beq $t7, 1, PUT_MENU
	beq $t7, 2, DELETE_MENU
	beq $t7, 3, SHOW_A_MENU
	beq $t7, 4, SHOW_D_MENU	
	
	#Print main_Menu
	li $v0, 4
	la $a0, main_Menu
	syscall
	
	j main
	

PUT_MENU:	
	#Print Put
	la $a0, Put
	li $v0, 4
	syscall
		
	#Read Int
	li $v0, 5
	syscall
		
	# Move non-zero integer input into $t0
	move $t0, $v0	

	#Make Node
	li $a0, 8
	li $v0, 9
	syscall
	
	#Store Int To Node	
	sw $t0, 0($v0)	
	
	#Move List Struct To $a0
	move $a0, $s0	
	
	#Move Created Node With Input To $a1
	move $a1, $v0	
 	jal PUT	
 	move	$s0, $v0
 	
 	j main
PUT:
		
	#t0 contains linkedlist pointer
	move $t0, $a0
	
	#t2 contains newNode pointer		
	move $t2, $a1
	
	#t1 contains node value				
	lw $t1, 0($t2)		
	
	#If List Is Empty
	beq $t0, $zero, Exit_Empty
	
	#Load the data in first position
	lw $t4, 0($t0)	
	
	#Insert First if newNode =< firstNode		
	bge $t4, $t1, Exit_Head			
	
	#Move head to lastNode
	move $t5, $t0
	Exit_Make:
		move $t3, $t5		#Points to last Node
		lw $t5, -4($t3)		#Points to next Node

		#Check Node for insertion, otherwise Loop
		beq $t5, $zero, Exit_OK	#Check this Node iterated to is not the tail Node
		lw $t4, 0($t5)		#If it isnt, store this (Next) Node's Data
		blt $t4, $t1, Exit_Make	#Iterate if next node is not >= inserting Node

		#Otherwise Insert
		sw $t5, -4($t2)		#Make inserted nodes next point to current Node	
	Exit_OK:
		sw $t2, -4($t3)		#Make previous node point to inserted node
	
		move $v0, $t0		#Return List Pointer
		
		jr	$ra				#Exit	
	Exit_Head:
		#Store pointer to first Node, moving new node to front	
		sw $t0, -4($t2)	
							
	Exit_Empty:
		#Return address of new head-node or New List
		move $v0, $t2
						
		jr	$ra						

DELETE_MENU:

	#Print Delete
	la $a0, Delete
	li $v0, 4
	syscall
	
	#Read Int
	li $v0, 5
	syscall
	
	move $a0, $s0
		
	jal DELETE
		
	jal SHOW_A_MENU
	
	j main																
DELETE:	

	#If list empty
	beq $a0	,$zero,EmptyList
	
	move $t0, $a0
	
	lw $t1, 0($t0)
	
	beq $v0, $t1, OneNode 
	
	move $t3, $t0
	WhileDelete:
	 			
		#Keep Prev Node
		move $t6,$t3
		#Next Node
		lw $t3, -4($t3)
		#Exit if Node is NULL
		beq $t3, $zero,  ExitDelete
		
		lw $t1,0($t3) 
				
		beq $v0, $t1, Done				

		j WhileDelete			
	OneNode:
		lw $t0,-4($t0)
		
		move $s0, $t0
		
		jr $ra
	Done:
		lw $t3,-4($t3)
		
		sw $t3,-4($t6)
													
		jr $ra

SHOW_A_MENU:

	beq $s0, $zero,  EmptyList
	
	#Print Ascending
	li $v0, 4
	la $a0, Ascending
	syscall
	
	move $a0, $s0
							
	jal  SHOW_A
							
	j main
			
SHOW_A:
	
	#Move List Pointer
	move $t0, $a0
	
	WhileShow_A:
	 	#Exit if Node is NULL
		beq $t0,$zero,  ExitShow_A

		#Print Element
		lw $t1, 0($t0)	#Otherwise Load value of current element
		move $a0, $t1 	#display Result
		#Print Number
		li $v0, 1
		syscall	
		
		#Print Space 
		la $a0, Space
		li $v0, 4
		syscall	

		#Iterate to next Node
		lw $t0, -4($t0)		#Point to Next Node
		
		j WhileShow_A			#Loop
		
	ExitShow_A:
		
		jr $ra	
	 	 
	
SHOW_D_MENU:	
	beq $s0, $zero,  EmptyList
	
	#Print Ascending
	li $v0, 4
	la $a0, Descending
	syscall
		
	move $a0, $s0
	
	move $t0, $a0
	move $t8, $t0
	move $t7, $t0
	move $t6, $t0
	move $t2, $t0
	move $t5, $t0
	move $t9, $zero
	li $t3,0
	li $t4,0						
	jal SHOW_D
							
	j main

SHOW_D:

	While:
		add $t3,$t3,1
		lw $t8, -4($t8)	
		
		beq $t9,$t0,Exit
						
		beq $t8, $zero, Exit		
		
		beq $t7, $t0,PreLast	
	 	
		lw $t5, -4($t5)
		
		PreLast:
			lw $t7, -4($t7)		
				
		beq $t9, $t7, Exit
			
		j While
	
	Exit:
		
		
		lw $t1, 0($t7)	
		move $a0, $t1 	#display Result
		#Print Number
		li $v0, 1
		syscall
		
		#Print Space 
		la $a0, Space
		li $v0, 4
		syscall	
		
		
		lw $t2, -4($t2)
		beq $t2,$zero,Exi
		
		move $t9, $t5
		move $t8, $t0
		move $t7, $t0
		move $t6, $t0	
		move $t5, $t0
		
			
	j SHOW_D	
   	
   	Exi:			
		
		jr $ra
EmptyList:
		#Print Empty List
		li $v0, 4
		la $a0, Empty
		syscall	
		
		j main
		
ExitDelete:
		#Print Not Found
		li $v0, 4
		la $a0, NotFound
		syscall	
		
		j main	

EXIT:	
	#END OF THE PROGRAM
	li $v0, 10
	syscall

.data
	Menu:.asciiz "\n Menu: \n 1.Put \n 2.Delete \n 3.Show List In Ascending Order \n 4.Show List In Descending Order \n 0.Exit!! \n"
	main_Menu:.asciiz "Press one of the following: 0, 1, 2, 3 or 4! \n "	
	Put:.asciiz " >Enter The Integer You Would Like To Add: \n"
	Delete:.asciiz " >Enter The Integer You Would Like To Delete: \n"	
	NewLine:.asciiz "\n"
	Space:.asciiz "   "	
	Descending:.asciiz "The List In Descending Order:  \n"	
	Ascending:.asciiz "The List In Ascending Order:  \n"	
	TheNewList:.asciiz "The New List :  "
	Empty:.asciiz "The List Is Empty!!  "
	NotFound:.asciiz "Integer Not Found In The List!!  "		
