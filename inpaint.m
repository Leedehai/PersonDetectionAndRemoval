% perform inpainting with specified method
function inpaintedImg = inpaint(imgFilename,mask_3d,method)
if strcmp(method,'sr')
    inpaintedImg = single_image_sr(imgFilename,mask_3d);
%     
elseif strcmp(method,'nlm')
    [inpaintedImg,C,D] = project_inpaint_nlm(imgFilename,mask_3d,[255,255,255]); 
    imwrite(C,strcat(imgFilename,'-nlm-confidence_term.png'));
    imwrite(D,strcat(imgFilename,'-nlm-data_term.png'));
else
    disp('invalid method');
end

figure,imshow(inpaintedImg);
title(strcat('Inpainting Result using', 32, method));
imwrite(inpaintedImg,strcat(imgFilename,'-',method,'.png'));

        