%  run me
clear all;close all;

% ================ set input argument ===================================
mask_type = 'mask2'; % chose from ['mask','mask2','mask3'];
method = 'ksvd'; % chose from ['dct','ksvd'];
% =======================================================================
path = 'images/';
mask = imread(strcat(path,mask_type,'.png'));
I = im2double(imread(strcat(path,'lenaTest1.jpg')));
I_mask = I;
I_mask(mask == 0) = 0;


%%
% ========================= setParameters ==============================
neib = 16; % neib: The patch sizes used in the decomposition of the image
overlap = 16; % overlap: number of pixels we skip between two neighbouring patches
% OMP Parameters
rc_min = 0.01; % rc_min: minimal residual correlation before stopping pursuit
sigma = 0.01; % sigma: residual error stopping criterion, normalized by signal norm
max_coeff = 10; % max_coeff: sparsity constraint for signal representation
% ksvd parameters
ksvd_max_iter = 80;
dictSize = [neib^2,2*neib^2];
parameters = [neib,overlap,rc_min,sigma,max_coeff,ksvd_max_iter];
% =======================================================================

% get dictionary
dict = getDictionary(I,mask,[neib^2,2*neib^2],method,parameters);

% reconstruction
I_rec = inPainting(I_mask, mask,dict,parameters);

% visualization
I_mask_marked = repmat(I_mask,[1 1 3]);
[y,x] = find(mask==0);
for ii = 1:length(y)
    I_mask_marked(y(ii),x(ii),:) = [1;0;0];
end %ii
ratio = psnr(I,I_rec);
figure;
subplot(1,2,1);imshow(I_mask_marked);title('destroyed');
subplot(1,2,2);imshow(I_rec);title(strcat('reconstructed: psnr = ',num2str(ratio)));
% cd results
% saveas(gcf,strcat(mask_type,'_',method,'_psnr_',num2str(ratio),'_comp.png'));
% imwrite(I_rec,strcat(mask_type,'_',method,'_psnr_',num2str(ratio),'_rec.png'))
% cd ..
