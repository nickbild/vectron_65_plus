from pydub import AudioSegment

# Original wav is 2075 ms.
for t1 in range(0, 2070, 10):
    t2 = t1 + 10

    newAudio = AudioSegment.from_wav("greetings_mono.wav")
    newAudio = newAudio[t1:t2]
    newAudio.export("target_audio_split/greetings_{0}-{1}.wav".format(t1, t2), format="wav")
