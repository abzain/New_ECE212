 
 # File:   Task1_Fibonacci_Numbers.s
 # Author: Zainab Hussein
 # Created on March 28, 2017, 8:30 AM
    .global main	    # define main as global label
    .set noreorder	    # don't let the assembler reorder instructions
    
main:	addi $a0, $0, 6	    # n = 8 (find 8th fib number )
	addi $s0, $0, 1	    # prev = fib(-1) = 1
	addi $s1, $0, 0	    # curr = fib(0) = 0
	
loop:	beq $s2,$a0,done    # if the current and nth order to stop
			    # the loop are equal, go to done
	add $s1,$s0,$s1	    # adding the previous value to the current value
			    # to get the fibonacci sequence
	sub $s0,$s1,$s0	    # update previous value to the last current
	addi $v0,$s1,0	    # save the current value into $v0
	addi $s2,$s2,1	    # increment counter by 1
	j  loop		    # return back to begin the loop
	add $0,$0,$0	    # branch delay slot (nop)
    
done:	j done		    # infinite loop
	add $0, $0, $0	    # branch delay slot (nop)


