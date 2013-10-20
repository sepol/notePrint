# clusterValues
# Clusters the values in an input vector based on a defined bound
#
# function v = clusterValues(in,bound)
#
# Inputs:
#	in: The input vector
#	bound: Allows a custom bound for clustering to be given
#
# Outputs:
#	v: The resulting vector with clustered values
#

function v = clusterValues(in,bound)
	if nargin < 2
		bound = 10;
	end
	if ~isempty(in)
		u = linspace(1,length(in),length(in));
		for i = 1:length(in)
			if i > length(u) break; end
			v = find((in>in(u(i))-bound)&(in<in(u(i))+bound));
			for j = 2:length(v)
				u(u == v(j)) = [];
			end
		end
		v = zeros(length(u),1);
		for i = 1:length(u)
			v(i) = in(u(i));
		end
	end
end
