function visualizeDict(dict,dim)

h = dim(1);
w = dim(2);
h_out = int16(sqrt(size(dict,1)));

if h*w ~= size(dict,1)
    error('input dimension must match dictionary dimension');
end % if

final = [];
for j = 1:size(dict,2)
    patch = reshape(dict(:,j),dim);
    
    
end % j

% visualize