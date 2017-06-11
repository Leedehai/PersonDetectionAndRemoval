function I_rec = inPainting(I, mask,dict,parameters)
% Perform the actual inpainting of the image
%
% INPUT
% I: (dim x dim) masked image
% mask: (dim x dim) the mask hiding image information
% dict: (dim*^2,2*dim^2) dictionary
%
% OUTPUT
% I_rec: Reconstructed image

neib = parameters(1);overlap = parameters(2);rc_min = parameters(3);
sigma = parameters(4);max_coeff = parameters(5);

X_rec = splitImg(I, neib);
M = splitImg(mask, neib);
% find sparse representation over dictionary U, using OMP
Z = OMP(dict, X_rec, M, sigma, rc_min, max_coeff);
% approximate signals
X_rec = dict*Z;
% Cut outliers off
X_rec(X_rec < 0) = 0;
X_rec(X_rec > 1) = 1;
% Transform signals back to image
I_rec = mergePatch(X_rec);
% Correct known pixels
I_rec(mask~=0) = I(mask~=0);




