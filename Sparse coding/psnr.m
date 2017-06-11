function ratio = psnr(img_ref,img)

% radius = round((filterSize-1)/2);
[h,w] = size(img);
diff = (img_ref-img).^2;
mse = sum(diff(:))/(h*w);
peak = max(img_ref(:));
ratio = 10*log10(peak^2/mse);

