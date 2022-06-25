;;;;
; Vectron 65 Plus Graphic Demo
;
; Nick Bild
; nick.bild@gmail.com
; June 2022
;
; Reserved memory:
;
; $0000-$7EFF - RAM
; 		$0000-$0010 - Named variables
; 		$0100-$01FF - 6502 stack
; $7FE0-$7FEF - 6522 VIA 2
; $7FF0-$7FFF - 6522 VIA 1
; $8000-$FFFF - ROM
; 		$FFFA-$FFFB - NMI IRQ Vector
; 		$FFFC-$FFFD - Reset Vector - Stores start address of this ROM.
; 		$FFFE-$FFFF - IRQ Vector
;;;;

		processor 6502

		; Named variables in RAM.
		ORG $0000
addrLow
		.byte #$00
addrMid
		.byte #$00
addrHigh
		.byte #$00
data
		.byte #$00
eyeLow
		.byte #$00
eyeMid
		.byte #$00
eyeHigh
		.byte #$00
ghostColor
		.byte #$00


StartExe	ORG $8000
	cld
	sei						; Disable interrupts.

  ; Set up VIAs.

  ; Disable all VIA interrupts in IER.
	lda #$7F
	sta $7FFE
    sta $7FEE

	; Set DDRB to all outputs.
	lda #$FF
	sta $7FF2

	; Set DDRA to all outputs.
	lda #$FF
	sta $7FF3

	; Set DDRB to all outputs.
	lda #$FF
	sta $7FE2

	; Set DDRA to all outputs.
	lda #$FF
	sta $7FE3

	; Write blank VGA signal to both RAM chips.

	; Set Vectron VGA Plus memory counter to 0.
	lda #$00
	sta addrLow
	sta addrMid
	sta addrHigh

	; Set inital state of WE/CE on Vectron VGA Plus.
	; CE/WE high
  	lda #$03
  	.byte #$0C ; tsb - set bit
  	.word #$7FE0
  	
	; Write VGA signal timings for a blank screen to memory.
	jsr SetupVGA

	; CE low (read mode)
  	; WE high
  	lda #$01
  	.byte #$0C ; tsb - set bit
	.word #$7FE0
  	; CE low
  	lda #$02
  	.byte #$1C ; trb - clear bit
	.word #$7FE0


	; Set Vectron VGA Plus memory counter to 0.
	lda #$00
	sta addrLow
	sta addrMid
	sta addrHigh

	; Set inital state of WE/CE on Vectron VGA Plus.
	; CE/WE high
	lda #$03
  	.byte #$0C ; tsb - set bit
  	.word #$7FE0
  	
	; Write VGA signal timings for a blank screen to memory.
	jsr SetupVGA

	; CE low (read mode)
  	; WE high
  	lda #$01
  	.byte #$0C ; tsb - set bit
	.word #$7FE0
  	; CE low
  	lda #$02
  	.byte #$1C ; trb - clear bit
	.word #$7FE0

	;;; Draw ghost 1.

	lda #$19
	sta ghostColor

	lda #$71
	sta addrLow
	lda #$1F
	sta addrMid
	lda #$00
	sta addrHigh

	lda #$1D
	sta eyeLow
	lda #$61
	sta eyeMid
	lda #$00
	sta eyeHigh

	; CE/WE high
	lda #$03
  	.byte #$0C ; tsb - set bit
  	.word #$7FE0

	jsr DrawGhost

	; CE low (read mode)
  	; WE high
  	lda #$01
  	.byte #$0C ; tsb - set bit
	.word #$7FE0
  	; CE low
  	lda #$02
  	.byte #$1C ; trb - clear bit
	.word #$7FE0

	lda #$19
	sta ghostColor

	lda #$71
	sta addrLow
	lda #$1F
	sta addrMid
	lda #$00
	sta addrHigh

	lda #$1D
	sta eyeLow
	lda #$61
	sta eyeMid
	lda #$00
	sta eyeHigh

	; CE/WE high
	lda #$03
  	.byte #$0C ; tsb - set bit
  	.word #$7FE0

	jsr DrawGhost

	; CE low (read mode)
  	; WE high
  	lda #$01
  	.byte #$0C ; tsb - set bit
	.word #$7FE0
  	; CE low
  	lda #$02
  	.byte #$1C ; trb - clear bit
	.word #$7FE0

	;;; Draw ghost 2.

	lda #$1E
	sta ghostColor

	lda #$2F
	sta addrLow
	lda #$20
	sta addrMid
	lda #$00
	sta addrHigh

	lda #$DB
	sta eyeLow
	lda #$61
	sta eyeMid
	lda #$00
	sta eyeHigh

	; CE/WE high
	lda #$03
  	.byte #$0C ; tsb - set bit
  	.word #$7FE0

	jsr DrawGhost

	; CE low (read mode)
  	; WE high
  	lda #$01
  	.byte #$0C ; tsb - set bit
	.word #$7FE0
  	; CE low
  	lda #$02
  	.byte #$1C ; trb - clear bit
	.word #$7FE0

	lda #$1E
	sta ghostColor

	lda #$2F
	sta addrLow
	lda #$20
	sta addrMid
	lda #$00
	sta addrHigh

	lda #$DB
	sta eyeLow
	lda #$61
	sta eyeMid
	lda #$00
	sta eyeHigh

	; CE/WE high
	lda #$03
  	.byte #$0C ; tsb - set bit
  	.word #$7FE0

	jsr DrawGhost

	; CE low (read mode)
  	; WE high
  	lda #$01
  	.byte #$0C ; tsb - set bit
	.word #$7FE0
  	; CE low
  	lda #$02
  	.byte #$1C ; trb - clear bit
	.word #$7FE0

	;;; Draw ghost 3.

	lda #$1A
	sta ghostColor

	lda #$C1
	sta addrLow
	lda #$5F
	sta addrMid
	lda #$01
	sta addrHigh

	lda #$6D
	sta eyeLow
	lda #$A1
	sta eyeMid
	lda #$01
	sta eyeHigh

	; CE/WE high
	lda #$03
  	.byte #$0C ; tsb - set bit
  	.word #$7FE0

	jsr DrawGhost

	; CE low (read mode)
  	; WE high
  	lda #$01
  	.byte #$0C ; tsb - set bit
	.word #$7FE0
  	; CE low
  	lda #$02
  	.byte #$1C ; trb - clear bit
	.word #$7FE0

	lda #$1A
	sta ghostColor

	lda #$C1
	sta addrLow
	lda #$5F
	sta addrMid
	lda #$01
	sta addrHigh

	lda #$6D
	sta eyeLow
	lda #$A1
	sta eyeMid
	lda #$01
	sta eyeHigh

	; CE/WE high
	lda #$03
  	.byte #$0C ; tsb - set bit
  	.word #$7FE0

	jsr DrawGhost

	; CE low (read mode)
  	; WE high
  	lda #$01
  	.byte #$0C ; tsb - set bit
	.word #$7FE0
  	; CE low
  	lda #$02
  	.byte #$1C ; trb - clear bit
	.word #$7FE0

	;;; Draw ghost 4.

	lda #$1D
	sta ghostColor

	lda #$7F
	sta addrLow
	lda #$60
	sta addrMid
	lda #$01
	sta addrHigh

	lda #$2B
	sta eyeLow
	lda #$A2
	sta eyeMid
	lda #$01
	sta eyeHigh

	; CE/WE high
	lda #$03
  	.byte #$0C ; tsb - set bit
  	.word #$7FE0

	jsr DrawGhost

	; CE low (read mode)
  	; WE high
  	lda #$01
  	.byte #$0C ; tsb - set bit
	.word #$7FE0
  	; CE low
  	lda #$02
  	.byte #$1C ; trb - clear bit
	.word #$7FE0

	lda #$1D
	sta ghostColor

	lda #$7F
	sta addrLow
	lda #$60
	sta addrMid
	lda #$01
	sta addrHigh

	lda #$2B
	sta eyeLow
	lda #$A2
	sta eyeMid
	lda #$01
	sta eyeHigh

	; CE/WE high
	lda #$03
  	.byte #$0C ; tsb - set bit
  	.word #$7FE0

	jsr DrawGhost

	; CE low (read mode)
  	; WE high
  	lda #$01
  	.byte #$0C ; tsb - set bit
	.word #$7FE0
  	; CE low
  	lda #$02
  	.byte #$1C ; trb - clear bit
	.word #$7FE0


MainLoop
    jmp MainLoop


;;;;
; Set up a blank VGA display.
;;;;


SetupVGA
	; Visible lines and vertical front porch.

	; 489 * visible line.
	ldy #$FF
SetupVGA1
	jsr DrawVisibleLine
	dey
	bne SetupVGA1

	ldy #$EA
SetupVGA2
	jsr DrawVisibleLine
	dey
	bne SetupVGA2

	; Vertical sync.
	jsr VSync

	; vertical back porch
	ldy #$21
SetupVGA3
	jsr DrawVisibleLine
	dey
	bne SetupVGA3

	; Finish last row.
	lda #$18		; 24
	sta data

	ldy #$10
SetupVGA4
	jsr WriteData
  jsr IncAddress
	dey
	bne SetupVGA4
	
	rts


DrawVisibleLine
	.byte #$DA ; phx - mnemonic unknown to DASM.
	.byte #$5A ; phy

	; 328 * 24;  48 * 16;  24 * 24
	
	lda #$18		; 24
	sta data

	ldx #$FF
Visible1
	jsr WriteData
  jsr IncAddress
	dex
	bne Visible1

	ldx #$49
Visible2
	jsr WriteData
  jsr IncAddress
	dex
	bne Visible2

	lda #$10		; 16
	sta data

	ldx #$30
Visible3
	jsr WriteData
  jsr IncAddress
	dex
	bne Visible3

	lda #$18		; 24
	sta data

	ldx #$18
Visible4
	jsr WriteData
  jsr IncAddress
	dex
	bne Visible4
 
	.byte #$7A ; ply
	.byte #$FA ; plx

	rts


VSync
	.byte #$DA ; phx - mnemonic unknown to DASM.
	.byte #$5A ; phy

	; 320 * 24;  8 * 8;  48 * 0;  24 * 8
	
	lda #$18		; 24
	sta data

	ldx #$FF
VSync1
	jsr WriteData
  jsr IncAddress
	dex
	bne VSync1

	ldx #$41
VSync2
	jsr WriteData
  jsr IncAddress
	dex
	bne VSync2

	lda #$08		; 8
	sta data

	ldx #$08
VSync3
	jsr WriteData
  jsr IncAddress
	dex
	bne VSync3

	lda #$00		; 0
	sta data

	ldx #$30
VSync4
	jsr WriteData
  jsr IncAddress
	dex
	bne VSync4

	lda #$08		; 8
	sta data

	ldx #$18
VSync5
	jsr WriteData
  jsr IncAddress
	dex
	bne VSync5


	; 320 * 8;  8 * 8;  48 * 0;  24 * 8
	
	lda #$08		; 8
	sta data

	ldx #$FF
VSync6
	jsr WriteData
  jsr IncAddress
	dex
	bne VSync6

	ldx #$41
VSync7
	jsr WriteData
  jsr IncAddress
	dex
	bne VSync7

	lda #$08		; 8
	sta data

	ldx #$08
VSync8
	jsr WriteData
  jsr IncAddress
	dex
	bne VSync8

	lda #$00		; 0
	sta data

	ldx #$30
VSync9
	jsr WriteData
  jsr IncAddress
	dex
	bne VSync9

	lda #$08		; 8
	sta data

	ldx #$18
VSync10
	jsr WriteData
  jsr IncAddress
	dex
	bne VSync10


	; 320 * 8;  8 * 24;  48 * 16;  24 * 24
	
	lda #$08		; 8
	sta data

	ldx #$FF
VSync11
	jsr WriteData
  jsr IncAddress
	dex
	bne VSync11

	ldx #$41
VSync12
	jsr WriteData
  jsr IncAddress
	dex
	bne VSync12

	lda #$18		; 24
	sta data

	ldx #$08
VSync13
	jsr WriteData
  jsr IncAddress
	dex
	bne VSync13

	lda #$10		; 16
	sta data

	ldx #$30
VSync14
	jsr WriteData
  jsr IncAddress
	dex
	bne VSync14

	lda #$18		; 24
	sta data

	ldx #$18
VSync15
	jsr WriteData
  jsr IncAddress
	dex
	bne VSync15

	.byte #$7A ; ply
	.byte #$FA ; plx

	rts


;;;;
; Pixel drawing routines.
;;;;


IncAddress
	; Increment address counter.
	inc addrLow
	bne IncAddress1
	inc addrMid
	bne IncAddress1
	inc addrHigh
IncAddress1

  rts


Add365
	; Add 365 to address.
	clc
	lda addrLow
	adc #$6D
	sta addrLow
	
	lda addrMid
	adc #$01
	sta addrMid

	lda addrHigh
	adc #$00
	sta addrHigh

	rts


Add355
	; Add 355 to address.
	clc
	lda addrLow
	adc #$63
	sta addrLow
	
	lda addrMid
	adc #$01
	sta addrMid

	lda addrHigh
	adc #$00
	sta addrHigh

	rts


Add345
	; Add 345 to address.
	clc
	lda addrLow
	adc #$59
	sta addrLow
	
	lda addrMid
	adc #$01
	sta addrMid

	lda addrHigh
	adc #$00
	sta addrHigh

	rts


Add325
	; Add 325 to address.
	clc
	lda addrLow
	adc #$45
	sta addrLow
	
	lda addrMid
	adc #$01
	sta addrMid

	lda addrHigh
	adc #$00
	sta addrHigh

	rts


Add320
	; Add 320 to address.
	clc
	lda addrLow
	adc #$40
	sta addrLow
	
	lda addrMid
	adc #$01
	sta addrMid

	lda addrHigh
	adc #$00
	sta addrHigh

	rts


Add300
	; Add 300 to address.
	clc
	lda addrLow
	adc #$2C
	sta addrLow
	
	lda addrMid
	adc #$01
	sta addrMid

	lda addrHigh
	adc #$00
	sta addrHigh

	rts


Add313
	; Add 313 to address.
	clc
	lda addrLow
	adc #$39
	sta addrLow
	
	lda addrMid
	adc #$01
	sta addrMid

	lda addrHigh
	adc #$00
	sta addrHigh

	rts


Add363
	; Add 363 to address.
	clc
	lda addrLow
	adc #$6B
	sta addrLow
	
	lda addrMid
	adc #$01
	sta addrMid

	lda addrHigh
	adc #$00
	sta addrHigh

	rts


WriteData
	; Set up the address and data output registers.
	lda addrLow
	sta $7FF1

	lda addrMid
	sta $7FF0

  	; Fit data into bits 2-6 of register shared with
  	; high address bits (in bits 0-1).
	lda data
	rol
	rol
	clc
	adc addrHigh
	sta $7FE1

	; Latch data into Vectron VGA Plus memory.
	
  	; WE low
  	lda #$01
  	.byte #$1C ; trb - clear bit
	.word #$7FE0

  	; CE low
  	lda #$02
  	.byte #$1C ; trb - clear bit
	.word #$7FE0

  	; CE high
  	lda #$02
  	.byte #$0C ; tsb - set bit
	.word #$7FE0
	
  	; WE high
  	lda #$01
  	.byte #$0C ; tsb - set bit
	.word #$7FE0

	rts


WriteDataDummy
	; Set up the address and data output registers.
	lda addrLow
	sta $7FF1

	lda addrMid
	sta $7FF0

	lda addrHigh
	sta $7FE1

  	; Fit data into bits 2-6 of register shared with
  	; high address bits (in bits 0-1).
	lda data
	rol
	rol
	clc
	adc addrHigh
	sta $7FE1

	rts


DrawGhost
	lda ghostColor
	sta data

	; 1st rows

	jsr WriteDataDummy

	ldy #$10
DrawGhost2
	ldx #$23
DrawGhost1
	jsr IncAddress
	jsr WriteData
	dex
	bne DrawGhost1
	jsr Add365
	dey
	bne DrawGhost2

	; 2nd rows

	; Subtract 10.
	sec
	lda addrLow
	sbc #$0A
	sta addrLow
	lda addrMid
	sbc #$00
	sta addrMid
	lda addrHigh
	sbc #$00
	sta addrHigh

	jsr WriteDataDummy

	ldy #$12
DrawGhost4
	ldx #$37
DrawGhost3
	jsr IncAddress
	jsr WriteData
	dex
	bne DrawGhost3
	jsr Add345
	dey
	bne DrawGhost4

	; 3rd rows
	
	; Subtract 10.
	sec
	lda addrLow
	sbc #$0A
	sta addrLow
	lda addrMid
	sbc #$00
	sta addrMid
	lda addrHigh
	sbc #$00
	sta addrHigh

	jsr WriteDataDummy

	ldy #$3C
DrawGhost6
	ldx #$4B
DrawGhost5
	jsr IncAddress
	jsr WriteData
	dex
	bne DrawGhost5
	jsr Add325
	dey
	bne DrawGhost6

	; 4th rows
	
	; Subtract 5.
	sec
	lda addrLow
	sbc #$05
	sta addrLow
	lda addrMid
	sbc #$00
	sta addrMid
	lda addrHigh
	sbc #$00
	sta addrHigh

	jsr WriteDataDummy

	ldy #$64
DrawGhost8
	ldx #$57
DrawGhost7
	jsr IncAddress
	jsr WriteData
	dex
	bne DrawGhost7
	jsr Add313
	dey
	bne DrawGhost8

	; Bottom

	lda #$18	; black
	sta data

	; Subtract 7987.
	sec
	lda addrLow
	sbc #$33
	sta addrLow
	lda addrMid
	sbc #$1F
	sta addrMid
	lda addrHigh
	sbc #$00
	sta addrHigh

	jsr WriteDataDummy

	; Top half

	ldy #$0A
DrawGhost14

	ldx #$08
DrawGhost9
	jsr IncAddress
	jsr WriteData
	dex
	bne DrawGhost9

	ldx #$10
DrawGhost10
	jsr IncAddress
	dex
	bne DrawGhost10

	ldx #$0F
DrawGhost11
	jsr IncAddress
	jsr WriteData
	dex
	bne DrawGhost11

	ldx #$10
DrawGhost12
	jsr IncAddress
	dex
	bne DrawGhost12

	ldx #$08
DrawGhost13
	jsr IncAddress
	jsr WriteData
	dex
	bne DrawGhost13

	jsr Add325
	jsr IncAddress
	jsr IncAddress
	jsr IncAddress
	jsr IncAddress
	jsr IncAddress
	jsr IncAddress
	jsr IncAddress
	jsr IncAddress
	jsr IncAddress
	jsr IncAddress
	jsr IncAddress
	jsr IncAddress

	dey
	bne DrawGhost14

	; Bottom half

	; Subtract 3.
	sec
	lda addrLow
	sbc #$03
	sta addrLow
	lda addrMid
	sbc #$00
	sta addrMid
	lda addrHigh
	sbc #$00
	sta addrHigh

	jsr WriteDataDummy

	ldy #$0A
DrawGhost20

	ldx #$0F
DrawGhost15
	jsr IncAddress
	jsr WriteData
	dex
	bne DrawGhost15

	ldx #$0C
DrawGhost16
	jsr IncAddress
	dex
	bne DrawGhost16

	ldx #$0F
DrawGhost17
	jsr IncAddress
	jsr WriteData
	dex
	bne DrawGhost17

	ldx #$0C
DrawGhost18
	jsr IncAddress
	dex
	bne DrawGhost18

	ldx #$0F
DrawGhost19
	jsr IncAddress
	jsr WriteData
	dex
	bne DrawGhost19

	jsr Add320
	jsr IncAddress
	jsr IncAddress
	jsr IncAddress
	jsr IncAddress
	jsr IncAddress
	jsr IncAddress
	jsr IncAddress
	jsr IncAddress
	jsr IncAddress
	jsr IncAddress
	jsr IncAddress
	
	dey
	bne DrawGhost20

	; Eyes

	lda #$1F
	sta data

	lda eyeLow
	sta addrLow
	lda eyeMid
	sta addrMid
	lda eyeHigh
	sta addrHigh

	jsr WriteDataDummy

	; top

	ldy #$0A
DrawGhost24

	ldx #$0C
DrawGhost21
	jsr IncAddress
	jsr WriteData
	dex
	bne DrawGhost21

	ldx #$0D
DrawGhost22
	jsr IncAddress
	dex
	bne DrawGhost22

	ldx #$0C
DrawGhost23
	jsr IncAddress
	jsr WriteData
	dex
	bne DrawGhost23

	jsr Add363
	dey
	bne DrawGhost24

	; middle

	; Subtract 4.
	sec
	lda addrLow
	sbc #$04
	sta addrLow
	lda addrMid
	sbc #$00
	sta addrMid
	lda addrHigh
	sbc #$00
	sta addrHigh

	jsr WriteDataDummy

	; no pupil

	ldy #$05
DrawGhost28

	ldx #$13
DrawGhost25
	jsr IncAddress
	jsr WriteData
	dex
	bne DrawGhost25

	ldx #$06
DrawGhost26
	jsr IncAddress
	dex
	bne DrawGhost26

	ldx #$13
DrawGhost27
	jsr IncAddress
	jsr WriteData
	dex
	bne DrawGhost27

	jsr Add355
	jsr IncAddress
	dey
	bne DrawGhost28

	; pupil

	ldy #$1A
DrawGhost28p

	ldx #$07
DrawGhost25p
	jsr IncAddress
	jsr WriteData
	dex
	bne DrawGhost25p

	lda #$1C
	sta data
	ldx #$0C
DrawGhost25p1
	jsr IncAddress
	jsr WriteData
	dex
	bne DrawGhost25p1
	lda #$1F
	sta data

	ldx #$06
DrawGhost26p
	jsr IncAddress
	dex
	bne DrawGhost26p

	ldx #$07
DrawGhost27p
	jsr IncAddress
	jsr WriteData
	dex
	bne DrawGhost27p

	lda #$1C
	sta data
	ldx #$0C
DrawGhost27p1
	jsr IncAddress
	jsr WriteData
	dex
	bne DrawGhost27p1
	lda #$1F
	sta data

	jsr Add355
	jsr IncAddress
	dey
	bne DrawGhost28p

	; Bottom
	jsr IncAddress
	jsr IncAddress
	jsr IncAddress
	jsr IncAddress

	jsr WriteDataDummy

	ldy #$0A
DrawGhost32

	ldx #$0C
DrawGhost29
	jsr IncAddress
	jsr WriteData
	dex
	bne DrawGhost29

	ldx #$0D
DrawGhost30
	jsr IncAddress
	dex
	bne DrawGhost30

	ldx #$0C
DrawGhost31
	jsr IncAddress
	jsr WriteData
	dex
	bne DrawGhost31

	jsr Add363
	dey
	bne DrawGhost32

	rts
