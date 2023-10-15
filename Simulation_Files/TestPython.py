
from pydub import AudioSegment

# Load the stereo .wav file
stereo_audio = AudioSegment.from_wav('input_stereo.wav')

# Split stereo into two mono channels
left_channel = stereo_audio.split_to_mono()[0]
right_channel = stereo_audio.split_to_mono()[1]

# Export the mono channels as separate .wav files
left_channel.export('left_mono.wav', format='wav')
right_channel.export('right_mono.wav', format='wav')