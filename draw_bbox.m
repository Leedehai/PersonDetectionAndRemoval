function draw_bbox(imgFile,frameID, x, y, w, h, nPerson, reduce_ratio)
Ibbox = imread(imgFile);
[imgH, imgW, imgC] = size(Ibbox);
Imask = zeros(imgH, imgW, imgC);

for r = 1 : imgH
   for c = 1 : imgW
       for iPerson = 1 : nPerson
           xp = x(iPerson); yp = y(iPerson); wp = w(iPerson); hp = h(iPerson);
           xpc = xp + wp/2; ypc = yp + hp/2;
           wpnew = round(wp * (1 - reduce_ratio));
           hpnew = round(hp * (1 - reduce_ratio));
           xpnew = round(xpc - wpnew / 2);
           ypnew = round(ypc - hpnew / 2);
           %isOnVerge(r,c,xpnew, ypnew, wpnew, hpnew)
           if isOnVerge(r,c,xpnew, ypnew, wpnew, hpnew)
               Ibbox(r,c,:) = [0, 255, 0];
               %display('bbox pix drawn');
           end
           if isInBoundary(r,c,xpnew, ypnew, wpnew, hpnew)
               Imask(r,c,:) = [255, 255, 255];
               %display('mask pix drawn');
           end
       end
   end
end
subplot(1,2,1); imshow(Ibbox);
subplot(1,2,2); imshow(Imask);

imwrite(Ibbox, strcat(imgFile,'bbox.bmp'));
imwrite(Imask, strcat(imgFile,'mask.bmp'));