import RPi.GPIO as GPIO
import time
import random
import pyaudio
import wave


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

# Wav recording parameters.
format_1 = pyaudio.paInt16
channels = 1
samp_rate = 44100
chunk = 4096
record_secs = 0.01
dev_index = 2


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


def play_all_sounds():
    # 5,916,800 distinct sounds generated.
    for volume in (3, 6):
        set_address(8)  # Channel A
        set_data(volume)
        set_address(9)  # Channel B
        set_data(volume)

        for noise in (0, 4, 8, 32):
            if noise == 32:
                set_address(7) # Mixer.
                set_data(120)  # Tone only.
            else:
                set_address(7) # Mixer.
                set_data(64)  # Tone and noise.
                set_address(6) # Noise.
                set_data(noise)

            for coarse in range(11):
                set_address(1) # Tone Channel A, coarse (0-15)
                set_data(coarse)

                set_address(0) # Tone Channel A, fine (0-255)
                for fine in range(0, 256, 3):
                    set_data(fine)

                    for coarse_2 in range(11):
                        set_address(3) # Tone Channel B, coarse (0-15)
                        set_data(coarse_2)

                        set_address(2) # Tone Channel B, fine (0-255)
                        for fine_2 in range(1, 256, 3):
                            print("c: {0}, f: {1}, c2: {2}, f2: {3}, n: {4}, v: {5}".format(coarse, fine, coarse_2, fine_2, noise, volume))
                            set_data(fine_2)
                            # Channel A+B final sound has been set.
                            # time.sleep(0.001)
                            # record_wav("sound_library/c-{0}_f-{1}_c2-{2}_f2-{3}_n-{4}_v-{5}.wav".format(coarse, fine, coarse_2, fine_2, noise, volume))
    return


def volume_off():
    set_address(8)  # Channel A
    set_data(0)
    set_address(9)  # Channel B
    set_data(0)
    set_address(10) # Channel C
    set_data(0)

    return


def get_mic_usb_index():
    p = pyaudio.PyAudio()
    for ii in range(p.get_device_count()):
        print(p.get_device_info_by_index(ii).get('name'))

    return


def record_wav(wav_output_filename):
    audio = pyaudio.PyAudio()

    stream = audio.open(format=format_1, rate=samp_rate, channels=channels, \
                        input_device_index = dev_index, input = True, \
                        frames_per_buffer=chunk)

    frames = []
    # Loop through stream and append audio chunks to frame array.
    for ii in range(0,int((samp_rate/chunk)*record_secs)):
        data = stream.read(chunk)
        frames.append(data)

    # Clean up.
    stream.stop_stream()
    stream.close()
    audio.terminate()

    # Save the audio frames as .wav file.
    wavefile = wave.open(wav_output_filename, 'wb')
    wavefile.setnchannels(channels)
    wavefile.setsampwidth(audio.get_sample_size(format))
    wavefile.setframerate(samp_rate)
    wavefile.writeframes(b''.join(frames))
    wavefile.close()

    return


def main():
    # Mixer: set_data(64) # 64 (tone and noise), 71 (noise only), 120 (tone only)

    # get_mic_usb_index()

    reset_toggle() # Only needed after initial power up.
    set_idle()

    play_all_sounds()
    volume_off()

    return


if __name__ == "__main__":
    main()
