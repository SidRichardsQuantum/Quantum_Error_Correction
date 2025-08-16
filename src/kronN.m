function K = kronN(varargin)
K = 1;
for k = 1:nargin
    K = kron(K, varargin{k});
end
end
