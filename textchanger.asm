.import source "greetingstext.asm"

.pc = $4200 "Textchanger"

//.var charsetload = $4000
.var lineadd = $140

.var linenumberstart = 14
.var line1start = $2000 + $140 * linenumberstart

textcountdown:
.byte $80
canchangetext:
.byte $02
canchangeline2:
.byte $01
canchangeline3:
.byte $01
canchangeline4:
.byte $01
canchangeline5:
.byte $01
canchangeline6:
.byte $01


textchanger:

    lda canchangetext
    bne checkline2

    jsr executetextchange
    jmp skipcolorsetthisframe

checkline2:
    lda canchangeline2
    bne checkline3

    jsr executetextchange2
    jmp skipcolorsetthisframe

checkline3:
    lda canchangeline3
    bne checkline4

    jsr executetextchange3
    jmp skipcolorsetthisframe

checkline4:
    lda canchangeline4
    bne checkline5

    jsr executetextchange4
    jmp skipcolorsetthisframe

checkline5:
    lda canchangeline5
    bne checkline6

    jsr executetextchange5
    jmp skipcolorsetthisframe

checkline6:
    lda canchangeline6
    bne docountdown

    jsr executetextchange6
    jmp skipcolorsetthisframe

docountdown:
    lda canchangetext
    cmp #$01
    bne keepchangingcolors

    jsr movenextext

keepchangingcolors:

    ldx #$00
colorline1:    
    lda colorchangetable
    sta $0400 + linenumberstart * 40,x
colorline2:
    lda colorchangetable
    sta $0400 + linenumberstart * 40 + 40,x
colorline3:
    lda colorchangetable
    sta $0400 + linenumberstart * 40 + 80,x
colorline4:
    lda colorchangetable
    sta $0400 + linenumberstart * 40 + 120,x
colorline5:
    lda colorchangetable
    sta $0400 + linenumberstart * 40 + 160,x
colorline6:
    lda colorchangetable
    sta $0400 + linenumberstart * 40 + 200,x

    inx
    cpx #$10
    bne colorline1

    lda colorline1 + 1
    clc
    adc #$01
    sta colorline1 + 1
    adc #$02
    sta colorline2 + 1
    adc #$02
    sta colorline3 + 1
    adc #$02
    sta colorline4 + 1
    adc #$02
    sta colorline5 + 1
    adc #$02
    sta colorline6 + 1

    lda colorline1 + 1
    cmp #$f8
    beq setcanchangetext

 skipcolorsetthisframe:   
    rts

setcanchangetext:
    lda #$01
    sta canchangetext
    rts

movenextext:
    // lda #$80
    // sta textcountdown
    lda #$00
    sta canchangetext

nexttext:
    ldx #$00
    lda greetingsloByte,x
    sta $fa
    lda greetingshiByte,x
    sta $fb

    ldy #$00
    ldx #$00
movetexttooutput:    
    lda ($fa),y
    sta textforoutput,x
    inx
    iny
    cpx #$60
    bne movetexttooutput

    inc nexttext + 1
    lda nexttext + 1
    cmp #$06
    bne notextchangereset

    lda #$00
    sta nexttext + 1

notextchangereset:
    rts


greetingsloByte:
    .byte $00, $80, $00, $80, $00, $80

greetingshiByte:
    .byte $09, $09, $0a, $0a, $0b, $0b

executetextchange:
    lda #$02
    sta canchangetext
    lda #$00
    sta canchangeline2   

    ldx #$00   
    .for (var j = 0; j < 16; j++)
    {       
        lda textforoutput + j,x
        asl
        asl
        asl
        sta $fa
        lda #$40
        sta $fb
        bcc lowchar        
        inc $fb

        lowchar:
        ldy #$00
        .for (var i = 0; i < 8; i++)
        {
            lda ($fa),y
            sta line1start + j*8,y
            iny
        }
    }
   
    rts

executetextchange2:
    lda #$01
    sta canchangeline2
    lda #$00
    sta canchangeline3

    ldx #$00   
    .for (var j = 0; j < 16; j++)
    {       
        lda textforoutput + 16 + j,x
        asl
        asl
        asl
        sta $fa
        lda #$40
        sta $fb
        bcc lowchar        
        inc $fb

        lowchar:
        ldy #$00
        .for (var i = 0; i < 8; i++)
        {
            lda ($fa),y
            sta line1start + lineadd * 1 + j * 8,y
            iny
        }
    }
    rts

executetextchange3:
    lda #$01
    sta canchangeline3
    lda #$00
    sta canchangeline4

    ldx #$00   
    .for (var j = 0; j < 16; j++)
    {       
        lda textforoutput + 16*2 + j,x
        asl
        asl
        asl
        sta $fa
        lda #$40
        sta $fb
        bcc lowchar        
        inc $fb

        lowchar:
        ldy #$00
        .for (var i = 0; i < 8; i++)
        {
            lda ($fa),y
            sta line1start + lineadd * 2 + j * 8,y
            iny
        }
    }
    rts

executetextchange4:
    lda #$01
    sta canchangeline4
    lda #$00
    sta canchangeline5

    ldx #$00   
    .for (var j = 0; j < 16; j++)
    {       
        lda textforoutput + 16*3 + j,x
        asl
        asl
        asl
        sta $fa
        lda #$40
        sta $fb
        bcc lowchar        
        inc $fb

        lowchar:
        ldy #$00
        .for (var i = 0; i < 8; i++)
        {
            lda ($fa),y
            sta line1start + lineadd * 3 + j * 8,y
            iny
        }
    }
    rts

executetextchange5:
    lda #$01
    sta canchangeline5
    lda #$00
    sta canchangeline6

    ldx #$00   
    .for (var j = 0; j < 16; j++)
    {       
        lda textforoutput + 16*4 + j,x
        asl
        asl
        asl
        sta $fa
        lda #$40
        sta $fb
        bcc lowchar        
        inc $fb

        lowchar:
        ldy #$00
        .for (var i = 0; i < 8; i++)
        {
            lda ($fa),y
            sta line1start + lineadd * 4 + j * 8,y
            iny
        }
    }
    rts

executetextchange6:
    lda #$01
    sta canchangeline6

    ldx #$00   
    .for (var j = 0; j < 16; j++)
    {       
        lda textforoutput + 16*5 + j,x
        asl
        asl
        asl
        sta $fa
        lda #$40
        sta $fb
        bcc lowchar        
        inc $fb

        lowchar:
        ldy #$00
        .for (var i = 0; i < 8; i++)
        {
            lda ($fa),y
            sta line1start + lineadd * 5 + j * 8,y
            iny
        }
    }
    rts

textforoutput:
    .text "1234567890123456"
    .text "abcdefghijklmnop"
    .text "qrstuvwxyzabcdef"
    .text "ghijklmnopqrstuv"
    .text "wxyzabcdefghijkl"
    .text "mnopqrstuvwxyz12"

.pc = $6800 "Textchanger colortable"
colorchangetable:
.byte $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00

.byte $60, $60, $60, $60, $40, $40, $40, $40
.byte $e0, $e0, $e0, $e0, $f0, $f0, $f0, $f0
.byte $10, $10, $10, $10, $10, $10, $10, $10
.byte $10, $10, $10, $10, $10, $10, $10, $10

.byte $10, $10, $10, $10, $10, $10, $10, $10
.byte $10, $10, $10, $10, $10, $10, $10, $10
.byte $10, $10, $10, $10, $10, $10, $10, $10
.byte $10, $10, $10, $10, $10, $10, $10, $10

.byte $10, $10, $10, $10, $10, $10, $10, $10
.byte $10, $10, $10, $10, $10, $10, $10, $10
.byte $10, $10, $10, $10, $10, $10, $10, $10
.byte $10, $10, $10, $10, $10, $10, $10, $10

.byte $10, $10, $10, $10, $10, $10, $10, $10
.byte $10, $10, $10, $10, $10, $10, $10, $10
.byte $10, $10, $10, $10, $10, $10, $10, $10
.byte $10, $10, $10, $10, $10, $10, $10, $10

.byte $10, $10, $10, $10, $10, $10, $10, $10
.byte $10, $10, $10, $10, $10, $10, $10, $10
.byte $10, $10, $10, $10, $10, $10, $10, $10
.byte $10, $10, $10, $10, $10, $10, $10, $10

.byte $10, $10, $10, $10, $10, $10, $10, $10
.byte $10, $10, $10, $10, $10, $10, $10, $10
.byte $f0, $f0, $f0, $f0, $e0, $e0, $e0, $e0
.byte $40, $40, $40, $40, $60, $60, $60, $60

.byte $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00
.byte $00, $00, $00, $00, $00, $00, $00, $00
