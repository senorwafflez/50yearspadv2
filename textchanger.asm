.pc = $4200 "Textchanger"

//.var charsetload = $4000

.var line1start = $2000

textchanger:
    lda #$08
    sta $fa
    lda #$40
    sta $fb

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
        // lda charsetload+8,x
        // sta $2000,x
        // lda charsetload + 8*2,x
        // sta $2008,x
        // lda charsetload + 8*3,x
        // sta $2010,x
        // lda charsetload + 8*4,x
        // sta $2018,x

        // lda charsetload + 8*5,x
        // sta $2020,x
        // lda charsetload + 8*6,x
        // sta $2028,x
        // lda charsetload + 8*7,x
        // sta $2030,x
        // lda charsetload + 8*8,x
        // sta $2038,x

        // lda charsetload + 8*9,x
        // sta $2040,x
        // lda charsetload + 8*10,x
        // sta $2048,x
        // lda charsetload + 8*11,x
        // sta $2050,x
        // lda charsetload + 8*12,x
        // sta $2058,x

        // lda charsetload + 8*13,x
        // sta $2060,x
        // lda charsetload + 8*14,x
        // sta $2068,x
        // lda charsetload + 8*15,x
        // sta $2070,x
        // lda charsetload + 8*16,x
        // sta $2078,x
        // iny
        // cpy #$08
        // bne setchartobitmap1
        rts

textforoutput:
    .text "1234567890123456"
    .text "abcdefghijklmnop"
    .text "qrstuvwxyzabcdef"
    .text "ghijklmnopqrstuv"
    .text "wxyzabcdefghijkl"
    .text "mnopqrstuvwxyz12"
    .text "3456789012345678"