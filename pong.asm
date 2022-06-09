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
; 		$0000-$000C - Named variables
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
addrLowTemp
		.byte #$00
addrMidTemp
		.byte #$00
addrHighTemp
		.byte #$00
addrLowP1
		.byte #$00
addrMidP1
		.byte #$00
addrHighP1
		.byte #$00
addrLowP2
		.byte #$00
addrMidP2
		.byte #$00
addrHighP2
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


	; Draw paddles in initial positions.

	lda #$A5
	sta addrLowP1
	lda #$0F
	sta addrMidP1
	lda #$00
	sta addrHighP1

	lda #$D1
	sta addrLowP2
	lda #$10
	sta addrMidP2
	lda #$00
	sta addrHighP2

	; Paddle 1 (Left).
	lda #$1C ; blue
	sta data

	lda addrLowP1
	sta addrLow
	lda addrMidP1
	sta addrMid
	lda addrHighP1
	sta addrHigh

	jsr DrawPaddle

	; Paddle 2 (Right).
	lda #$1C ; blue
	sta data

	lda addrLowP2
	sta addrLow
	lda addrMidP2
	sta addrMid
	lda addrHighP2
	sta addrHigh

	jsr DrawPaddle

	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down
	; jsr MovePaddle2Down

	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down
	; jsr MovePaddle1Down

	jsr MovePaddle2Up


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
  

NextPaddleAddressRow
	; Add 395 to address.
	clc
	lda addrLow
	adc #$8B
	sta addrLow
	
	lda addrMid
	adc #$01
	sta addrMid

	lda addrHigh
	adc #$00
	sta addrHigh

	rts


DrawPaddle
	.byte #$DA ; phx - mnemonic unknown to DASM.
    .byte #$5A ; phy

	; Save starting address for write to second RAM chip.
	lda addrLow
	sta addrLowTemp
	lda addrMid
	sta addrMidTemp
	lda addrHigh
	sta addrHighTemp

	; 1st RAM chip.

	; CE/WE high
  	lda #$03
  	.byte #$0C ; tsb - set bit
  	.word #$7FE0

	ldx #$28 ; Paddle height.
DrawPaddle1
	ldy #$05 ; Paddle width (x2).
DrawPaddle2
	jsr WriteData
	jsr IncAddress
	dey
	bne DrawPaddle2
	jsr NextPaddleAddressRow
	dex
	bne DrawPaddle1

	; CE low (read mode)
  	; WE high
  	lda #$01
  	.byte #$0C ; tsb - set bit
	.word #$7FE0
  	; CE low
  	lda #$02
  	.byte #$1C ; trb - clear bit
	.word #$7FE0

	; 2nd RAM chip.

	; Recover paddle starting address.
	lda addrLowTemp
	sta addrLow
	lda addrMidTemp
	sta addrMid
	lda addrHighTemp
	sta addrHigh

	; CE/WE high
  	lda #$03
  	.byte #$0C ; tsb - set bit
  	.word #$7FE0

	ldx #$28 ; Paddle height.
DrawPaddle3
	ldy #$05 ; Paddle width (x2).
DrawPaddle4
	jsr WriteData
	jsr IncAddress
	dey
	bne DrawPaddle4
	jsr NextPaddleAddressRow
	dex
	bne DrawPaddle3

	; CE low (read mode)
  	; WE high
  	lda #$01
  	.byte #$0C ; tsb - set bit
	.word #$7FE0
  	; CE low
  	lda #$02
  	.byte #$1C ; trb - clear bit
	.word #$7FE0

	.byte #$7A ; ply
    .byte #$FA ; plx

	rts


MovePaddle1Up
	lda addrLowP1
	sta addrLowTemp
	lda addrMidP1
	sta addrMidTemp
	lda addrHighP1
	sta addrHighTemp

	jsr MovePaddleUp

	; Subtract 400 from paddle starting address.
	sec
	lda addrLowP1
	sbc #$90
	sta addrLowP1
	lda addrMidP1
	sbc #$01
	sta addrMidP1
	lda addrHighP1
	sbc #$00
	sta addrHighP1

	rts


MovePaddle2Up
	lda addrLowP2
	sta addrLowTemp
	lda addrMidP2
	sta addrMidTemp
	lda addrHighP2
	sta addrHighTemp

	jsr MovePaddleUp

	; Subtract 400 from paddle starting address.
	sec
	lda addrLowP2
	sbc #$90
	sta addrLowP2
	lda addrMidP2
	sbc #$01
	sta addrMidP2
	lda addrHighP2
	sbc #$00
	sta addrHighP2

	rts


MovePaddle1Down
	lda addrLowP1
	sta addrLowTemp
	lda addrMidP1
	sta addrMidTemp
	lda addrHighP1
	sta addrHighTemp

	jsr MovePaddleDown

	; Add 400 to paddle starting address.
	clc
	lda addrLowP1
	adc #$90
	sta addrLowP1
	
	lda addrMidP1
	adc #$01
	sta addrMidP1

	lda addrHighP1
	adc #$00
	sta addrHighP1

	rts


MovePaddle2Down
	lda addrLowP2
	sta addrLowTemp
	lda addrMidP2
	sta addrMidTemp
	lda addrHighP2
	sta addrHighTemp

	jsr MovePaddleDown

	; Add 400 to paddle starting address.
	clc
	lda addrLowP2
	adc #$90
	sta addrLowP2
	
	lda addrMidP2
	adc #$01
	sta addrMidP2

	lda addrHighP2
	adc #$00
	sta addrHighP2

	rts


MovePaddleDown
	.byte #$DA ; phx - mnemonic unknown to DASM.
    .byte #$5A ; phy

	; 1st RAM chip.

	lda addrLowTemp
	sta addrLow
	lda addrMidTemp
	sta addrMid
	lda addrHighTemp
	sta addrHigh

	; CE/WE high
  	lda #$03
  	.byte #$0C ; tsb - set bit
  	.word #$7FE0

	; Erase the top line.
	lda #$18 ; black
	sta data

	ldy #$05 ; Paddle width (x2).
MovePaddleDown1
	jsr WriteData
	jsr IncAddress
	dey
	bne MovePaddleDown1

	lda addrLowTemp
	sta addrLow
	lda addrMidTemp
	sta addrMid
	lda addrHighTemp
	sta addrHigh

	ldy #$05 ; Paddle width (x2).
MovePaddleDown2
	jsr WriteData
	jsr IncAddress
	dey
	bne MovePaddleDown2

	; Draw a new line 1 row below current bottom.
	lda #$1C ; blue
	sta data

	; Add 15,994 to address.
	clc
	lda addrLow
	adc #$7B
	sta addrLow
	
	lda addrMid
	adc #$3E
	sta addrMid

	lda addrHigh
	adc #$00
	sta addrHigh
	
	ldy #$05 ; Paddle width (x2).
MovePaddleDown3
	jsr WriteData
	jsr IncAddress
	dey
	bne MovePaddleDown3

	; CE low (read mode)
  	; WE high
  	lda #$01
  	.byte #$0C ; tsb - set bit
	.word #$7FE0
  	; CE low
  	lda #$02
  	.byte #$1C ; trb - clear bit
	.word #$7FE0

	; 2nd RAM chip.

	lda addrLowTemp
	sta addrLow
	lda addrMidTemp
	sta addrMid
	lda addrHighTemp
	sta addrHigh

	; CE/WE high
  	lda #$03
  	.byte #$0C ; tsb - set bit
  	.word #$7FE0

	; Erase the top line.
	lda #$18 ; black
	sta data

	ldy #$05 ; Paddle width (x2).
MovePaddleDown4
	jsr WriteData
	jsr IncAddress
	dey
	bne MovePaddleDown4

	lda addrLowTemp
	sta addrLow
	lda addrMidTemp
	sta addrMid
	lda addrHighTemp
	sta addrHigh

	ldy #$05 ; Paddle width (x2).
MovePaddleDown5
	jsr WriteData
	jsr IncAddress
	dey
	bne MovePaddleDown5

	; Draw a new line 1 row below current bottom.
	lda #$1C ; blue
	sta data

	; Add 15,994 to address.
	clc
	lda addrLow
	adc #$7B
	sta addrLow
	
	lda addrMid
	adc #$3E
	sta addrMid

	lda addrHigh
	adc #$00
	sta addrHigh
	
	ldy #$05 ; Paddle width (x2).
MovePaddleDown6
	jsr WriteData
	jsr IncAddress
	dey
	bne MovePaddleDown6

	; CE low (read mode)
  	; WE high
  	lda #$01
  	.byte #$0C ; tsb - set bit
	.word #$7FE0
  	; CE low
  	lda #$02
  	.byte #$1C ; trb - clear bit
	.word #$7FE0

	.byte #$7A ; ply
    .byte #$FA ; plx

	rts


MovePaddleUp
	.byte #$DA ; phx - mnemonic unknown to DASM.
    .byte #$5A ; phy

	; 1st RAM chip.

	lda addrLowTemp
	sta addrLow
	lda addrMidTemp
	sta addrMid
	lda addrHighTemp
	sta addrHigh

	; CE/WE high
  	lda #$03
  	.byte #$0C ; tsb - set bit
  	.word #$7FE0

	; Add a new line 1 row higher.
	lda #$18 ; black
	sta data

	; Subtract 400.
	sec
	lda addrLow
	sbc #$21
	sta addrLow
	lda addrMid
	sbc #$03
	sta addrMid
	lda addrHigh
	sbc #$00
	sta addrHigh

	jsr WriteData
	jsr IncAddress



	lda #$1C ; blue
	sta data

	ldy #$05 ; Paddle width (x2).
MovePaddleUp1
	jsr WriteData
	jsr IncAddress
	dey
	bne MovePaddleUp1

; 	; Draw a new line 1 row below current bottom.
; 	lda #$18 ; black
; 	sta data

; 	; Add 16,394 to address.
; 	clc
; 	lda addrLow
; 	adc #$0A
; 	sta addrLow
	
; 	lda addrMid
; 	adc #$40
; 	sta addrMid

; 	lda addrHigh
; 	adc #$00
; 	sta addrHigh
	
; 	ldy #$05 ; Paddle width (x2).
; MovePaddleUp2
; 	jsr WriteData
; 	jsr IncAddress
; 	dey
; 	bne MovePaddleUp2

; 	; Subtract 5.
; 	sec
; 	lda addrLow
; 	sbc #$05
; 	sta addrLow
; 	lda addrMid
; 	sbc #$00
; 	sta addrMid
; 	lda addrHigh
; 	sbc #$00
; 	sta addrHigh

; 	ldy #$05 ; Paddle width (x2).
; MovePaddleUp3
; 	jsr WriteData
; 	jsr IncAddress
; 	dey
; 	bne MovePaddleUp3

	; CE low (read mode)
  	; WE high
  	lda #$01
  	.byte #$0C ; tsb - set bit
	.word #$7FE0
  	; CE low
  	lda #$02
  	.byte #$1C ; trb - clear bit
	.word #$7FE0

	; 2nd RAM chip.

	lda addrLowTemp
	sta addrLow
	lda addrMidTemp
	sta addrMid
	lda addrHighTemp
	sta addrHigh

	; CE/WE high
  	lda #$03
  	.byte #$0C ; tsb - set bit
  	.word #$7FE0

	; Add a new line 1 row higher.
	lda #$18 ; black
	sta data

	; Subtract 400.
	sec
	lda addrLow
	sbc #$21
	sta addrLow
	lda addrMid
	sbc #$03
	sta addrMid
	lda addrHigh
	sbc #$00
	sta addrHigh

	jsr WriteData
	jsr IncAddress

	lda #$1C ; blue
	sta data

	ldy #$05 ; Paddle width (x2).
MovePaddleUp4
	jsr WriteData
	jsr IncAddress
	dey
	bne MovePaddleUp4	

; 	; Draw a new line 1 row below current bottom.
; 	lda #$18 ; black
; 	sta data

; 	; Add 16,394 to address.
; 	clc
; 	lda addrLow
; 	adc #$0A
; 	sta addrLow
	
; 	lda addrMid
; 	adc #$40
; 	sta addrMid

; 	lda addrHigh
; 	adc #$00
; 	sta addrHigh
	
; 	ldy #$05 ; Paddle width (x2).
; MovePaddleUp5
; 	jsr WriteData
; 	jsr IncAddress
; 	dey
; 	bne MovePaddleUp5

; 	; Subtract 5.
; 	sec
; 	lda addrLow
; 	sbc #$05
; 	sta addrLow
; 	lda addrMid
; 	sbc #$00
; 	sta addrMid
; 	lda addrHigh
; 	sbc #$00
; 	sta addrHigh

; 	ldy #$05 ; Paddle width (x2).
; MovePaddleUp6
; 	jsr WriteData
; 	jsr IncAddress
; 	dey
; 	bne MovePaddleUp6
	
	; CE low (read mode)
  	; WE high
  	lda #$01
  	.byte #$0C ; tsb - set bit
	.word #$7FE0
  	; CE low
  	lda #$02
  	.byte #$1C ; trb - clear bit
	.word #$7FE0

	.byte #$7A ; ply
    .byte #$FA ; plx

	rts
