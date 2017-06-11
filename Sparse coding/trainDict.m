function dict = trainDict(dictSize,parameters)

% train dictionary using ksvd
% author: Chen Zhu
% 2017-3-14

% INPUT
% dictSize: size of learned dictionary
% parameters: [neib,overlap,rc_min,sigma,max_coeff,ksvd_max_iter]

% OUTPUT
% dict: learned dictionary

% ========================= setParameters ==============================
neib = parameters(1); % neib: The patch sizes used in the decomposition of the image
overlap = parameters(2); % overlap: number of pixels we skip between two neighbouring patches
% OMP Parameters
rc_min = parameters(3); % rc_min: minimal residual correlation before stopping pursuit
sigma = parameters(4); % sigma: residual error stopping criterion, normalized by signal norm
max_coeff = parameters(5); % max_coeff: sparsity constraint for signal representation
% ksvd parameters
ksvd_max_iter = parameters(6);
% =======================================================================

% load training samples
training = []
cd USCimages_bmp
files = dir('*.bmp');
numOfImages = length(files);
for i=1:numOfImages
    ii = im2double(imread(files(i).name));
    if size(ii,3)==3
        ii = rgb2gray(ii);
    end
    training = [training splitImg(ii,neib)];
end %i
cd ..
Y = training;

% initialize dictionary using DCT coefficients
dict = zeros(dictSize);
n = dictSize(1); L = dictSize(2);
dict(:,1) = 1/sqrt(n);
for k = 2:L
    v = cos((0:n-1)*pi*(k-1)/L)';
    v = v-mean(v);
    dict(:,k) = v/norm(v);
end
% performing ksvd
dict = ksvd(dict,Y,rc_min,max_coeff,sigma,ksvd_max_iter);
% save trained dictionary
save('ksvd_dict.mat','dict');




