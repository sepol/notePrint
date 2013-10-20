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
out = fopen('LOG.txt','w');

# Evaluate the notes at each beat
lastTones = [];
o = [];
for k = spb+1:spb:length(X)
	# Put in frequency domain
	y = fft(X(k-spb:k,:),spb);
	# Ignore complex conjugate terms and find frequencies in upper 70% range
	[sortedV,sortedI] = sort(abs(y(1:length(y)/2,1)),'descend');
	tones = clusterValues(sortedI(1:histc(sortedV > max(sortedV)*0.7,1)),10);
	# Remove noise tones of 30 Hz or below
	tones = tones(tones > 30);
	# Check for sustained notes
	if ~isempty(tones)
		tones = [tones, ones(length(tones),1)];
		if ~isempty(lastTones)
			for j = 1:length(tones(:,1))
				r = tones(j,1)-10:tones(j,1)+10;
				if max(ismember(r,lastTones(:,1)))
					index = find(lastTones(:,1) == r(find(ismember(r,lastTones(:,1)))))(1,1);
					tones(j,2) = lastTones(index,2) + 1;
					lastTones(index,:) = [];
				end
			end
			# Print completed notes
			fprintf(out, '----------\nNew Beat\n');
			for i = 1:length(lastTones(:,1))
				b = lastTones(i,2);
				t = lastTones(i,1)*b;
				q = sin(linspace(0,((bpm/60)^-1)*t*2*pi,spb*b))';
				o = [o(1:end-(spb*b));o(end-(spb*b)+1:end)+q];
				fprintf(out,'Frequency: %.2f for %d beat(s)\n',t,b);
				[note,cents] = noteName(t);
				fprintf(out,'Note: %s and %.3f cents\n\n',note,cents);
			end
		end
	o = [o;zeros(spb,1)];
	lastTones = tones;
	end
end
if ~isempty(lastTones)
	fprintf(out, '----------\nLast Beat\n');
	for i = 1:length(lastTones(:,1))
		b = lastTones(i,2);
		t = lastTones(i,1)*b;
		q = sin(linspace(0,((bpm/60)^-1)*t*2*pi,spb*b))';
		o = [o(1:end-(spb*b));o(end-(spb*b)+1:end)+q];
		fprintf(out,'Frequency: %.2f for %d beat(s)\n',t,b);
		[note,cents] = noteName(t);
		fprintf(out,'Note: %s and %.3f cents\n\n',note,cents);
	end
end

fclose(out);
wavwrite(o, S, B, 'TONE.wav');
