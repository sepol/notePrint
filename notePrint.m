# notePrint.m
# Loads a sound file with a given bpm and outputs the dominant notes in each beat
clear all;

# User data entry
filename = input('Enter the sound file: ', 's');
bpm = round(input('Enter beats per minute: '));

# Load wav file
[X,S,B] = wavread(filename);
fprintf('----------\n');
fprintf('Play length: %.2fs\n',length(X)/S);
fprintf('Sample rate: %d\n',S);
spb = round(((bpm/60)^-1)*S);
fprintf('Samples per beat: %d\n',spb);
fprintf('----------\n');
o = [0,0];
out = fopen('LOG.txt','w');

# Evaluate the note at each beat
for k = spb+1:spb:length(X)
	# Put in frequency domain
	y = fft(X(k-spb:k,:),spb);
	# Ignore complex conjugate terms
	y = y(1:length(y)/2,1:2);
	# Find the dominant frequency
	[v,i] = max(abs(y(:,1)));
	fprintf(out,'Dominant Frequency: %.2f\n',i);
	[note,cents] = noteName(i);
	q = linspace(0,((bpm/60)^-1)*i*2*pi,spb)';
	q = sin(q);
	o = [o;q,q];
	# Print the corresponding note
	fprintf(out,'Note: %s and %.3f cents\n\n',note,cents);
end
fclose(out);

wavwrite(o, S, B, 'TONE.wav');
