import RPi.GPIO as GPIO
import time


clk = 8
do = 10
di = 12
cs = 16

GPIO.setmode(GPIO.BOARD)

GPIO.setup(clk, GPIO.OUT)
GPIO.setup(do, GPIO.OUT)
GPIO.setup(di, GPIO.OUT)
GPIO.setup(cs, GPIO.OUT)

GPIO.output(clk, GPIO.HIGH)
GPIO.output(cs, GPIO.HIGH)


def send_byte(b):
    b_str = format(b, '08b')
    for i in range(0, 8):
        GPIO.output(di, int(b_str[i]))
        GPIO.output(clk, GPIO.LOW)
        GPIO.output(clk, GPIO.HIGH)
    return


def read_byte():
    byte = ""
    for i in range(0, 8):
        GPIO.output(clk, GPIO.LOW)
        GPIO.output(clk, GPIO.HIGH)
        b = GPIO.input(do)
        print(b)
        byte += str(b)
    print()

    return byte


def read_mem(addr):
    GPIO.output(cs, GPIO.LOW)

    print("Send CMD17.")
    GPIO.setup(do, GPIO.OUT)
    GPIO.output(do, GPIO.HIGH)

    send_byte(255)
    send_byte(81)
    send_byte(0)
    send_byte(0)
    send_byte(0)
    send_byte(addr)
    send_byte(255)
    send_byte(255)

    # Read response.
    GPIO.output(di, GPIO.HIGH)
    GPIO.setup(do, GPIO.IN, GPIO.PUD_DOWN)

    while (read_byte() != "11111110"):
        time.sleep(0.05)

    print("Block from memory:")
    for i in range(512):
        read_byte()
        time.sleep(0.005)

    GPIO.output(cs, GPIO.HIGH)

    return


def write_mem(addr, value):
    GPIO.output(cs, GPIO.LOW)

    print("Send CMD24.")
    GPIO.setup(do, GPIO.OUT)
    GPIO.output(do, GPIO.HIGH)

    send_byte(255)
    send_byte(88)
    send_byte(0)
    send_byte(0)
    send_byte(0)
    send_byte(addr)
    send_byte(141)
    send_byte(255)

    # Read response.
    GPIO.output(di, GPIO.HIGH)
    GPIO.setup(do, GPIO.IN, GPIO.PUD_DOWN)

    while (read_byte() != "00000000"):
        time.sleep(0.5)

	# Send block of data.
    GPIO.setup(do, GPIO.OUT)
    GPIO.output(do, GPIO.HIGH)
    send_byte(255)
    send_byte(254) # Start token.
    for i in range(512):
        send_byte(value)
        time.sleep(0.005)

	# Read response.
    GPIO.output(di, GPIO.HIGH)
    GPIO.setup(do, GPIO.IN, GPIO.PUD_DOWN)

    print("Write response:")
    read_byte()

    print("Send CMD13.")
    GPIO.setup(do, GPIO.OUT)
    GPIO.output(do, GPIO.HIGH)

    send_byte(255)
    send_byte(77)
    send_byte(0)
    send_byte(0)
    send_byte(0)
    send_byte(0)
    send_byte(255)
    send_byte(255)

    # Read response.
    GPIO.output(di, GPIO.HIGH)
    GPIO.setup(do, GPIO.IN, GPIO.PUD_DOWN)

    print("Response:")
    read_byte()

    GPIO.output(cs, GPIO.HIGH)

    return


def init_sd():
    GPIO.output(cs, GPIO.LOW)

    print("Send CMD0.")
    GPIO.setup(do, GPIO.OUT)
    GPIO.output(do, GPIO.HIGH)

    send_byte(255)
    send_byte(64)
    send_byte(0)
    send_byte(0)
    send_byte(0)
    send_byte(0)
    send_byte(149)
    send_byte(255)

    # Read response.
    GPIO.output(di, GPIO.HIGH)
    GPIO.setup(do, GPIO.IN, GPIO.PUD_DOWN)
    read_byte()

    print("Send CMD8.")
    GPIO.setup(do, GPIO.OUT)
    GPIO.output(do, GPIO.HIGH)

    send_byte(255)
    send_byte(72)
    send_byte(0)
    send_byte(0)
    send_byte(1)
    send_byte(170)
    send_byte(135)
    send_byte(255)

    # Read response.
    GPIO.output(di, GPIO.HIGH)
    GPIO.setup(do, GPIO.IN, GPIO.PUD_DOWN)
    read_byte()
    read_byte()
    read_byte()
    read_byte()
    read_byte()

    for i in range(2):
        print("Send CMD55.")
        GPIO.setup(do, GPIO.OUT)

        send_byte(255)
        send_byte(119)
        send_byte(0)
        send_byte(0)
        send_byte(0)
        send_byte(0)
        send_byte(101)
        send_byte(255)

        # Read response.
        GPIO.output(di, GPIO.HIGH)
        GPIO.setup(do, GPIO.IN, GPIO.PUD_DOWN)
        read_byte()

        print("Send ACMD41.")
        GPIO.setup(do, GPIO.OUT)
        GPIO.output(do, GPIO.HIGH)

        send_byte(255)
        send_byte(105)
        send_byte(64)
        send_byte(0)
        send_byte(0)
        send_byte(0)
        send_byte(119)
        send_byte(255)

        # Read response.
        GPIO.output(di, GPIO.HIGH)
        GPIO.setup(do, GPIO.IN, GPIO.PUD_DOWN)
        read_byte()

    print("Set block size (CMD16).")
    GPIO.setup(do, GPIO.OUT)
    GPIO.output(do, GPIO.HIGH)

    send_byte(255)
    send_byte(80)
    # 512 bytes.
    send_byte(0)
    send_byte(0)
    send_byte(2)
    send_byte(0)
    send_byte(255)
    send_byte(255)

    # Read response.
    GPIO.output(di, GPIO.HIGH)
    GPIO.setup(do, GPIO.IN, GPIO.PUD_DOWN)
    read_byte()

    print("Turn off CRC (CMD59).")
    GPIO.setup(do, GPIO.OUT)
    GPIO.output(do, GPIO.HIGH)

    send_byte(255)
    send_byte(123)
    send_byte(0)
    send_byte(0)
    send_byte(0)
    send_byte(0)
    send_byte(255)
    send_byte(255)

    # Read response.
    GPIO.output(di, GPIO.HIGH)
    GPIO.setup(do, GPIO.IN, GPIO.PUD_DOWN)
    read_byte()

    GPIO.output(cs, GPIO.HIGH)


if __name__ == "__main__":
    init_sd()
    read_mem(0)
    write_mem(0, 15)
    read_mem(0)
