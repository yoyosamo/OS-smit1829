.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    jsr call_syscall00
    jsr call_syscall01
  __b1:
    jmp __b1
}
call_syscall01: {
    jsr enable_syscalls
    //Let us make a syscall
    lda #0
    sta $d641
    //Write here to trigger syscall 01
    nop
    rts
}
enable_syscalls: {
    //Tells the MEGA65 to allow system calls to be made 
    lda #$47
    sta $d02f
    lda #$53
    sta $d02f
    rts
}
call_syscall00: {
    jsr enable_syscalls
    //Let us make a syscall
    lda #0
    sta $d640
    //Write here to trigger syscall 00
    nop
    rts
}
