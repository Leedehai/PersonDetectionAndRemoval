function [inpaintedImg,C,D]= project_inpaint_nlm(imgFilename,fillFilename, fillColor)
%fillColor = [255, 255, 255];
% Part of the code is credited to http://scarlet.stanford.edu/teach/index.php/Object_Removal,
% in which the original version of inpainting is implemented
warning off MATLAB:divideByZero
[img,fillImg,fillRegion] = loadimgs(imgFilename,fillFilename,fillColor);
img = double(img);
I = img;
origImg = img;
ind = img2ind(img);
sz = [size(img,1) size(img,2)]; % num_row, num_col
sourceRegion = ~fillRegion; % sourceRegion: unknown region: 0, known region: 1

[Ix(:,:,3) Iy(:,:,3)] = gradient(img(:,:,3));
[Ix(:,:,2) Iy(:,:,2)] = gradient(img(:,:,2));
[Ix(:,:,1) Iy(:,:,1)] = gradient(img(:,:,1));
Ix = sum(Ix,3)/(3*255); Iy = sum(Iy,3)/(3*255);
temp = Ix; Ix = -Iy; Iy = temp;  % Rotate gradient 90 degrees

C = double(sourceRegion); % unknown region: 0, known region: 1
D = repmat(-.1,sz);
iter = 1;

% Seed 'rand' for reproducible results (good for testing)
rand('state',0);
% display('preparation done.');
% Loop until entire fill region has been covered
total_fillRegion = sum(fillRegion(:));
progressbar('total progress');
while any(fillRegion(:))
  remainingTask = sum(fillRegion(:))/total_fillRegion;
  progressbar(1 - remainingTask);
  % display(remainingTask);
  % Find contour & normalized gradients of fill region
  fillRegionD = double(fillRegion); % Marcel 11/30/05
  dR = find(conv2(fillRegionD,[1,1,1;1,-8,1;1,1,1],'same')>0); % Marcel 11/30/05
 %dR = find(conv2(fillRegion,[1,1,1;1,-8,1;1,1,1],'same')>0);  % Original
  
  [Nx,Ny] = gradient(double(~fillRegion));
  N = [Nx(dR(:)) Ny(dR(:))];
  N = normr(N);  
  N(~isfinite(N))=0; % handle NaN and Inf
  
  % Compute confidences along the fill front
  for k=dR'
    Hp = getpatch(sz,k);
    q = Hp(~(fillRegion(Hp)));
    C(k) = sum(C(q))/numel(Hp);
  end
  
  searchWindowRadius = 3;
  averageFilterRadius = 3;
  I = padarray(I,[averageFilterRadius averageFilterRadius],'symmetric');
  sigma = 2;
  nlm_sigma = 2;
  kernel = fspecial('gaussian', [2*averageFilterRadius+1 2*averageFilterRadius+1], sigma);
  for ii = 1 : length(dR) % the ii-th in dR
      y = mod(dR(ii)-1, sz(1)) + 1;
      x = floor(dR(ii)/sz(1)) + 1;
      weight = zeros(2*searchWindowRadius+1,2*searchWindowRadius+1);
      
      for y_p = y-searchWindowRadius:y+searchWindowRadius
          for x_p = x-searchWindowRadius:x+searchWindowRadius
              currWindow = I(y-averageFilterRadius:y+averageFilterRadius,x-averageFilterRadius:x+averageFilterRadius);
              searchWindow = I(y_p-averageFilterRadius:y_p+averageFilterRadius,x_p-averageFilterRadius:x_p+averageFilterRadius);
              similarity = sum(sum((kernel.*(searchWindow-currWindow)).^2));
              weight(y_p-(y-searchWindowRadius)+1,x_p-(x-searchWindowRadius)+1) = exp(-similarity/(2*nlm_sigma^2));
          end
      end
      weight(:,:) = weight(:,:)/sum(sum(weight(:,:)));
      weighted_sum_for_center = 0;
      for y_p = y-searchWindowRadius:y+searchWindowRadius
          for x_p = x-searchWindowRadius:x+searchWindowRadius
              weighted_sum_for_center = weighted_sum_for_center + (weight(y_p-(y-searchWindowRadius)+1,x_p-(x-searchWindowRadius)+1)*I(y_p,x_p))^2;
          end
      end
      D(dR(ii)) = (weighted_sum_for_center)^(1/2);
  end
  priorities = C(dR).* D(dR);
  
  [unused,ndx] = max(priorities(:));
  p = dR(ndx(1));
  [Hp,rows,cols] = getpatch(sz,p);
  toFill = fillRegion(Hp);
  
  Hq = bestexemplar(img,img(rows,cols,:),toFill',sourceRegion);
  
  toFill = logical(toFill);
  fillRegion(Hp(toFill)) = false;
  
  C(Hp(toFill))  = C(p);
  Ix(Hp(toFill)) = Ix(Hq(toFill));
  Iy(Hp(toFill)) = Iy(Hq(toFill));
  
  ind(Hp(toFill)) = ind(Hq(toFill));
  img(rows,cols,:) = ind2img(ind(rows,cols),origImg);  

  if nargout==6
    ind2 = ind;
    ind2(logical(fillRegion)) = 1;
  end
  iter = iter+1;
end

inpaintedImg=uint8(img);
% imwrite(C,strcat(imgFilename,'-inpainted-confidence-term'));

function Hq = bestexemplar(img,Ip,toFill,sourceRegion)
m=size(Ip,1); mm=size(img,1); n=size(Ip,2); nn=size(img,2);
best = bestexemplarhelper(mm,nn,m,n,img,Ip,toFill,sourceRegion);
Hq = sub2ndx(best(1):best(2),(best(3):best(4))',mm);


function [Hp,rows,cols] = getpatch(sz,p)
w=4; p=p-1; y=floor(p/sz(1))+1; p=rem(p,sz(1)); x=floor(p)+1;
rows = max(x-w,1):min(x+w,sz(1));
cols = (max(y-w,1):min(y+w,sz(2)))';
Hp = sub2ndx(rows,cols,sz(1));

function N = sub2ndx(rows,cols,nTotalRows)
X = rows(ones(length(cols),1),:);
Y = cols(:,ones(1,length(rows)));
N = X+(Y-1)*nTotalRows;

function img2 = ind2img(ind,img)
for i=3:-1:1, temp=img(:,:,i); img2(:,:,i)=temp(ind); end;

function ind = img2ind(img)
s=size(img); ind=reshape(1:s(1)*s(2),s(1),s(2));

function [img,fillImg,fillRegion] = loadimgs(imgFilename,fillFilename,fillColor)
img = imread(imgFilename); fillImg = imread(fillFilename);
fillRegion = fillImg(:,:,1)==fillColor(1) & ...
    fillImg(:,:,2)==fillColor(2) & fillImg(:,:,3)==fillColor(3);

function [A] = normr(N)
    for ii=1:size(N,1)
        A(ii,:) = N(ii,:)/norm(N(ii,:));
    end