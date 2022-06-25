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

Here, the Vectron 65 Plus (left) is running TinyBASIC.  On the right, [Vectron VGA Plus Text Mode](https://github.com/nickbild/vectron_vga_plus_text_mode) is stacked on top of [Vectron VGA Plus v2](https://github.com/nickbild/vectron_vga_plus_v2) to provide a text mode VGA display output:

![](https://raw.githubusercontent.com/nickbild/vectron_65_plus/main/media/running_basic_sm.jpg)

In this example, the Vectron 65 Plus (right) is hooked up to [Vectron VGA Plus v2](https://github.com/nickbild/vectron_vga_plus_v2) to output some bitmap graphics:

![](https://raw.githubusercontent.com/nickbild/vectron_65_plus/main/media/v65_displaying_ghosts_sm.jpg)

![](https://raw.githubusercontent.com/nickbild/vectron_65_plus/main/media/ghosts_sm.jpg)

## Bill of Materials

## About the Author

[Nick A. Bild, MS](https://nickbild79.firebaseapp.com/#!/)
