import RPi.GPIO as GPIO
import time


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
    # b_str = "11111111"
    GPIO.output(d0, int(b_str[7]))
    GPIO.output(d1, int(b_str[6]))
    GPIO.output(d2, int(b_str[5]))
    GPIO.output(d3, int(b_str[4]))
    GPIO.output(d4, int(b_str[3]))
    GPIO.output(d5, int(b_str[2]))
    GPIO.output(d6, int(b_str[1]))
    GPIO.output(d7, int(b_str[0]))

    GPIO.output(bdir, GPIO.HIGH)

    # time.sleep(0.05)
    set_idle()

    return


def main():
    set_idle()

    # Mixer.
    set_address(7)
    set_data(56) # 0 (tone and noise), 56 (tone only)

    # Amplitude (volume).
    set_address(8)
    set_data(7)
    set_address(9)
    set_data(7)
    set_address(10)
    set_data(7)

    # Noise.
    set_address(6)
    set_data(0)

    for i in range(256):
        set_address(0)
        set_data(i)
        set_address(2)
        set_data(i)
        set_address(4)
        set_data(i)
        time.sleep(0.05)

    # Fine tone.
    set_address(0)
    set_data(168)
    set_address(2)
    set_data(168)
    set_address(4)
    set_data(168)

    # Coarse tone.
    set_address(1)
    set_data(0)
    set_address(3)
    set_data(0)
    set_address(5)
    set_data(0)



    # set_address(8)
    # set_data(0)
    # set_address(9)
    # set_data(0)
    # set_address(10)
    # set_data(0)

    set_idle()

    return


if __name__ == "__main__":
    main()
