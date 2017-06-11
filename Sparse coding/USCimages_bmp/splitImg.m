function X = splitImg(I,neib)

% split grayscale square image I into patches of neib*neib
% then vectorize each patch as a column vector
% and return a matrix formed by these vectors

% NOTE: for this project we only deal with square image and the dim of I
% can be divided by neib

% author: Chen Zhu

% INPUT
% I: image to be split
%    size(I,1) = size(I,2)
% neib: patch size
%       size(patch) = (neib,neib)
%       mod(size(I,1),neib) == 0

% OUTPUT
% X: matrix with column vectors of vectorized patches

numOfPatches = (size(I,1)/neib)^2;
X = zeros(neib^2,numOfPatches);
cnt = 1;

for i=1:size(I,1)/neib
    for j=1:size(I,1)/neib
        i_shift = (j-1)*neib;
        j_shift = (i-1)*neib;
        X(:,cnt) = reshape(I(1+i_shift:neib+i_shift,1+j_shift:neib+j_shift),[neib^2 1]);
        cnt = cnt + 1;       
    end
end

