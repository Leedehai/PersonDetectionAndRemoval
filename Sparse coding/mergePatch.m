function I = mergePatch(X)
% merge vetorized patches back to image


neib = sqrt(size(X,1));
patchNumPerRow = sqrt(size(X,2));
dim = patchNumPerRow*neib;
I = zeros(dim,dim);
for i = 0:patchNumPerRow-1
    cur_row = zeros(neib,dim);
    for j=0:patchNumPerRow-1
        patch = X(:,1+i*patchNumPerRow+j);
        patch = reshape(patch,[neib,neib]);
        cur_row(:,1+j*neib:j*neib+neib) = patch;
    end
    I(1+i*neib:i*neib+neib,:) = cur_row;
end