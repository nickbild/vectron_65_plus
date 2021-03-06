import RPi.GPIO as GPIO
import time
import random
import sounddevice as sd
from scipy.io.wavfile import write
import os


# Data bus.
d0 = 8
d1 = 10
d2 = 12
d3 = 16
d4 = 18
d5 = 22
d6 = 24
d7 = 26

# Control signals.
bc1 = 36
bdir = 38
reset = 40


GPIO.setwarnings(False)
GPIO.setmode(GPIO.BOARD)

GPIO.setup(d0, GPIO.OUT)
GPIO.setup(d1, GPIO.OUT)
GPIO.setup(d2, GPIO.OUT)
GPIO.setup(d3, GPIO.OUT)
GPIO.setup(d4, GPIO.OUT)
GPIO.setup(d5, GPIO.OUT)
GPIO.setup(d6, GPIO.OUT)
GPIO.setup(d7, GPIO.OUT)
GPIO.setup(bc1, GPIO.OUT)
GPIO.setup(bdir, GPIO.OUT)
GPIO.setup(reset, GPIO.OUT)


def reset_toggle():
    GPIO.output(reset, GPIO.HIGH)
    time.sleep(0.25)
    GPIO.output(reset, GPIO.LOW)
    time.sleep(0.25)
    GPIO.output(reset, GPIO.HIGH)

    return


def set_idle():
    chan_list = (bc1, bdir)
    GPIO.output(chan_list, GPIO.LOW)

    return


def set_address(addr):
    set_idle()

    b_str = format(addr, '08b')
    GPIO.output(d0, int(b_str[7]))
    GPIO.output(d1, int(b_str[6]))
    GPIO.output(d2, int(b_str[5]))
    GPIO.output(d3, int(b_str[4]))
    GPIO.output(d4, int(b_str[3]))
    GPIO.output(d5, int(b_str[2]))
    GPIO.output(d6, int(b_str[1]))
    GPIO.output(d7, int(b_str[0]))

    chan_list = (bc1, bdir)
    GPIO.output(chan_list, GPIO.HIGH)

    set_idle()

    return


def set_data(data):
    set_idle()

    b_str = format(data, '08b')
    GPIO.output(d0, int(b_str[7]))
    GPIO.output(d1, int(b_str[6]))
    GPIO.output(d2, int(b_str[5]))
    GPIO.output(d3, int(b_str[4]))
    GPIO.output(d4, int(b_str[3]))
    GPIO.output(d5, int(b_str[2]))
    GPIO.output(d6, int(b_str[1]))
    GPIO.output(d7, int(b_str[0]))

    GPIO.output(bdir, GPIO.HIGH)

    set_idle()

    return


def volume_off():
    set_address(8)  # Channel A
    set_data(0)
    set_address(9)  # Channel B
    set_data(0)
    set_address(10) # Channel C
    set_data(0)

    return


def main():
    # Mixer: set_data(64) # 64 (tone and noise), 71 (noise only), 120 (tone only)

    reset_toggle() # Only needed after initial power up.
    set_idle()

    set_address(7) # Mixer.
    set_data(120)  # Tone only.

    set_address(8)  # Channel A volume.
    set_data(5)

    set_address(0)  # Tone A.
    set_data(100)

    time.sleep(1)

    volume_off()

    return


if __name__ == "__main__":
    main()
