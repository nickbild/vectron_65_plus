import imageio
import numpy as np
import glob


def mse(imageA, imageB):
	err = np.sum((imageA.astype("float") - imageB.astype("float")) ** 2)
	err /= float(imageA.shape[0] * imageA.shape[1])

	return err


def main():
    target_spectrograms = sorted(glob.glob("target_spectrograms/*.jpg"))
    library_spectrograms = sorted(glob.glob("library_spectrograms/*.jpg"))

    for target_spectrogram in target_spectrograms:
        im1 = imageio.imread(target_spectrogram)
        min_mse = 9999999999
        match = ""

        for library_spectrogram in library_spectrograms:
            im2 = imageio.imread(library_spectrogram)
            err = mse(im1, im2)

            if err < min_mse:
                min_mse = err
                match = library_spectrogram

        print("{0}: {1} - {2}".format(target_spectrogram, match, min_mse))


    return


if __name__ == "__main__":
    main()
