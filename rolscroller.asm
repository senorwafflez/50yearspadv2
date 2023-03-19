.var rollineadd = $140

.var rollinenumberstart = 22
.var rolline1start = $2000 + rollineadd * rollinenumberstart
.var rolwidth = 20

.pc = $7d00 "Rolscroller"
setnewrolbyte:

    lda #$10
    sta rolcounter + 1

scrolltextfetch:
    lda $9000
    cmp #$00 
    bne noresetscrolltext

    lda #$00
    sta scrolltextfetch + 1
    lda #$90
    sta scrolltextfetch + 2
    lda #$00
    jmp skipasl

noresetscrolltext:
    asl
    asl
    asl

 skipasl:   
    sta char1a + 1
    sta char1b + 1
    sta char1c + 1
    sta char1d + 1
    
    ldy #$88
    bcc nohighchar

    iny

nohighchar:
    sty char1a + 2
    iny
    iny
    sty char1b + 2
    iny
    iny 
    sty char1c + 2
    iny
    iny 
    sty char1d + 2

    ldx #$00
setnewbytebyte:    

char1a:
    lda $8808,x
    sta bytesetter1,x
char1b:    
    lda $8a08,x
    sta bytesetter1 + 8,x
char1c:
    lda $8c08,x
    sta bytesetter2,x
char1d:
    lda $8e08,x
    sta bytesetter2 + 8,x
    inx 
    cpx #$08
    bne setnewbytebyte

    inc scrolltextfetch + 1
    lda scrolltextfetch + 1
    cmp #$00
    bne noinchighbytescrolltext

    inc scrolltextfetch + 2

noinchighbytescrolltext:
    rts

bytesetter1:
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00
bytesetter2:
    .byte $00, $00, $00, $00, $00, $00, $00, $00
    .byte $00, $00, $00, $00, $00, $00, $00, $00

rolscroller:
    
rolcounter:    
    lda #$10
    bne keeprolling

    jsr setnewrolbyte

keeprolling:

    dec rolcounter + 1

    .for (var j = 0; j < 8; j++)
    {
        asl bytesetter1 + 8 + j
        rol bytesetter1 + j
        .for (var i = rolwidth; i >= 0; i--)
        {
            rol rolline1start + i*8 + j
        }
    }   

   .for (var j = 0; j < 8; j++)
    {
        asl bytesetter2 + 8 + j
        rol bytesetter2 + j
        .for (var i = rolwidth; i >= 0; i--)
        {
            rol rolline1start + i*8 + j + $140
        }
    }   
    
    rts