.import source "greetingstext.asm"

.pc = $4200 "Textchanger"

//.var charsetload = $4000
.var lineadd = $280
.var line1start = $2000 + $140 * 6

textcountdown:
.byte $80
canchangetext:
.byte $02

textchanger:

    lda canchangetext
    bne docountdown

    jsr executetextchange
    jmp skipcolorsetthisframe

docountdown:
    lda canchangetext
    cmp #$01
    bne keepchangingcolors

    jsr movenextext
    // lda textcountdown
    // beq movenextext

    // dec textcountdown  //TODO : set from colorroutine

keepchangingcolors:

    ldx #$00
colorline1:    
    lda colorchangetable
    sta $04f0,x
colorline2:
    lda colorchangetable
    sta $0540,x
colorline3:
    lda colorchangetable
    sta $0590,x
colorline4:
    lda colorchangetable
    sta $05e0,x
colorline5:
    lda colorchangetable
    sta $0630,x
colorline6:
    lda colorchangetable
    sta $0680,x

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
