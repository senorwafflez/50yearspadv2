.var music = LoadSid("Happy_Birthday.sid")
.pc = music.location "Music"
.fill music.size, music.getData(i)

.import source "padbitmap.asm"
.import source "padscreencolors.asm"

.pc = $0801 "Program Start"
:BasicUpstart($1000)

.pc = $1000 "Main interrupt"
	
        jsr init
		sei
		lda #$7f
		sta $dc0d
		lda #$81
		sta $d01a

		lda #<irq
		sta $fffe
		lda #>irq
		sta $ffff

		lda #<nmi
		sta $fffa
		lda #>nmi
		sta $fffb

		lda #$1b
		sta $d011
		sta $d012
		sta $d019

  		lda #$35
        sta $01

        lda #$00
        jsr music.init

        cli
        jmp *

nmi:
		rti

init:
        lda #$93
        jsr $ffd2

		ldx #$00
setimgcolors:		
		lda padscreencolors,x
		sta $0400,x
		lda padscreencolors + $100,x
		sta $0500,x
		lda padscreencolors + $200,x
		sta $0600,x
		lda padscreencolors + $300,x
		sta $0700,x

		inx
		bne setimgcolors
        rts        

irq:	pha
		jsr stabilize_raster
		txa
		pha
		tya
		pha
		lda #$ff
		sta $d019

		lda #$03
		sta $dd00

        lda #$00
        sta $d020
        sta $d021

		lda #$3b
		sta $d011
		lda #$08
		sta $d016
		lda #$18
		sta $d018

       
        lda #$f9
		sta $d012
		lda #<irq2
		sta $fffe
		lda #>irq2
		sta $ffff
		pla
		tay
		pla
		tax
		pla
		rti


irq2:	pha
		txa
		pha
		tya
		pha
		lda #$ff
		sta $d019

        lda #$02
        sta $d020

        inc $d020
    //    jsr music.play
        dec $d020


		lda #$30
		sta $d012
		lda #<irq
		sta $fffe
		lda #>irq
		sta $ffff
		pla
		tay
		pla
		tax
		pla
		rti		


stabilize_raster:      
        ldx #$ff
        ldy #$00
        stx $dc00
        sty $dc02
        stx $dc03
        stx $dc01
        sty $dc01
        stx $dc01
        lda $d013
        stx $dc02
        sty $dc03
        stx $dc01

        ldx #$7f
        stx $dc00
        lsr 
        lsr 
        lsr 
        sta timeout+1
        bcc timing
timing: clv
timeout:
        bvc timeout
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
         
        nop
        nop
        nop
        nop
        nop
        
        lda $d012 
        and #%00000111 
        tax
        lda delay,x         
        tax
        dex
        bne *-1
stabilizer_raster_000:        
        rts

delay: .byte 1,1,1,1,$10,$10,1,1
