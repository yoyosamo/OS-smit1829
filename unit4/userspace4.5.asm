.pc = $801 "Basic"
:BasicUpstart(main)
.pc = $80d "Program"
main: {
    lda #<string
    sta.z print_string.string
    lda #>string
    sta.z print_string.string+1
    jsr print_string
    jsr get_os_version
    lda #<get_os_version.return
    sta.z print_string.string
    lda #>get_os_version.return
    sta.z print_string.string+1
    jsr print_string
  __b1:
    jmp __b1
    string: .text "os version: "
    .byte 0
}
// print_string(byte* zeropage(4) string)
print_string: {
    .label i = 2
    .label string = 4
    lda #<$300
    sta.z i
    lda #>$300
    sta.z i+1
  __b1:
    lda #0
    tay
    cmp (string),y
    beq __b3
    lda.z i+1
    cmp #>$3ff
    bcc __b2
    bne !+
    lda.z i
    cmp #<$3ff
    bcc __b2
  !:
  __b3:
    lda #0
    tay
    sta (i),y
    jsr call_syscall02
    rts
  __b2:
    ldy #0
    lda (string),y
    sta (i),y
    inc.z i
    bne !+
    inc.z i+1
  !:
    inc.z string
    bne !+
    inc.z string+1
  !:
    jmp __b1
}
//Print a message to the screen
call_syscall02: {
    jsr enable_syscalls
    lda #0
    sta $d642
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
get_os_version: {
    //return from shared mem
    .label return = $300
    jsr call_syscall03
    rts
}
call_syscall03: {
    jsr enable_syscalls
    lda #0
    sta $d643
    nop
    rts
}
