  .file [name="checkpoint3.5.bin", type="bin", segments="XMega65Bin"]
.segmentdef XMega65Bin [segments="Syscall, Code, Data, Stack, Zeropage"]
.segmentdef Syscall [start=$8000, max=$81ff]
.segmentdef Code [start=$8200, min=$8200, max=$bdff]
.segmentdef Data [startAfter="Code", min=$8200, max=$bdff]
.segmentdef Stack [min=$be00, max=$beff, fill]
.segmentdef Zeropage [min=$bf00, max=$bfff, fill]
  .const OFFSET_STRUCT_DEVICE_MEMORY_ALLOCATION_LAST_ADDRESS = 2
  .const OFFSET_STRUCT_DEVICE_MEMORY_ALLOCATION_DEVICE_NAME = 4
  .label VIC_MEMORY = $d018
  .label SCREEN = $400
  .label COLS = $d800
  .const WHITE = 1
  .const mem_start = $800
  //Define consts
  .const JMP = $4c
  .const NOP = $ea
  .label device_allocation_count = 5
  .label current_screen_x = 4
  .label current_screen_line = 6
  .label mem_end = $19
  .label current_screen_line_60 = 2
  .label current_screen_line_90 = 2
  .label current_screen_line_117 = 2
  .label current_screen_line_118 = 2
  .label current_screen_line_119 = 2
  .label current_screen_line_120 = 2
  .label current_screen_line_121 = 2
  .label current_screen_line_122 = 2
  .label current_screen_line_123 = 2
  .label current_screen_line_124 = 2
  .label current_screen_line_126 = 2
  .label current_screen_line_127 = 2
  .label current_screen_line_128 = 2
  .label current_screen_line_136 = 2
  .label current_screen_line_137 = 2
  .label current_screen_line_138 = 2
  .label current_screen_line_139 = 2
  .label current_screen_line_140 = 2
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
    lda #0
    sta.z current_screen_x
    lda #<$400
    sta.z current_screen_line_60
    lda #>$400
    sta.z current_screen_line_60+1
    lda #<message
    sta.z print_to_screen.message
    lda #>message
    sta.z print_to_screen.message+1
    jsr print_to_screen
    lda #<$400
    sta.z current_screen_line
    lda #>$400
    sta.z current_screen_line+1
    jsr print_newline
    lda.z current_screen_line
    sta.z current_screen_line_123
    lda.z current_screen_line+1
    sta.z current_screen_line_123+1
    lda #0
    sta.z current_screen_x
    lda #<message1
    sta.z print_to_screen.message
    lda #>message1
    sta.z print_to_screen.message+1
    jsr print_to_screen
    jsr print_newline
    jsr test_memory
    jsr detect_devices
    lda.z current_screen_line
    sta.z current_screen_line_124
    lda.z current_screen_line+1
    sta.z current_screen_line_124+1
    lda #0
    sta.z current_screen_x
    lda #<message2
    sta.z print_to_screen.message
    lda #>message2
    sta.z print_to_screen.message+1
    jsr print_to_screen
  __b1:
    jmp __b1
  .segment Data
    message: .text "smit1829 operating system starting..."
    .byte 0
    message1: .text "testing hardware"
    .byte 0
    message2: .text "hardware test complete"
    .byte 0
}
.segment Code
// print_to_screen(byte* zeropage($d) message)
print_to_screen: {
    .label message = $d
  __b1:
    ldy #0
    lda (message),y
    cmp #0
    bne __b2
    rts
  __b2:
    ldy #0
    lda (message),y
    ldy.z current_screen_x
    sta (current_screen_line_60),y
    inc.z current_screen_x
    inc.z message
    bne !+
    inc.z message+1
  !:
    jmp __b1
}
detect_devices: {
    .label __19 = $13
    .label __28 = 8
    .label vicii = $13
    .label d = $b
    .label mos6526 = 8
    lda #0
    sta.z device_allocation_count
    sta.z current_screen_x
    lda #<$d000
    sta.z d
    lda #>$d000
    sta.z d+1
  //Go through all of the memory, increments of 10
  __b1:
    lda.z d+1
    cmp #>$dff0
    bne !+
    lda.z d
    cmp #<$dff0
  !:
    bcc __b2
    beq __b2
    lda.z current_screen_line
    sta.z current_screen_line_120
    lda.z current_screen_line+1
    sta.z current_screen_line_120+1
    lda #<message
    sta.z print_to_screen.message
    lda #>message
    sta.z print_to_screen.message+1
    jsr print_to_screen
    jsr print_newline
    rts
  __b2:
    jsr memUsed
    lda.z memUsed.return
    cmp #0
    beq !__b5+
    jmp __b5
  !__b5:
    jsr detect_vicii
    lda.z vicii
    bne !+
    lda.z vicii+1
    bne !__b6+
    jmp __b6
  !__b6:
  !:
    lda.z current_screen_line
    sta.z current_screen_line_118
    lda.z current_screen_line+1
    sta.z current_screen_line_118+1
    lda #<message1
    sta.z print_to_screen.message
    lda #>message1
    sta.z print_to_screen.message+1
    jsr print_to_screen
    jsr print_newline
    lda.z d
    sta.z addDevice.first
    lda.z d+1
    sta.z addDevice.first+1
    lda #$7f
    clc
    adc.z d
    sta.z addDevice.last
    lda #0
    adc.z d+1
    sta.z addDevice.last+1
    lda #0
    sta.z current_screen_x
    lda #<name
    sta.z addDevice.name
    lda #>name
    sta.z addDevice.name+1
    jsr addDevice
    lda #<$100
    clc
    adc.z d
    sta.z addDevice.first
    lda #>$100
    adc.z d+1
    sta.z addDevice.first+1
    lda #<$3ff
    clc
    adc.z d
    sta.z addDevice.last
    lda #>$3ff
    adc.z d+1
    sta.z addDevice.last+1
    lda #<name
    sta.z addDevice.name
    lda #>name
    sta.z addDevice.name+1
    jsr addDevice
    lda #<$800
    clc
    adc.z d
    sta.z addDevice.first
    lda #>$800
    adc.z d+1
    sta.z addDevice.first+1
    lda #<$bff
    clc
    adc.z d
    sta.z addDevice.last
    lda #>$bff
    adc.z d+1
    sta.z addDevice.last+1
    lda #<name
    sta.z addDevice.name
    lda #>name
    sta.z addDevice.name+1
    jsr addDevice
    lda.z __19
    sec
    sbc #<$10
    sta.z __19
    lda.z __19+1
    sbc #>$10
    sta.z __19+1
    //Advance by the size (-$10 because it adds that in the loop anyways)
    lda.z d
    clc
    adc.z __19
    sta.z d
    lda.z d+1
    adc.z __19+1
    sta.z d+1
  __b6:
    jsr detect_mos6526
    lda.z mos6526
    bne !+
    lda.z mos6526+1
    beq __b5
  !:
    lda.z current_screen_line
    sta.z current_screen_line_119
    lda.z current_screen_line+1
    sta.z current_screen_line_119+1
    lda #<message2
    sta.z print_to_screen.message
    lda #>message2
    sta.z print_to_screen.message+1
    jsr print_to_screen
    jsr print_newline
    lda.z d
    sta.z addDevice.first
    lda.z d+1
    sta.z addDevice.first+1
    lda #$ff
    clc
    adc.z d
    sta.z addDevice.last
    lda #0
    adc.z d+1
    sta.z addDevice.last+1
    lda #0
    sta.z current_screen_x
    lda #<name3
    sta.z addDevice.name
    lda #>name3
    sta.z addDevice.name+1
    jsr addDevice
    lda.z __28
    sec
    sbc #<$10
    sta.z __28
    lda.z __28+1
    sbc #>$10
    sta.z __28+1
    //Advance by the size (-$10 because it adds that in the loop anyways)
    lda.z d
    clc
    adc.z __28
    sta.z d
    lda.z d+1
    adc.z __28+1
    sta.z d+1
  __b5:
    lda #$10
    clc
    adc.z d
    sta.z d
    bcc !+
    inc.z d+1
  !:
    jmp __b1
  .segment Data
    message: .text "probing devices finished"
    .byte 0
    message1: .text "vicii found"
    .byte 0
    name: .text "vicii"
    .byte 0
    message2: .text "mos6526 found"
    .byte 0
    name3: .text "mos6526"
    .byte 0
}
.segment Code
//Add a device to the list
// addDevice(word zeropage($d) first, word zeropage($17) last, byte* zeropage($15) name)
addDevice: {
    .label first = $d
    .label last = $17
    .label name = $15
    //If there's still room
    lda.z device_allocation_count
    cmp #$10
    bcc __b1
    lda.z current_screen_line
    sta.z current_screen_line_117
    lda.z current_screen_line+1
    sta.z current_screen_line_117+1
    lda #<message
    sta.z print_to_screen.message
    lda #>message
    sta.z print_to_screen.message+1
    jsr print_to_screen
    jsr print_newline
    lda #0
    sta.z current_screen_x
    rts
  __b1:
    lda.z device_allocation_count
    asl
    clc
    adc.z device_allocation_count
    asl
    tax
    lda.z first
    sta device_memory_allocations,x
    lda.z first+1
    sta device_memory_allocations+1,x
    lda.z last
    sta device_memory_allocations+OFFSET_STRUCT_DEVICE_MEMORY_ALLOCATION_LAST_ADDRESS,x
    lda.z last+1
    sta device_memory_allocations+OFFSET_STRUCT_DEVICE_MEMORY_ALLOCATION_LAST_ADDRESS+1,x
    lda.z name
    sta device_memory_allocations+OFFSET_STRUCT_DEVICE_MEMORY_ALLOCATION_DEVICE_NAME,x
    lda.z name+1
    sta device_memory_allocations+OFFSET_STRUCT_DEVICE_MEMORY_ALLOCATION_DEVICE_NAME+1,x
    inc.z device_allocation_count
    rts
  .segment Data
    message: .text "no more devices!"
    .byte 0
}
.segment Code
print_newline: {
    //Add 40 chars, for a new line
    lda #$28
    clc
    adc.z current_screen_line
    sta.z current_screen_line
    bcc !+
    inc.z current_screen_line+1
  !:
    rts
}
// detect_mos6526(word zeropage($b) mem)
detect_mos6526: {
    .label mem = $b
    .label return = 8
    .label v1 = $12
    .label i = $17
    .label j = $15
    //Check for an hour (<23)
    ldy #$b
    lda (mem),y
    cmp #$23+1
    bcc __b1
  b1:
    lda #<0
    sta.z return
    sta.z return+1
    rts
  __b1:
    //Check for a minute
    ldy #$a
    lda (mem),y
    cmp #$59+1
    bcc __b2
    jmp b1
  __b2:
    ldy #9
    lda (mem),y
    clc
    adc #1
    sta.z v1
    lda.z current_screen_line
    sta.z current_screen_line_121
    lda.z current_screen_line+1
    sta.z current_screen_line_121+1
    lda #<message
    sta.z print_to_screen.message
    lda #>message
    sta.z print_to_screen.message+1
    jsr print_to_screen
    lda #<0
    sta.z i
    sta.z i+1
  //Wait a second
  __b3:
    lda.z i+1
    bmi __b4
    cmp #>$3f
    bcc __b4
    bne !+
    lda.z i
    cmp #<$3f
    bcc __b4
  !:
    lda #0
    sta.z current_screen_x
    sta.z return
    sta.z return+1
    rts
  __b4:
    lda.z current_screen_line
    sta.z current_screen_line_122
    lda.z current_screen_line+1
    sta.z current_screen_line_122+1
    lda #0
    sta.z current_screen_x
    lda #<message
    sta.z print_to_screen.message
    lda #>message
    sta.z print_to_screen.message+1
    jsr print_to_screen
    lda.z i
    sta.z print_hex.value
    lda.z i+1
    sta.z print_hex.value+1
    lda.z current_screen_line
    sta.z current_screen_line_136
    lda.z current_screen_line+1
    sta.z current_screen_line_136+1
    jsr print_hex
    lda #<0
    sta.z j
    sta.z j+1
  //It'll be overwritten
  __b5:
    lda.z j
    cmp #<$7d00
    lda.z j+1
    sbc #>$7d00
    bvc !+
    eor #$80
  !:
    bmi __b6
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b3
  __b6:
    ldy #9
    lda (mem),y
    cmp.z v1
    bne __b8
    lda #0
    sta.z current_screen_x
    lda #<$100
    sta.z return
    lda #>$100
    sta.z return+1
    rts
  __b8:
    inc.z j
    bne !+
    inc.z j+1
  !:
    jmp __b5
  .segment Data
    message: .text "testing time..."
    .byte 0
}
.segment Code
// print_hex(word zeropage(8) value)
print_hex: {
    .label __3 = $13
    .label __6 = $15
    .label value = 8
    ldx #0
  __b1:
    cpx #4
    bcc __b2
    lda #0
    sta hex+4
    lda #<hex
    sta.z print_to_screen.message
    lda #>hex
    sta.z print_to_screen.message+1
    jsr print_to_screen
    rts
  __b2:
    lda.z value+1
    cmp #>$a000
    bcc __b4
    bne !+
    lda.z value
    cmp #<$a000
    bcc __b4
  !:
    ldy #$c
    lda.z value
    sta.z __3
    lda.z value+1
    sta.z __3+1
    cpy #0
    beq !e+
  !:
    lsr.z __3+1
    ror.z __3
    dey
    bne !-
  !e:
    lda.z __3
    sec
    sbc #9
    sta hex,x
  __b5:
    asl.z value
    rol.z value+1
    asl.z value
    rol.z value+1
    asl.z value
    rol.z value+1
    asl.z value
    rol.z value+1
    inx
    jmp __b1
  __b4:
    ldy #$c
    lda.z value
    sta.z __6
    lda.z value+1
    sta.z __6+1
    cpy #0
    beq !e+
  !:
    lsr.z __6+1
    ror.z __6
    dey
    bne !-
  !e:
    lda.z __6
    clc
    adc #'0'
    sta hex,x
    jmp __b5
  .segment Data
    hex: .fill 5, 0
}
.segment Code
// detect_vicii(word zeropage($b) mem)
detect_vicii: {
    .label mem = $b
    .label return = $13
    .label i = $d
    ldy #$12
    lda (mem),y
    tax
    lda #<1
    sta.z i
    lda #>1
    sta.z i+1
  //Read from the memory +12
  __b1:
    lda.z i+1
    cmp #>$3e8
    bcc __b3
    bne !+
    lda.z i
    cmp #<$3e8
    bcc __b3
  !:
    //Wait
    ldy #$12
    lda (mem),y
    //If they're different, we must be onto something
    sta.z $ff
    cpx.z $ff
    bcc __b5
    cmp #8
    bcs b1
    cpx #$f8+1
    bcs __b5
  b1:
    lda #<0
    sta.z return
    sta.z return+1
    rts
  __b5:
    lda #<$80
    sta.z return
    lda #>$80
    sta.z return+1
    rts
  __b3:
    inc.z i
    bne !+
    inc.z i+1
  !:
    jmp __b1
}
//Check if the memory has already been claimed
// memUsed(word zeropage($b) mem)
memUsed: {
    .label first = $15
    .label last = $17
    .label return = $a
    .label mem = $b
    ldy #0
  //Go through all the devices
  __b1:
    cpy.z device_allocation_count
    bcc __b2
    lda #0
    sta.z return
    rts
  b1:
    lda #1
    sta.z return
    rts
  __b2:
    tya
    asl
    sty.z $ff
    clc
    adc.z $ff
    asl
    tax
    //Get the first and last memory loc for each device
    lda device_memory_allocations,x
    sta.z first
    lda device_memory_allocations+1,x
    sta.z first+1
    lda device_memory_allocations+OFFSET_STRUCT_DEVICE_MEMORY_ALLOCATION_LAST_ADDRESS,x
    sta.z last
    lda device_memory_allocations+OFFSET_STRUCT_DEVICE_MEMORY_ALLOCATION_LAST_ADDRESS+1,x
    sta.z last+1
    lda.z mem+1
    cmp.z first+1
    bcc __b3
    bne !+
    lda.z mem
    cmp.z first
    bcc __b3
  !:
    lda.z mem+1
    cmp.z last+1
    bne !+
    lda.z mem
    cmp.z last
    beq b1
  !:
    bcc b1
  __b3:
    iny
    jmp __b1
}
test_memory: {
    .label mem = $f
    .label q = $11
    .label okay = $a
    //Keep track of where we are in memory
    lda #<0
    sta.z mem
    sta.z mem+1
    //Keep track of the memory
    sta.z q
    lda #<mem_start
    sta.z mem
    lda #>mem_start
    sta.z mem+1
    lda #1
    sta.z okay
  //Loop through all memory, while we're still okay
  __b1:
    lda.z mem+1
    cmp #>$8000
    bcc !+
    bne __b3
    lda.z mem
    cmp #<$8000
    bcs __b3
  !:
    lda.z okay
    cmp #0
    bne __b2
  __b3:
    lda.z mem
    sta.z mem_end
    lda.z mem+1
    sta.z mem_end+1
    lda.z current_screen_line
    sta.z current_screen_line_128
    lda.z current_screen_line+1
    sta.z current_screen_line_128+1
    lda #0
    sta.z current_screen_x
    lda #<message
    sta.z print_to_screen.message
    lda #>message
    sta.z print_to_screen.message+1
    jsr print_to_screen
    lda.z current_screen_line
    sta.z current_screen_line_137
    lda.z current_screen_line+1
    sta.z current_screen_line_137+1
    lda #<mem_start
    sta.z print_hex.value
    lda #>mem_start
    sta.z print_hex.value+1
    jsr print_hex
    lda.z current_screen_line
    sta.z current_screen_line_127
    lda.z current_screen_line+1
    sta.z current_screen_line_127+1
    lda #<message1
    sta.z print_to_screen.message
    lda #>message1
    sta.z print_to_screen.message+1
    jsr print_to_screen
    lda.z mem_end
    sta.z print_hex.value
    lda.z mem_end+1
    sta.z print_hex.value+1
    lda.z current_screen_line
    sta.z current_screen_line_139
    lda.z current_screen_line+1
    sta.z current_screen_line_139+1
    jsr print_hex
    jsr print_newline
    rts
  __b2:
    lda.z mem
    sta.z print_hex.value
    lda.z mem+1
    sta.z print_hex.value+1
    lda.z current_screen_line
    sta.z current_screen_line_138
    lda.z current_screen_line+1
    sta.z current_screen_line_138+1
    lda #0
    sta.z current_screen_x
    jsr print_hex
    lda #0
    sta.z q
  b1:
  //For each memory location, set 0-254
    lda.z q
    cmp #$ff
    bcc __b5
  __b7:
    inc.z mem
    bne !+
    inc.z mem+1
  !:
    jmp __b1
  __b5:
    //Set this location to this value
    lda.z q
    ldy #0
    sta (mem),y
    cmp (mem),y
    beq __b6
    lda.z current_screen_line
    sta.z current_screen_line_126
    lda.z current_screen_line+1
    sta.z current_screen_line_126+1
    tya
    sta.z current_screen_x
    lda #<message2
    sta.z print_to_screen.message
    lda #>message2
    sta.z print_to_screen.message+1
    jsr print_to_screen
    lda.z mem
    sta.z print_hex.value
    lda.z mem+1
    sta.z print_hex.value+1
    lda.z current_screen_line
    sta.z current_screen_line_140
    lda.z current_screen_line+1
    sta.z current_screen_line_140+1
    jsr print_hex
    jsr print_newline
    lda #0
    sta.z okay
    jmp __b7
  __b6:
    inc.z q
    jmp b1
  .segment Data
    message: .text "memory found at $"
    .byte 0
    message1: .text " - $"
    .byte 0
    message2: .text "memory error at $"
    .byte 0
}
.segment Code
// Copies the character c (an unsigned char) to the first num characters of the object pointed to by the argument str.
// memset(void* zeropage($d) str, byte register(X) c, word zeropage($b) num)
memset: {
    .label end = $b
    .label dst = $d
    .label num = $b
    .label str = $d
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
.segment Data
  //Store the list
  device_memory_allocations: .fill 6*$10, 0
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
