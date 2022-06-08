;;;;
; Vectron 65 Plus Pong
;
; Nick Bild
; nick.bild@gmail.com
; May 2022
;
; Reserved memory:
;
; $0000-$7EFF - RAM
; 		$0000-$0004 - Named variables
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
leftPaddleY
		.byte #$00

StartExe	ORG $8000


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


	jsr DrawLeftPaddle


MainLoop:
    jmp MainLoop


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


IncAddress
	; Increment address counter.
	inc addrLow
	bne IncAddress1
	inc addrMid
	bne IncAddress1
	inc addrHigh
IncAddress1

  rts


WriteData
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
  

NextAddressRow
	; Add 400 to address.
	clc
	lda addrLow
	adc #$90
	sta addrLow
	
	lda addrMid
	adc #$01
	sta addrMid

	lda addrHigh
	adc #$00
	sta addrHigh

	rts


DrawLeftPaddle
	lda #$19 ; blue
	sta data

	lda #$0A
	sta addrLow
	lda #$00
	sta addrMid
	sta addrHigh

	; CE/WE high
  	lda #$03
  	.byte #$0C ; tsb - set bit
  	.word #$7FE0

	jsr WriteData
	
	jsr NextAddressRow
	jsr WriteData

	jsr NextAddressRow
	jsr WriteData

	jsr NextAddressRow
	jsr WriteData

	jsr NextAddressRow
	jsr WriteData

	jsr NextAddressRow
	jsr WriteData

	jsr NextAddressRow
	jsr WriteData

	jsr NextAddressRow
	jsr WriteData

	jsr NextAddressRow
	jsr WriteData

	jsr NextAddressRow
	jsr WriteData

	; CE low (read mode)
  	; WE high
  	lda #$01
  	.byte #$0C ; tsb - set bit
	.word #$7FE0
  	; CE low
  	lda #$02
  	.byte #$1C ; trb - clear bit
	.word #$7FE0

	rts
