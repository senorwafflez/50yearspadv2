.import source "greetingstext.asm"

.pc = $4200 "Textchanger"

//.var charsetload = $4000
.var lineadd = $280
.var line1start = $2000 + $140 * 6

textcountdown:
.byte $80
canchangetext:
.byte $01

textchanger:

    lda canchangetext
    bne docountdown

    jsr executetextchange

docountdown:
    lda textcountdown
    beq movenextext

    dec textcountdown  //TODO : set from colorroutine
    rts

movenextext:
    lda #$80
    sta textcountdown
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
    lda #$01
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
