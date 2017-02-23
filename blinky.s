        preserve8 ; Indicate the code here preserve
                  ; 8 byte stack alignment
        area |.text|, code, readonly ; Start of CODE area
        export __main
        export TIMER0_IRQHandler
        entry

; Set up symbols with base register and offsets
dir  equ 0x00
mask equ 0x10
pin  equ 0x14
set  equ 0x18
clr  equ 0x1c
    
; To calcluate the bit address, use
; (preipheral register address offset from base)*32 + bit number *4
; 
; P1 is at 20098020
; bit addressing starts at 22000000
; direction register bit 13 at 0x2200000 + 0x98020*32 + 13*4
p0offset equ 0x98000
p1offset equ 0x98020
p2offset equ 0x98040
    
led1bit equ 18
led1dir equ 0x22000000 + (p1offset+dir)*32 + led1bit*4
led1pin equ 0x22000000 + (p1offset+pin)*32 + led1bit*4
led1set equ 0x22000000 + (p1offset+set)*32 + led1bit*4
led1clr equ 0x22000000 + (p1offset+clr)*32 + led1bit*4
    
led2bit equ 13
led2dir equ 0x22000000 + (p0offset+dir)*32 + led2bit*4
led2pin equ 0x22000000 + (p0offset+pin)*32 + led2bit*4
led2set equ 0x22000000 + (p0offset+set)*32 + led2bit*4
led2clr equ 0x22000000 + (p0offset+clr)*32 + led2bit*4

led3bit equ 13
led3dir equ 0x22000000 + (p1offset+dir)*32 + led2bit*4
led3pin equ 0x22000000 + (p1offset+pin)*32 + led2bit*4
led3set equ 0x22000000 + (p1offset+set)*32 + led2bit*4
led3clr equ 0x22000000 + (p1offset+clr)*32 + led2bit*4

led4bit equ 19
led4dir equ 0x22000000 + (p2offset+dir)*32 + led4bit*4
led4pin equ 0x22000000 + (p2offset+pin)*32 + led4bit*4
led4set equ 0x22000000 + (p2offset+set)*32 + led4bit*4
led4clr equ 0x22000000 + (p2offset+clr)*32 + led4bit*4

__main  function
        bl initialise
        bl timer0init
blink
        bl led2off
        bl led3off
        bl led4off
        nop
        bl led2on
        bl led3off
        bl led4off
        nop
        bl led2off
        bl led3on
        bl led4off
        nop
        bl led2off
        bl led3off
        bl led4on

        b blink
    endfunc
; Start code here

initialise function
    push {r0,r1}
    mov r0, #1
    ldr r1,=led1dir   ; pseudo instruction
    str r0,[r1] ; write 1 for output in dir bit
    ldr r1,=led2dir
    str r0,[r1]
    ldr r1,=led3dir
    str r0,[r1]
    ldr r1,=led4dir
    str r0,[r1]
    pop {r0,r1}
    bx lr
    endfunc



led1on function
    push {r0,r1}
    ldr r0,=led1clr
    mov r1, #1
    str r1, [r0]
    pop {r0,r1}
    bx lr
    endfunc
led1off function
    push {r0,r1}
    ldr r0,=led1set
    mov r1, #1
    str r1, [r0]
    pop {r0,r1}
    bx lr
    endfunc
led1state function
    push {r1}
    ldr r1,=led1pin
    ldr r0,[r1]
    pop {r1}
    bx lr
    endfunc
    
led2on function
    push {r0,r1}
    ldr r0,=led2clr
    mov r1, #1
    str r1, [r0]
    pop {r0,r1}
    bx lr
    endfunc
led2off function
    push {r0,r1}
    ldr r0,=led2set
    mov r1, #1
    str r1, [r0]
    pop {r0,r1}
    bx lr
    endfunc
    
led3on function
    push {r0,r1}
    ldr r0,=led3set
    mov r1, #1
    str r1, [r0]
    pop {r0,r1}
    bx lr
    endfunc
led3off function
    push {r0,r1}
    ldr r0,=led3clr
    mov r1, #1
    str r1, [r0]
    pop {r0,r1}
    bx lr
    endfunc
    
led4on function
    push {r0,r1}
    ldr r0,=led4set
    mov r1, #1
    str r1, [r0]
    pop {r0,r1}
    bx lr
    endfunc
led4off function
    push {r0,r1}
    ldr r0,=led4clr
    mov r1, #1
    str r1, [r0]
    pop {r0,r1}
    bx lr
    endfunc
    
;; TIMER 0
; register definitions
timer0base equ 0x40004000
ir   equ  0x000
tcr  equ  0x004
tc   equ  0x008
pr   equ  0x00C
mcr  equ  0x014
mr0  equ  0x018
ctcr equ  0x070

mr0int equ 0x42000000 + (4000)*32

iser equ  0xE000E100
timer0init function
    push {r0,r1}
    ldr r0,=timer0base
    mov r1, #0
    str r1, [r0,#tcr]
    str r1, [r0,#ctcr]
    mov r1, #59999 ; 1ms tickrate
    str r1, [r0,#pr]
    mov r1, #1000
    str r1, [r0,#mr0]
    mov r1, #2_0011
    str r1, [r0,#mcr]
    mov r1, #1
    str r1, [r0,#tcr]
    ldr r0,=iser
    ldr r1,[r0]
    orr r1, #2_0010
    str r1, [r0]
    pop {r0,r1}
    bx lr
    endfunc
    
TIMER0_IRQHandler function
    push {r0,r1,lr}
    bl led1state
    tst r0, #1
    bleq led1off
    blne led1on
    mov r0, #1
    ldr r1,=timer0base
    str r0,[r1,#ir]
    pop {r0,r1,lr}
    bx lr
        endfunc
    end

