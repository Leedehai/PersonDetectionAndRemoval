function dict = getDictionary(I_mask,mask,dictSize,type,parameters)

% initialize dictionary for inpainting.m
% author: Chen Zhu

% INPUT
% I_mask: degraded image
% mask: mask of degraded image
% dictSize: tuple denoting the size of the output dictionary
% type: type of coefficients
%       'dct': DCT coefficients
%       'ksvd': learned dictionary
% parameters: 
%   for ksvd: parameters = [neib,overlap,rc_min,sigma,max_coeff,ksvd_max_iter]
%   for other: parameters = []
% OUTPUT
% dict: generated/learned dictionary

if strcmp(type,'dct')
    dict = zeros(dictSize);
    n = dictSize(1); L = dictSize(2);
    dict(:,1) = 1/sqrt(n);
    for k = 2:L
        v = cos((0:n-1)*pi*(k-1)/L)';
        v = v-mean(v);
        dict(:,k) = v/norm(v);
    end
end


if strcmp(type,'ksvd') 
    if exist('ksvd_dict.mat','file')
        load 'ksvd_dict.mat';
    else
        dict = trainDict(dictSize,parameters);
    end % if    
end

if ~strcmp(type,'dct') && ~strcmp(type,'wavelet') && ~strcmp(type,'ksvd')
    error('invalid dictionary type');
end