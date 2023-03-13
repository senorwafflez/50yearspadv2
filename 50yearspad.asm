.var music = LoadSid("Happy_Birthday.sid")
.pc = music.location "Music"
.fill music.size, music.getData(i)

.import source "padbitmap.asm"
.import source "padscreencolors.asm"
.import source "charset.asm"
.import source "textchanger.asm"
.import source "50sprites.asm"

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
iloop:	
        lda #$00
		beq wait

		lda #$00
		sta iloop+1

        lda #$07
        sta $d020
        jsr textchanger
        lda #$00
        sta $d020

wait:
		jmp iloop

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

        ldx #$00
        lda #$10
setwhitecolorfortext:        
        sta $0400,x
        sta $0428,x
        sta $0450,x
        sta $0478,x
        sta $04a0,x
        sta $04c8,x
        sta $04f0,x
        sta $0518,x
        sta $0540,x
        sta $0568,x
        sta $0590,x
        sta $05b8,x
        sta $05e0,x
        sta $0608,x
        sta $0630,x
        sta $0658,x
        sta $0680,x
        sta $06a8,x
        sta $06d0,x
        sta $06f8,x
        sta $0720,x
        sta $0748,x
        sta $0770,x
        sta $0798,x
        sta $07c0,x
        inx
        cpx #$10
        bne setwhitecolorfortext
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

        lda #$ff
        sta $d015
        sta $d01c

        lda #$00
        sta $d01b
        sta $d01d
        sta $d017

        lda #$06
        sta $d026
        lda #$0e
        sta $d025

        jsr setsprites
        // lda #$07
        // sta $d020
        // jsr textchanger2
        lda #$02
        sta $d020
       
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
        //jsr textchanger
        dec $d020


        dec iloop + 1

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

setsprites:
        lda #$0f
        sta $d027
        sta $d028
        sta $d029
        sta $d02a
        sta $d02b
        sta $d02c
        sta $d02d
        sta $d02e

        //min x = $18
        //max x = $68
spriteblock1Xpos:        
        lda #$80
        sta $d000        
        clc
        adc #$18
        sta $d002
        adc #$18
        sta $d004
        adc #$18
        sta $d006

spriteblock1Ypos:
        lda #$32  //start $32
        sta $d001
        sta $d003
        sta $d005
        sta $d007

        lda #spr_img0/ 64
        sta $07f8
        lda #spr_img1/ 64
        sta $07f9

        lda #spr_img2 / 64
        sta $07fa
        lda #spr_img3 / 64
        sta $07fb

        //min x = $18
        //max x = $68
spriteblock2Xpos:        
        lda #$80
        sta $d008
        clc
        adc #$18
        sta $d00a
        adc #$18
        sta $d00c
        adc #$18
        sta $d00e

spriteblock2Ypos:
        lda #$32+21
        sta $d009
        sta $d00b
        sta $d00d
        sta $d00f

        lda #spr_img4 / 64
        sta $07fc
        lda #spr_img5 / 64
        sta $07fd

        lda #spr_img6 / 64
        sta $07fe
        lda #spr_img7 / 64
        sta $07ff


        rts
