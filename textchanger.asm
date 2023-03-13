.pc = $4200 "Textchanger"

//.var charsetload = $4000
.var lineadd = $140
.var line1start = $2140

textchanger:
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
//     rts

// textchanger2:
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

textforoutput:
    .text "1234567890123456"
    .text "abcdefghijklmnop"
    .text "qrstuvwxyzabcdef"
    .text "ghijklmnopqrstuv"
    .text "wxyzabcdefghijkl"
    .text "mnopqrstuvwxyz12"
    .text "3456789012345678"