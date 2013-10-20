notePrint
===
### Overview

NotePrint is a simple frequency-analysis program written in Matlab/Octave.  NotePrint can read an input waveform file and beats per minute, and it will attempt to identify the dominant frequencies present at each beat.  Presently, the output comes in two forms: a text file listing the notes present at each beat (LOG.txt) and a new waveform file generated from the detected frequencies (TONE.wav).

### Using NotePrint

To run notePrint, simply launch the script in either Matlab or Octave.  The program will request a sound file; give the relative path to a .wav file.  Next, give the beats per minute for the sound file.  This number does not need to be exact, as notePrint tries to understand notes carried over multiple beats regardless of the actual beats per minute.

### Known Issues

- There is a lot of noise on the input; notePrint detects frequencies that will just garble the output.  Some small effort has been made to reduce this noise, but in the future, better filtering of the input signal may need to be added.

- At present, notePrint does not reliably detect notes that are held for less than a beat.

- When generating the output tones, notePrint allows each frequency to overlap with the same amplitude.  To make the output match the input a little more closely, these waveforms should maintain their relative amplitudes.