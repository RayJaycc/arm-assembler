# ARM Assembler on the LPC4088
This is a sample solution to some exercises in writing assembly language code for the ARM processor in the LPC4088 chip.

## "equ"
The `equ` directive instructs the assembler to create a symbol with the preceding label as a name and the following quantity as its value.  You can think of it as the assembly equivalent of the `enum` statement in C.  

### Bit addressing
The first block of `equ` defines the addresses for the bit-band-aliasing access to the GPIO ports.  The arithmetic is performed by the assembler and the resulting value used as the symbol's value.

## Timer
Timer 0 is set up and an interrupt handler attached.  Here I have made use of the register-plus-offset means of accessing memory.  The timers have the same layout of registers, the `timer0init` function just needs a different base address and it can be used for any timer.  

The `timer0init` function could be rewritten as a generic function for initialising timers, with the base address for the timer passed into it in register `r0`.
  
