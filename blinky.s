        preserve8 ; Indicate the code here preserve
                  ; 8 byte stack alignment
        area |.text|, code, readonly ; Start of CODE area
        export __main
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
blink
        bl led1on
        bl led2off
        bl led3off
        bl led4off
        nop
        bl led1off
        bl led2on
        bl led3off
        bl led4off
        nop
        bl led1off
        bl led2off
        bl led3on
        bl led4off
        nop
        bl led1off
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
    
    end

