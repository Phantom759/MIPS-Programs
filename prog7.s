
         # This program determines whether the input expression has balanced parentheses or not
         # Program uses jumps, links, function calls, loops, and stack storage 

.data
 
mainNumFormulas:
        .word 5
mainFormulas:
        .word mainFormula1
        .word mainFormula2
        .word mainFormula3
        .word mainFormula4
        .word mainFormula5
 
mainFormula1:  .asciiz  "(7)"
mainFormula2:  .asciiz  "(a+(x) * (6 + 14) - q7)"
mainFormula3:  .asciiz  "(a+(x) * (6 + 14   - q7)"
mainFormula4:  .asciiz  "((((17 * (3 + a - b) / 7))+(6-abc)))"
mainFormula5:  .asciiz  "((((17 * (3 + a - b  / 7 )+(6-abc  )"
 
mainNewline:
            .asciiz "\n"
mainString:
            .asciiz " -- main\n"
mainAfterString:
            .asciiz "main: after call to parens:\n"
mainNotBalancedStr:
            .asciiz "main: parens reports the formula is Not Balanced\n"
mainBalancedStr:
            .asciiz "main: parens reports the formula is Balanced\n"
mainHyphenString:
            .asciiz "+---------+---------+---------+---------"
.text
main:
         # Function prologue -- even main has one
         addiu $sp, $sp, -24      # allocate stack space -- default of 24 here
         sw    $fp, 0($sp)        # save caller's frame pointer
         sw    $ra, 4($sp)        # save return address
         addiu $fp, $sp, 24       # setup main's frame pointer
 
         # for ( i = 0; i < mainNumFormulas; i++ )
         #    find length of string
         #    cleanFormula
 
         addi  $s0, $zero, 0      # $s0 = i = 0
         la    $t0, mainNumFormulas
         lw    $s1, 0($t0)        # $s1 = number of strings
         la    $s2, mainFormulas  # $s2 = addr mainFormulas[0]
mainLoopBegin:
         slt   $t0, $s0, $s1      # $t0 = i < mainNumFormulas
         beq   $t0, $zero, mainLoopEnd
        
         # print the hyphens
         la    $a0, mainHyphenString
         addi  $v0, $zero, 4
         syscall
         syscall
         la    $a0, mainNewline
         addi  $v0, $zero, 4
         syscall
        
         # print the string
         lw    $a0, 0($s2)        # $s4 = addr of start of current string
         addi  $v0, $zero, 4
         syscall
 
         la    $a0, mainString
         addi  $v0, $zero, 4
         syscall
         # print a blank line
         la    $a0, mainNewline
         addi  $v0, $zero, 4
         syscall
 
         lw    $a0, 0($s2)        # $a0 = addr of string start
         addi  $a1, $zero, 1      # $a1 = parens level, start at 1
        
         jal   parens
        
         addi  $t1, $v0, 0        # save return value in $t1
 
         # print the string
         la    $a0, mainNewline   # print a blank line
         addi  $v0, $zero, 4
         syscall
         la    $a0, mainAfterString
         addi  $v0, $zero, 4
         syscall
         lw    $a0, 0($s2)        # $a0 = addr of formula start
         addi  $v0, $zero, 4
         syscall
         la    $a0, mainNewline
         addi  $v0, $zero, 4
         syscall
        
         # Did parens return a -1 (not balanced)?
         addi  $t0, $zero, -1
         bne   $t1, $t0, mainPrintBalanced
         la    $a0, mainNotBalancedStr
         addi  $v0, $zero, 4
         syscall
         j     mainAfterBalance
mainPrintBalanced:
         la    $a0, mainBalancedStr
         addi  $v0, $zero, 4
         syscall
 
mainAfterBalance:
         # print a blank line
         la    $a0, mainNewline
         addi  $v0, $zero, 4
         syscall
        
         addi  $s0, $s0, 1        # i++
         addi  $s2, $s2, 4        # $s2 = addr of next string
         j     mainLoopBegin
 
mainLoopEnd:
 
mainDone:
         # Epilogue for main -- restore stack & frame pointers and return
         lw    $ra, 4($sp)        # get return address from stack
         lw    $fp, 0($sp)        # restore frame pointer of caller
         addiu $sp, $sp, 24       # restore stack pointer of caller
         jr    $ra                # return to caller
 
printFormula:
         # Function prologue
         addiu $sp, $sp, -24      # allocate stack space -- default of 24 here
         sw    $fp,  0($sp)       # save frame pointer of caller
         sw    $ra,  4($sp)       # save return address
         sw    $a0,  8($sp)       # save $a0 = addr of first char to print
         sw    $a1, 12($sp)       # save $a1 = how many chars to print
         addiu $fp, $sp, 24       # setup frame pointer of printFormula
 
         # for (i = $a0; i < $a0 + $a1; i++)
         #    print byte
        
         addi  $t0, $a0, 0        # i = $t0 = start of characters to print
         add   $t1, $a0, $a1      # $t1 = addr of last character to print
 
printFormulaLoopBegin:
         slt   $t2, $t0, $t1      # $t2 = i < $a0 + $a1
         beq   $t2, $zero, printFormulaLoopEnd
 
         # print the character
         lb    $a0, 0($t0)
         addi  $v0, $zero, 11
         syscall
 
         addi  $t0, $t0, 1        # i++
         j     printFormulaLoopBegin
 
printFormulaLoopEnd:
 
         # Epilogue for printFormula -- restore stack & frame pointers & return
         lw    $a1, 12($sp)       # restore $a1
         lw    $a0,  8($sp)       # restore $a0
         lw    $ra,  4($sp)       # get return address from stack
         lw    $fp,  0($sp)       # restore frame pointer of caller
         addiu $sp, $sp, 24       # restore stack pointer of caller
         jr    $ra                # return to caller
 
# Your code goes below this line

parens:
.data
parensLev:    .asciiz " -- parens level "
notParensLev: .asciiz "-- parens level "
parensBal:    .asciiz " Balanced!\n"
parensUnbal:  .asciiz " Not Balanced!\n"
newLine:    .asciiz "\n"

.text
parensMain:
   addiu  $sp, $sp, -28       # allocate stack space -- default of 24 here
   sw     $fp, 0($sp)         # save caller's frame pointer
   sw     $ra, 4($sp)         # save return address
   sw     $a3, 8($sp)
   sw     $a2, 12($sp)
   sw     $a1, 16($sp)
   sw     $a0, 20($sp)
   addiu  $fp, $sp, 20        # setup main's frame pointer
   add    $t7, $zero, 1
   add    $t2, $a0, $zero     # $t2 holds a copy of $a0, and is used to tell printFormula where to start  
   sw     $t2, 24($sp)
   addi   $a1, $a1, 1         # $a1 holds the current level
   addi   $a0, $a0, 1         # $a0 holds the current string pointer
   lb     $t0, 0($a0)         # load the first character into $t0
   addi   $t1, $zero, 1       # $t1 holds number of letters since last parenthesis
   addi   $a3, $zero, 0
parensStart:
   beq    $a3, $t7, endLoop
   beq    $t0, $zero, parensUnbalanced
                              # checks to see if the character is null
   lb     $t0, 0($a0)         # load the first character into $t0
   li     $t4, '('            # $t4 now holds "("
                              # checks for left parenthesis
   bne    $t0, $t4, parensRightParenCheck
   sw     $fp, 0($sp)
   sw     $ra, 4($sp)
   sw     $a3, 8($sp)
   sw     $a2, 12($sp)
   sw     $a1, 16($sp)
   sw     $a0, 20($sp)
   addiu  $sp, $sp, -12
   sw     $t0, 0($sp)
   sw     $t1, 4($sp)
   sw     $t2, 8($sp)
   jal    parens              # call parens
   lw     $t1, 4($sp)
   lw     $t2, 8($sp)
   addiu  $sp, $sp, 12
   lw     $fp, 0($sp)
   lw     $ra, 4($sp)
#   lw     $a3, 8($sp)
   lw     $a2, 12($sp)
#   lw     $a1, 16($sp)
#   lw     $a0, 20($sp)
#   lw     $t0, 24($sp)
   add    $t1, $t1, $v1       # set number of character to print to $t1 + $v0, or, the initial number before the call plus the number of chars gone through during the call
   sw     $t1, 28($sp)
   j      parensStart

                              # checks for right parenthesis
parensRightParenCheck:
   li     $t4, ')'            # $t4 now holds ")"
   bne    $t0, $t4, parensLetterCheck
   addi   $a1, $a1, -1

  # sw     $t1, 16($sp)
   sw     $a0, 20($sp)         # print statement test to check the number of characters to be printed in printFormula
   sw     $a1, 16($sp)


   lw     $a0, 20($sp)
   addi   $t1, $t1, 1        # increment $t1 to account for the right parenthesis char
   addi   $a1, $t1, 0        # set $a1 to be number of letters since last right parenthesis
   add    $a0, $t2, $zero    # set $a0 to be the string pointer at which to start (in this case, the start of the string received in $a0 by the function call)
   addiu  $sp, $sp, -8
   sw     $t1, 0($sp)
   sw     $t2, 4($sp)

   jal    printFormula       # call printFormula with $a0 holding the string that was in $t2 and $a1 holding the number of chars to be printed, which was in $t1

   lw     $t1, 0($sp)
   lw     $t2, 4($sp)
   addiu  $sp, $sp, 8


   lw     $a1, 16($sp)       # print the current level with according text
   addi   $t6, $zero, 1
   beq    $a1, $t6, lastParen
   la     $a0, parensLev    
   #lw     $t0, 24($sp)
   addi   $v0, $zero, 4
   syscall
   addi   $a0, $a1, 0
   addi   $v0, $zero, 1
   syscall
   la     $a0, newLine
   addi   $v0, $zero, 4
   syscall
   lw     $a0, 20($sp)       # load all the stored things back in and return to caller
   addi   $a0, $a0, 1        # add 1 to $a0 to make sure when it returns to the caller, $a0 is not pointing to the right parenthesis
   add    $v1, $t1, $zero    # store the number of letters processed in $v0

   j parensEnd

lastParen:
   la     $a0, parensLev    
   #lw     $t0, 24($sp)
   addi   $v0, $zero, 4
   syscall
   addi   $a0, $a1, 0
   addi   $v0, $zero, 1
   syscall
   la     $a0, parensBal
   addi   $v0, $zero, 4
   syscall
   lw     $a0, 20($sp)       # load all the stored things back in and return to caller
   addi   $a0, $a0, 1        # add 1 to $a0 to make sure when it returns to the caller, $a0 is not pointing to the right parenthesis
   add    $v1, $t1, $zero    # store the number of letters processed in $v0

   j parensEnd
parensUnbalanced:
   addi   $v1, $zero, 0
   addi   $a1, $a1, -2         
   sw     $a1, 16($sp)
   sw     $a0, 20($sp)
   lw     $t2, 24($sp)
   addi   $t1, $t1, -1
   #lw     $t1, 28($sp)
   addi   $a0, $t2, 0
   addi   $a1, $t1, 0
   addiu  $sp, $sp, -8
   sw     $t1, 0($sp)
   sw     $t2, 4($sp)

   jal    printFormula

   lw     $t1, 0($sp)
   lw     $t2, 4($sp)
   addiu  $sp, $sp, 8
   lw     $a1, 16($sp)
   lw     $a0, 20($sp)
   addi   $a1, $a1, 1
   addi   $v1, $t1, 0
   la     $a0, parensLev    
   #lw     $t0, 24($sp)
   addi   $v0, $zero, 4
   syscall
   addi   $a0, $a1, 0
   addi   $v0, $zero, 1
   syscall
   la     $a0, parensUnbal
   addi   $v0, $zero, 4
   syscall
   addi   $v0, $zero, -1
   addi   $t0, $zero, 0

endLoop:
   lw     $ra, 4($sp)
   lw     $fp, 0($sp)
   addi   $a3, $zero, 1
   addi   $t7, $zero, 1
   addiu  $sp, $sp, 28       # restore stack pointer of caller
   jr     $ra                # return to previous call after loading the correct fp, ra, and character (in $t0)
   




parensEnd:

   lw     $ra, 4($sp)
   lw     $fp, 0($sp)
   addiu  $sp, $sp, 28       # restore stack pointer of caller
   jr     $ra                # return to previous call after loading the correct fp, ra, and character (in $t0)
   
parensLetterCheck:           # if the character from the string in $t1 is not a parenthesis,
                             # increment the letter since last parenthesis counter and get the next char
   addi   $a0, $a0, 1        # increment $a0 pointer by one
   addi   $t1, $t1, 1
   j      parensStart