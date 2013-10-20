# noteName
# Function to generate the note and cents for a given frequency
#
# function [n,c] = noteName(f)
#
# Inputs:
# 	f: The frequency that needs to be mapped to a note
#
# Outputs:
#	n: The note name for the frequency
#	c: The cents for the frequency
#

function [n,c] = noteName(f)
	n = 0;
	c = 0;

	if (f > 0)
		notes = {'C','C#','D','D#','E','F','F#','G','G#','A','A#','B'};
		steps = log(f/440)/log(2^(1/12));

		c = (steps - round(steps))*100;
		steps = round(steps) + 10;
		n = mod(steps,12);
		if (n == 0) n = 12; end
		n = notes{n};
		steps = ceil(steps/12);
		n = strcat(n,num2str(3 + steps));
	end
end
