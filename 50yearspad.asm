.var music = LoadSid("Happy_Birthday.sid")
.pc = music.location "Music"
.fill music.size, music.getData(i)

.import source "padbitmap.asm"
.import source "padscreencolors.asm"
.import source "charset.asm"
.import source "textchanger.asm"
.import source "50sprites.asm"
.import source "confettibmp.asm"

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

        jsr setsprites
        jsr colorchangeconfetti
        jsr spritecolorchanger
        //jsr music.play



        lda #$02
        sta $d020


        lda #$c0
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

        jsr textchanger

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
        //max x = $68
spriteblock1Xpos:        
        lda #$30
        sta $d000        
        clc
        adc #$18
        sta $d002
        adc #$18
        sta $d004
        adc #$18
        sta $d006

spriteblock1Ypos:
        lda #$c0  //start $32
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
        lda #$30
        sta $d008
        clc
        adc #$18
        sta $d00a
        adc #$18
        sta $d00c
        adc #$18
        sta $d00e

spriteblock2Ypos:
        lda #$c0+21
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
        rts

spritecolorchanger:
        lda #$20
        beq incspritecolorindex

        dec spritecolorchanger + 1
        rts

incspritecolorindex:
        lda #$20
        sta spritecolorchanger + 1

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
//sprite colors 
// 06, 0e, 0f
// 02, 0a, 0f
// 05, 0d, 07
// 09, 08, 0a
// 04, 0a, 0f
// 0b, 0b, 0c
// 0b, 05, 0d

sprite_light:
.byte $0f, $0f, $07, $0a, $0f, $0f, $0d

sprite_medium:
.byte $0e, $0a, $0d, $08, $0a, $0c, $05

sprite_dark:
.byte $06, $02, $05, $09, $04, $0b, $0b

// .byte $02, $02, $02, $02, $0a, $0a, $0a, $0a, $07, $07, $07, $07, $0f, $0f, $0f, $0f
// .byte $01, $01, $01, $01, $0f, $0f, $0f, $0f, $07, $07, $07, $07, $02, $02, $02, $02