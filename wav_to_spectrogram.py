####
# Nick Bild (nick.bild@gmail.com)
# December 2020
# Convert a directory full of WAV files into spectrogram JPEGs.
####

import matplotlib.pyplot as plt
from scipy.io import wavfile
import numpy as np
import glob
import sys


# Set input/output directories.
audio_dir = sys.argv[1] # "target_audio_split"
spectrogram_dir = sys.argv[2] # "target_spectrograms"


def graph_spectrogram(wav_file):
    rate, data = wavfile.read("{1}/{0}".format(wav_file, audio_dir))
    plt.figure(figsize=(1, 1))
    pxx, freqs, bins, im = plt.specgram(x=data, Fs=rate, noverlap=128, NFFT=256)
    plt.axis('off')
    plt.savefig("{1}/{0}.jpg".format(wav_file, spectrogram_dir), bbox_inches='tight', dpi=100, pad_inches=0)
    plt.close()

    return


def main():
    files = glob.glob("{0}/*.wav".format(audio_dir))

    for file in files:
        file = file.split("/")[-1]
        graph_spectrogram(file)

    return


if __name__ == '__main__':
    main()
