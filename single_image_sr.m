% Downsample from 1 image (square shape), inpaint with NLM, and restore
function inpaintedImg = single_image_sr(imgFilename,fillFilename)
   clear; clc; close all;
    % load target, HR image
    Itarget = im2double(imread(imgFilename)); 
    Imask = im2double(imread(fillFilename));

%     Itarget = im2double(imread('balloon.jpg'));
%     Imask = repmat(im2double(imread('balloon_mask_1d.jpg')),[1,1,3]);
    % Downsample from 1 HR image to 1 LR images with Ax(x)
    b2 = Ax(Itarget);
    I1 = b2{1};
    imwrite(I1, 'I1.png');
    m2 = Ax_mask(Imask);
    M1 = zeros(size(m2{1}));
    for i = 1:3
        M1(:,:,i) = im2bw(m2{1}, 0.01) .* 255;
    end
    size(M1);
    imshow(uint8(M1));
    imwrite(M1, 'M1.png');

    [o1,c,d] = project_inpaint_nlm('I1.png','M1.png',[255 255 255]);
    imshow(o1);
    imagesc(c);
    imagesc(d);
    b = o1;
    figure;
    imshow(b);

    % initial guess of super-resolved image
    x = zeros(size(Itarget));
    % step length
    alpha = 1;
    lambda = 0.5;
    % max number of iterations
    maxIters = 100;
    % initialize residual and PSNR
    residuals   = zeros([1 maxIters]);
    PSNRs       = zeros([1 maxIters]);
    % for all gradient descent iterations
    for it = 1:maxIters
        % gradient descent update
        % no prior
        x = x - alpha * (Atx(Ax_g(x) - b));
        % norm-2 prior
        %x = x - alpha * (Atx(Ax_g(x) - b) + lambda * x);
        % compute residual and PSNR
        residuals(it) = sum(sum(sum((Ax_g(x) - b).^2)));
        MSE = sum(sum(sum((b - Ax_g(x)).^2)));
        [d1,d2,d3] = size(b);
        MSE = MSE/(d1*d2*d3);
        PSNRs(it) = 10*log10(1/MSE);
    end
    
    inpaintedImg = uint8(x);
   
    % plot data
%     figure;
%     subplot(2,2,1)
%     imshow(Itarget);
%     title('Original');
%     
%     subplot(2,2,2)
%     imshow(uint8(x));
%     title(['GC Reconstruction, at iter: ' num2str(it)]);
%     
%     subplot(2,2,3)
%     imshow(imresize(uint8(o1),2,'cubic'));
%     title('Bicubic Interpolation');
%     
%     o1resize = imresize(uint8(o1),2,'cubic');
%     %H = fspecial('gaussian',[size(o1resize,1),size(o1resize,2)],0.5*min(size(o1resize,1),size(o1resize,2)));
%     %o1resize2 = o1resize - uint8(real(ifft2(fft2(o1resize).*repmat(psf2otf(H),[1,1,3]))));
%     subplot(2,2,4)
%     o1resize3 = imsharpen(o1resize);
%     imshow(o1resize3);
%     title('Sharpening with Unsharp Masking');
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% forward image formation - simulate 1 low-resolution images that sample
% a single, high-resolution image differently
function res_mask = Ax_mask(I)
    %dim = 384;
    Iu_1 = I(1:2:end,1:2:end,:);
    Iu_2 = I(1:2:end,2:2:end,:);

    Ic_1 = I(2:2:end,1:2:end,:);
    Ic_2 = I(2:2:end,2:2:end,:);

    I1 = 0.25 .* (Iu_1+Iu_2+Ic_1+Ic_2);

    res_mask = {};
    res_mask{1} = I1;
end

function res = Ax_g(I)
    %dim = 384;
    Iu_1 = I(1:2:end,1:2:end,:);
    Iu_2 = I(1:2:end,2:2:end,:);

    Ic_1 = I(2:2:end,1:2:end,:);
    Ic_2 = I(2:2:end,2:2:end,:);

    I1 = 0.25 .* (Iu_1+Iu_2+Ic_1+Ic_2);

    res = I1;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% transpose image formation - project 1 low-resolution images back onto the
% grid of the single, high-resolution image (and add them there)
function res = Ax(I)
    %dim = 384;
    Iu_1 = I(1:2:end,1:2:end,:);
    Iu_2 = I(1:2:end,2:2:end,:);

    Ic_1 = I(2:2:end,1:2:end,:);
    Ic_2 = I(2:2:end,2:2:end,:);

    I1 = 0.25 .* (Iu_1+Iu_2+Ic_1+Ic_2);

    res = {};
    res{1} = I1;
end

function res = Atx(I)
    dim = size(I, 1);
    % Complete
    I1 = I(1:dim, 1:dim, :);
    Ip_1 = imresize(I1, 2, 'nearest');
    res = 1 .* (Ip_1);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
