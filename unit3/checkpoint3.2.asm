  .file [name="checkpoint3.2.bin", type="bin", segments="XMega65Bin"]
.segmentdef XMega65Bin [segments="Syscall, Code, Data, Stack, Zeropage"]
.segmentdef Syscall [start=$8000, max=$81ff]
.segmentdef Code [start=$8200, min=$8200, max=$bdff]
.segmentdef Data [startAfter="Code", min=$8200, max=$bdff]
.segmentdef Stack [min=$be00, max=$beff, fill]
.segmentdef Zeropage [min=$bf00, max=$bfff, fill]
  .label VIC_MEMORY = $d018
  .label SCREEN = $400
  .label COLS = $d800
  .const WHITE = 1
  //Define consts
  .const JMP = $4c
  .const NOP = $ea
  .label current_screen_line = 2
.segment Code
main: {
    rts
}
//KIL instruction in 6502-mode trap entry point
CPUKIL: {
    jsr exit_hypervisor
    rts
}
//Trigger the system to exit hypervisor mode
exit_hypervisor: {
    lda #1
    sta $d67f
    rts
}
//Trap function for all undefined traps
reserved_trap: {
    jsr exit_hypervisor
    rts
}
//F011 virtualised disk write trap entry point
VF011WR: {
    jsr exit_hypervisor
    rts
}
//F011 virtualised disk read trap entry point
VF011RD: {
    jsr exit_hypervisor
    rts
}
//Alt+Tab trap entry point
alttabkey: {
    jsr exit_hypervisor
    rts
}
//Restore-key long press trap entry point
restorkey: {
    jsr exit_hypervisor
    rts
}
//Page fault entry point
pagfault: {
    jsr exit_hypervisor
    rts
}
//The Trap Functions
//Power-on/reset entry point
reset: {
    jsr myProgram
    rts
}
myProgram: {
    //Init screen memory and font
    lda #$14
    sta VIC_MEMORY
    ldx #' '
    lda #<SCREEN
    sta.z memset.str
    lda #>SCREEN
    sta.z memset.str+1
    lda #<$28*$19
    sta.z memset.num
    lda #>$28*$19
    sta.z memset.num+1
    jsr memset
    ldx #WHITE
    lda #<COLS
    sta.z memset.str
    lda #>COLS
    sta.z memset.str+1
    lda #<$28*$19
    sta.z memset.num
    lda #>$28*$19
    sta.z memset.num+1
    jsr memset
    lda #<$400
    sta.z current_screen_line
    lda #>$400
    sta.z current_screen_line+1
    lda #<message
    sta.z print_to_screen.message
    lda #>message
    sta.z print_to_screen.message+1
    jsr print_to_screen
    jsr print_newline
    lda #<$400+$28
    sta.z current_screen_line
    lda #>$400+$28
    sta.z current_screen_line+1
    lda #<message1
    sta.z print_to_screen.message
    lda #>message1
    sta.z print_to_screen.message+1
    jsr print_to_screen
  __b1:
    jmp __b1
  .segment Data
    message: .text "smit1829 operating system starting..."
    .byte 0
    message1: .text "testing hardware"
    .byte 0
}
.segment Code
// print_to_screen(byte* zeropage(4) message)
print_to_screen: {
    .label message = 4
    ldx #0
  __b1:
    ldy #0
    lda (message),y
    cmp #0
    bne __b2
    rts
  __b2:
    stx.z $ff
    ldy #0
    lda (message),y
    ldy.z $ff
    sta (current_screen_line),y
    inx
    inc.z message
    bne !+
    inc.z message+1
  !:
    jmp __b1
}
print_newline: {
    rts
}
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zeropage(6) str, byte register(X) c, word zeropage(4) num)
memset: {
    .label end = 4
    .label dst = 6
    .label num = 4
    .label str = 6
    lda.z num
    bne !+
    lda.z num+1
    beq __breturn
  !:
    lda.z end
    clc
    adc.z str
    sta.z end
    lda.z end+1
    adc.z str+1
    sta.z end+1
  __b2:
    lda.z dst+1
    cmp.z end+1
    bne __b3
    lda.z dst
    cmp.z end
    bne __b3
  __breturn:
    rts
  __b3:
    txa
    ldy #0
    sta (dst),y
    inc.z dst
    bne !+
    inc.z dst+1
  !:
    jmp __b2
}
syscall64: {
    jsr exit_hypervisor
    rts
}
syscall63: {
    jsr exit_hypervisor
    rts
}
syscall62: {
    jsr exit_hypervisor
    rts
}
syscall61: {
    jsr exit_hypervisor
    rts
}
syscall60: {
    jsr exit_hypervisor
    rts
}
syscall59: {
    jsr exit_hypervisor
    rts
}
syscall58: {
    jsr exit_hypervisor
    rts
}
syscall57: {
    jsr exit_hypervisor
    rts
}
syscall56: {
    jsr exit_hypervisor
    rts
}
syscall55: {
    jsr exit_hypervisor
    rts
}
syscall54: {
    jsr exit_hypervisor
    rts
}
syscall53: {
    jsr exit_hypervisor
    rts
}
syscall52: {
    jsr exit_hypervisor
    rts
}
syscall51: {
    jsr exit_hypervisor
    rts
}
syscall50: {
    jsr exit_hypervisor
    rts
}
syscall49: {
    jsr exit_hypervisor
    rts
}
syscall48: {
    jsr exit_hypervisor
    rts
}
syscall47: {
    jsr exit_hypervisor
    rts
}
syscall46: {
    jsr exit_hypervisor
    rts
}
syscall45: {
    jsr exit_hypervisor
    rts
}
syscall44: {
    jsr exit_hypervisor
    rts
}
syscall43: {
    jsr exit_hypervisor
    rts
}
syscall42: {
    jsr exit_hypervisor
    rts
}
syscall41: {
    jsr exit_hypervisor
    rts
}
syscall40: {
    jsr exit_hypervisor
    rts
}
syscall39: {
    jsr exit_hypervisor
    rts
}
syscall38: {
    jsr exit_hypervisor
    rts
}
syscall37: {
    jsr exit_hypervisor
    rts
}
syscall36: {
    jsr exit_hypervisor
    rts
}
syscall35: {
    jsr exit_hypervisor
    rts
}
syscall34: {
    jsr exit_hypervisor
    rts
}
syscall33: {
    jsr exit_hypervisor
    rts
}
syscall32: {
    jsr exit_hypervisor
    rts
}
syscall31: {
    jsr exit_hypervisor
    rts
}
syscall30: {
    jsr exit_hypervisor
    rts
}
syscall29: {
    jsr exit_hypervisor
    rts
}
syscall28: {
    jsr exit_hypervisor
    rts
}
syscall27: {
    jsr exit_hypervisor
    rts
}
syscall26: {
    jsr exit_hypervisor
    rts
}
syscall25: {
    jsr exit_hypervisor
    rts
}
syscall24: {
    jsr exit_hypervisor
    rts
}
syscall23: {
    jsr exit_hypervisor
    rts
}
syscall22: {
    jsr exit_hypervisor
    rts
}
syscall21: {
    jsr exit_hypervisor
    rts
}
syscall20: {
    jsr exit_hypervisor
    rts
}
syscall19: {
    jsr exit_hypervisor
    rts
}
syscall18: {
    jsr exit_hypervisor
    rts
}
syscall17: {
    jsr exit_hypervisor
    rts
}
syscall16: {
    jsr exit_hypervisor
    rts
}
syscall15: {
    jsr exit_hypervisor
    rts
}
syscall14: {
    jsr exit_hypervisor
    rts
}
syscall13: {
    jsr exit_hypervisor
    rts
}
securexit: {
    jsr exit_hypervisor
    rts
}
securentr: {
    jsr exit_hypervisor
    rts
}
syscall10: {
    jsr exit_hypervisor
    rts
}
syscall9: {
    jsr exit_hypervisor
    rts
}
syscall8: {
    jsr exit_hypervisor
    rts
}
syscall7: {
    jsr exit_hypervisor
    rts
}
syscall6: {
    jsr exit_hypervisor
    rts
}
syscall5: {
    jsr exit_hypervisor
    rts
}
syscall4: {
    jsr exit_hypervisor
    rts
}
//The rest of the SYSCALL handler functions
syscall3: {
    jsr exit_hypervisor
    rts
}
syscall2: {
    lda #'('
    sta SCREEN+$4e
    rts
}
//SYSCALL Handlers to display a character
syscall1: {
    lda #')'
    sta SCREEN+$4f
    rts
}
.segment Syscall
  //Fill in struct
  SYSCALLS: .byte JMP
  .word syscall1
  .byte NOP, JMP
  .word syscall2
  .byte NOP, JMP
  .word syscall3
  .byte NOP, JMP
  .word syscall4
  .byte NOP, JMP
  .word syscall5
  .byte NOP, JMP
  .word syscall6
  .byte NOP, JMP
  .word syscall7
  .byte NOP, JMP
  .word syscall8
  .byte NOP, JMP
  .word syscall9
  .byte NOP, JMP
  .word syscall10
  .byte NOP, JMP
  .word securentr
  .byte NOP, JMP
  .word securexit
  .byte NOP, JMP
  .word syscall13
  .byte NOP, JMP
  .word syscall14
  .byte NOP, JMP
  .word syscall15
  .byte NOP, JMP
  .word syscall16
  .byte NOP, JMP
  .word syscall17
  .byte NOP, JMP
  .word syscall18
  .byte NOP, JMP
  .word syscall19
  .byte NOP, JMP
  .word syscall20
  .byte NOP, JMP
  .word syscall21
  .byte NOP, JMP
  .word syscall22
  .byte NOP, JMP
  .word syscall23
  .byte NOP, JMP
  .word syscall24
  .byte NOP, JMP
  .word syscall25
  .byte NOP, JMP
  .word syscall26
  .byte NOP, JMP
  .word syscall27
  .byte NOP, JMP
  .word syscall28
  .byte NOP, JMP
  .word syscall29
  .byte NOP, JMP
  .word syscall30
  .byte NOP, JMP
  .word syscall31
  .byte NOP, JMP
  .word syscall32
  .byte NOP, JMP
  .word syscall33
  .byte NOP, JMP
  .word syscall34
  .byte NOP, JMP
  .word syscall35
  .byte NOP, JMP
  .word syscall36
  .byte NOP, JMP
  .word syscall37
  .byte NOP, JMP
  .word syscall38
  .byte NOP, JMP
  .word syscall39
  .byte NOP, JMP
  .word syscall40
  .byte NOP, JMP
  .word syscall41
  .byte NOP, JMP
  .word syscall42
  .byte NOP, JMP
  .word syscall43
  .byte NOP, JMP
  .word syscall44
  .byte NOP, JMP
  .word syscall45
  .byte NOP, JMP
  .word syscall46
  .byte NOP, JMP
  .word syscall47
  .byte NOP, JMP
  .word syscall48
  .byte NOP, JMP
  .word syscall49
  .byte NOP, JMP
  .word syscall50
  .byte NOP, JMP
  .word syscall51
  .byte NOP, JMP
  .word syscall52
  .byte NOP, JMP
  .word syscall53
  .byte NOP, JMP
  .word syscall54
  .byte NOP, JMP
  .word syscall55
  .byte NOP, JMP
  .word syscall56
  .byte NOP, JMP
  .word syscall57
  .byte NOP, JMP
  .word syscall58
  .byte NOP, JMP
  .word syscall59
  .byte NOP, JMP
  .word syscall60
  .byte NOP, JMP
  .word syscall61
  .byte NOP, JMP
  .word syscall62
  .byte NOP, JMP
  .word syscall63
  .byte NOP, JMP
  .word syscall64
  .byte NOP
  //Create traps
  .align $100
  TRAPS: .byte JMP
  .word reset
  .byte NOP, JMP
  .word pagfault
  .byte NOP, JMP
  .word restorkey
  .byte NOP, JMP
  .word alttabkey
  .byte NOP, JMP
  .word VF011RD
  .byte NOP, JMP
  .word VF011WR
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word reserved_trap
  .byte NOP, JMP
  .word CPUKIL
  .byte NOP
