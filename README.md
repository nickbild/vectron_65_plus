# Vectron 65 Plus

The Vectron 65 Plus is a 6502 CPU-based computer with keyboard support that can run BASIC.  It is highly extensible via 32 GPIO pins.

At present, I have built the following peripherals for the computer:
- [Vectron VGA Plus v2](https://github.com/nickbild/vectron_vga_plus_v2) - VGA output with pixel-level control
- [Vectron VGA Plus Text Mode](https://github.com/nickbild/vectron_vga_plus_text_mode) - Add-on for Vectron VGA Plus v2 that simplifies displaying text on screen
- [Vectron Sound Plus](https://github.com/nickbild/vectron_sound_plus) - Audio output with the AY-3-8910 sound generator chip

![](https://raw.githubusercontent.com/nickbild/vectron_65_plus/main/media/vectron_65_top_angle_sm.jpg)

This is an enhanced version of my [Vectron 65](https://github.com/nickbild/vectron_65) computer.

## How It Works

At the heart of the system is a WDC 65C02 CPU running at 8 MHz.  32 KB of SRAM is available, and a 32 KB ROM chip stores the program to execute.  A pair of 6522 VIA chips add a total of 32 GPIO pins to interface with external peripherals.  A PS/2 connector is present to support a keyboard (or a mouse, in theory, though I haven't tried one yet) — the clock and data lines are routed to GPIO pins.

This is the circuit design:

![](https://raw.githubusercontent.com/nickbild/vectron_65_plus/main/media/schematic.svg)

## Media

Here, the Vectron 65 Plus (left) is running TinyBASIC.  On the right, [Vectron VGA Plus Text Mode](https://github.com/nickbild/vectron_vga_plus_text_mode) is stacked on top of [Vectron VGA Plus v2](https://github.com/nickbild/vectron_vga_plus_v2) to provide a text mode VGA display output ([6502 code here](https://github.com/nickbild/vectron_65_plus/blob/main/os_vvga.asm)):

![](https://raw.githubusercontent.com/nickbild/vectron_65_plus/main/media/running_basic_sm.jpg)

In this example, the Vectron 65 Plus (right) is hooked up to [Vectron VGA Plus v2](https://github.com/nickbild/vectron_vga_plus_v2) to output some bitmap graphics ([6502 code here](https://github.com/nickbild/vectron_65_plus/blob/main/pacman.asm)):

![](https://raw.githubusercontent.com/nickbild/vectron_65_plus/main/media/v65_displaying_ghosts_sm.jpg)

![](https://raw.githubusercontent.com/nickbild/vectron_65_plus/main/media/ghosts_sm.jpg)

![](https://raw.githubusercontent.com/nickbild/vectron_65_plus/main/media/v65_and_vga_sm.jpg)

And for audio, I added in the [Vectron Sound Plus](https://github.com/nickbild/vectron_sound_plus) module:

![](https://github.com/nickbild/vectron_sound_plus/blob/main/media/v65_w_audio_angle_sm.jpg)

You can download an [MP3 here](https://github.com/nickbild/vectron_sound_plus/blob/main/media/vectron_65_audio.mp3?raw=true) of a tune I made with it.

And a few more pictures:

![](https://github.com/nickbild/vectron_65_plus/blob/main/media/vectron_65_close_connected_sm.jpg)

![](https://github.com/nickbild/vectron_65_plus/blob/main/media/vectron_65_top_sm.jpg)

![](https://github.com/nickbild/vectron_65_plus/blob/main/media/vectron_65_w_text_mode_sm.jpg)

## Bill of Materials

- 1 x 65C02 CPU
- 2 x 6522 VIA
- 1 x 28C256 ROM
- 1 x AS6C62256A RAM
- 4 x 74682
- 1 x 7404
- 1 x 7408
- 1 x 7432
- 1 x 8 MHz crystal oscillator
- 1 x push button
- 4 x 3.3K resistors
- 2 x 5.1K resistors
- 2 x 10K resistors
- 3 x 47 uF electrolytic capacitors
- 14 x 0.1 uF ceramic capacitors
- 1 x PS/2 connector
- 1 x PCB ([Kicad design file here](https://github.com/nickbild/vectron_65_plus/tree/main/kicad_vectron_65_plus))

## About the Author

[Nick A. Bild, MS](https://nickbild79.firebaseapp.com/#!/)
