.section .init

.global _start

_start:
    ldr r0, =0x20200000 // address of the GPIO controller
    // Enable output to the 16th pin
    mov r1, #1               // move is faster than ldr but can only be used for certain values
    lsl r1, #18              // shift the binary representation of 1 by 18 places
    str r1, [r0, #4]         // store register command, stores the value in r1 to the address computed from the expression
    // Set the function of the pin (i.e. turn it on)
    mov r1, #1
    lsl r1, #16               
    str r1, [r0, #40]        // address to turn a pin off
loop$:
    b loop$

    // Waiting loop
    mov r2, #0x3F0000
wait1$:
    sub r2, #1
    cmp r2, #0
    bne wait1$

    // By writing to an offset of 28 instead of 40 we can turn the LED off


/*
  Functions:
   bl - branch to label, automatically stores the address of the next instruction in lr
*/
.global GetGpioAddress

GetGpioAddress:
    ldr r0, =0x20200000
    mov pc, lr

.global SetGpioFunction

SetGpioFunction:
    cmp r0, #53
    cmpls r1, #7             // compares only if r0 was less than or equal to 53
    movhi pc, lr             // runs (i.e returns) only if the last comparison was higher than the second
    push {lr}
    mov r2, r0
    bl GetGpioAddress