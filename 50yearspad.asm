.var music = LoadSid("Birthday_Pad_Final.sid")
.pc = music.location "Music"
.fill music.size, music.getData(i)

.import source "padbitmap.asm"
.import source "padscreencolors.asm"
.import source "charset.asm"
.import source "textchanger.asm"
.import source "50sprites.asm"
.import source "confettibmp.asm"

.pc = $0801 "Program Start"
:BasicUpstart($c000)

.pc = $c000 "Main interrupt"
	
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

        inc $d020
        jsr textchanger
        dec $d020

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

        ldx #$00
confettiora:        
        lda confettibmp,x
        ora $2000,x
        sta $2000,x
        lda confettibmp+$100,x
        ora $2100,x
        sta $2100,x
        lda confettibmp+$200,x
        ora $2200,x
        sta $2200,x
        lda confettibmp+$300,x
        ora $2300,x
        sta $2300,x
        lda confettibmp+$400,x
        ora $2400,x
        sta $2400,x
        lda confettibmp+$500,x
        ora $2500,x
        sta $2500,x
        lda confettibmp+$600,x
        ora $2600,x
        sta $2600,x
        inx
        bne confettiora

        ldx #$00
setconfetticols:        
        lda confetticols,x
        cmp #$00
        beq skipsetcol
        sta $0400,x
skipsetcol:
        inx
        bne setconfetticols

        lda #$02
        sta canchangetext
        lda #$00
        sta colorline1 + 1
        clc
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

        // jsr setsprites
        jsr colorchangeconfetti
        jsr spritecolorchanger
        jsr music.play



        lda #$02
        sta $d020


        lda #$fa
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

        lda #$0a
        sta $d020

        jsr setsprites
        //jsr textchanger

        lda #$06
        sta $d020

        dec iloop + 1

	lda #$50
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

spriteyadd:
        .byte $80

setsprites:
spritecolindex:
        ldx #$00
        lda sprite_light,x
        sta $d027
        sta $d028
        sta $d029
        sta $d02a
        sta $d02b
        sta $d02c
        sta $d02d
        sta $d02e

        lda sprite_medium,x
        sta $d025

        lda sprite_dark,x
        sta $d026

        //min x = $18
        //max x = $f7
spriteblock1Xpos:        

sp1_xpos:
        ldx #$00
        lda sprite_x1,x
        sta $d000        
        sta $d008

        lda sprite_x2,x
        sta $d002
        sta $d00a

        lda sprite_x3,x
        sta $d004
        sta $d00c
        
 sp4_xpos:
        ldx #$00       
        lda sprite_x4,x
        sta $d006
        sta $d00e
        lda sprite_y4,x
        clc
        adc spriteyadd
        sta $d001
        sta $d007
        lda sprite_y8,x
        clc
        adc spriteyadd
        adc #$15
        sta $d009
        sta $d00f
   
        //lda do10_x4,x
        // ora do10 + 1
        //sta do10 + 1

spriteblock1Ypos:
        //lda #$80  //start $32
        //sta $d001
sp2_ypos:
        ldx #$00
        lda sprite_y2,x
        clc
        adc #$80
        sta $d003
        sta $d005
        //sta $d007

        lda #spr_img0/ 64
        sta $07f8
        lda #spr_img1/ 64
        sta $07f9

        lda #spr_img2 / 64
        sta $07fa
        lda #spr_img3 / 64
        sta $07fb

        //min x = $18
        //max x = $f7
spriteblock2Xpos:        
        // lda #$88
        // clc
        // adc #$18
        // //sta $d00a
        // adc #$18
        // sta $d00c
        // adc #$18
        // sta $d00e

spriteblock2Ypos:

sp6_ypos:
        ldx #$00
        lda sprite_y6,x
        clc
        adc spriteyadd
        adc #$15
        // lda #$80+21
        // sta $d009
        sta $d00b
        sta $d00d
        //sta $d00f

        lda #spr_img4 / 64
        sta $07fc
        lda #spr_img5 / 64
        sta $07fd

        lda #spr_img6 / 64
        sta $07fe
        lda #spr_img7 / 64
        sta $07ff

incsp4:
        inc sp4_xpos + 1
        inc sp1_xpos + 1
        inc sp6_ypos + 1
        inc sp2_ypos + 1

        lda sp4_xpos + 1
        cmp #$80
        bne incsp5

        lda #$00
        sta sp1_xpos + 1
        sta sp4_xpos + 1
        sta sp6_ypos + 1
        sta sp2_ypos + 1

incsp5:

do10:
        lda #%00000000
        sta $d010
        rts

colorchangeconfetti:
        ldx #$00
        lda confetti1,x
        sta $0405

        inc colorchangeconfetti + 1
        lda colorchangeconfetti + 1
        cmp #$40
        bne colorchangeconfetti2

        lda #$00
        sta colorchangeconfetti + 1

colorchangeconfetti2:
        ldx #$0f
        lda confetti3,x

        sta $040a+40*2
        sta $040a+40*3
        sta $040a+40*4

        inc colorchangeconfetti2 + 1
        lda colorchangeconfetti2 + 1
        cmp #$70
        bne colorchangeconfetti3

        lda #$00
        sta colorchangeconfetti2 + 1

colorchangeconfetti3:
        ldx #$00
        lda confetti2,x

        sta $0404+40*3
        sta $0405+40*3
        sta $0404+40*4
        sta $0405+40*4


        inc colorchangeconfetti3 + 1
        lda colorchangeconfetti3 + 1
        cmp #$50
        bne colorchangeconfetti4

        lda #$00
        sta colorchangeconfetti3 + 1

colorchangeconfetti4:
        ldx #$00
        lda confetti4,x
        sta $0412+40
        // sta $0405+40*3
        // sta $0404+40*4
        // sta $0405+40*4


        inc colorchangeconfetti4 + 1
        lda colorchangeconfetti4 + 1
        cmp #$50
        bne colorchangeconfetti5

        lda #$00
        sta colorchangeconfetti4 + 1

colorchangeconfetti5:
        rts

musicbyte1:
		.byte $00

spritecolorchanger:
        lda $14fd
	cmp #$5f
	beq incspritecolorindex
        rts

incspritecolorindex:
        // lda $c078+11
	// sta musicbyte1

        inc spritecolindex + 1
        lda spritecolindex + 1
        cmp #$07
        bne notresetspritecolindex

        lda #$00
        sta spritecolindex + 1

notresetspritecolindex:

        rts

.pc = $6900 "Confetticolors"
confetti1:
.byte $20, $20, $20, $20, $20, $20, $a0, $a0, $a0, $a0, $a0, $a0, $70, $70, $70, $70
.byte $70, $70, $f0, $f0, $f0, $f0, $f0, $f0, $10, $10, $10, $10, $10, $10, $f0, $f0
.byte $f0, $f0, $f0, $f0, $70, $70, $70, $70, $70, $70, $a0, $a0, $a0, $a0, $a0, $a0
.byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20

confetti2:
.byte $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0
.byte $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $10, $10, $10, $10, $10, $10, $10, $10
.byte $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10
.byte $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0
.byte $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0, $e0

confetti3:
.byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20
.byte $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $70, $70, $70, $70, $70, $70, $70, $70
.byte $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $10, $10, $10, $10, $10, $10, $10, $10
.byte $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10
.byte $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $70, $70, $70, $70, $70, $70, $70, $70
.byte $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $20, $20, $20, $20, $20, $20, $20, $20
.byte $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20, $20

.pc = $6a00 "Spritecolors"

sprite_light:
.byte $0f, $0f, $07, $0a, $0f, $0f, $0d

sprite_medium:
.byte $0e, $0a, $0d, $08, $0a, $0c, $05

sprite_dark:
.byte $06, $02, $05, $09, $04, $0b, $0b

.pc = $6a40 "Confetti 4 colors"

confetti4:
.byte $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0
.byte $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $10, $10, $10, $10, $10, $10, $10, $10
.byte $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10, $10
.byte $f0, $f0, $f0, $f0, $f0, $f0, $f0, $f0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0
.byte $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0

.pc = $6b00 "Sprite Top Right Corner"
sprite_x4:
        .byte $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0
        .byte $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0
        .byte $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0
        .byte $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0

        .byte $d0, $d0, $d1, $d1, $d2, $d4, $d6, $d8, $da, $dc, $de, $e0, $e2, $e3, $e3, $e4
        .byte $e4, $e4, $e4, $e3, $e3, $e2, $e0, $de, $dc, $da, $d8, $d6, $d4, $d2, $d1, $d1
        .byte $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0
        .byte $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0, $d0

sprite_y4:
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

        .byte $00, $00, $ff, $ff, $fe, $fc, $fa, $f8, $f6, $f4, $f2, $f0, $ee, $ed, $ed, $ec
        .byte $ec, $ec, $ec, $ed, $ed, $ee, $f0, $f2, $f4, $f6, $f8, $fa, $fc, $fe, $ff, $ff
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

.pc = $6c00 "Sprite Bottom Right Corner"
sprite_y8:
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

        .byte $00, $00, $01, $01, $02, $04, $06, $08, $0a, $0c, $0e, $10, $12, $13, $13, $14
        .byte $14, $14, $14, $13, $13, $12, $10, $0e, $0c, $0a, $08, $06, $04, $02, $01, $01
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

.pc = $6d00 "Sprite Upper Left Corner"
sprite_x1:
        .byte $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88
        .byte $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88
        .byte $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88
        .byte $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88

        .byte $88, $88, $87, $87, $86, $84, $82, $80, $7e, $7c, $7a, $78, $76, $75, $75, $74
        .byte $74, $74, $74, $75, $75, $76, $78, $7a, $7c, $7e, $80, $82, $84, $86, $87, $87
        .byte $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88
        .byte $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88, $88

.pc = $6e00 "Sprite lower middle Y"
sprite_y6:
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

        .byte $00, $00, $00, $01, $01, $02, $03, $04, $05, $06, $07, $08, $09, $09, $0a, $0a
        .byte $0a, $0a, $0a, $0a, $09, $09, $08, $07, $06, $05, $04, $03, $02, $01, $01, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

.pc = $6f00 "Sprite upper middle Y"

sprite_y2:
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00

        .byte $00, $00, $00, $ff, $ff, $fe, $fd, $fc, $fb, $fa, $f9, $f8, $f7, $f7, $f6, $f6
        .byte $f6, $f6, $f6, $f6, $f7, $f7, $f8, $f9, $fa, $fb, $fc, $fd, $fe, $ff, $ff, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00, $00


.pc = $7000 "Sprite upper + lower left middle X"

sprite_x2:
        .byte $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0
        .byte $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0
        .byte $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0
        .byte $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0

        .byte $a0, $a0, $a0, $9f, $9f, $9e, $9d, $9c, $9b, $9a, $99, $98, $97, $97, $96, $96
        .byte $96, $96, $96, $96, $97, $97, $98, $99, $9a, $9b, $9c, $9d, $9e, $9f, $9f, $a0
        .byte $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0
        .byte $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0, $a0

sprite_x3:
        .byte $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8
        .byte $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8
        .byte $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8
        .byte $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8

        .byte $b8, $b8, $b8, $b9, $b9, $ba, $bb, $bc, $bd, $be, $bf, $c0, $c1, $c1, $c2, $c2
        .byte $c2, $c2, $c2, $c2, $c1, $c1, $c0, $bf, $be, $bd, $bc, $bb, $ba, $b9, $b9, $b8
        .byte $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8
        .byte $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8, $b8

