numOfAtom = 512;
dim = 16;
load dctDict.mat;
finalPad = [];

row = [];
cnt = 0;
for j = 1:512   
    pad = ones(20,20);
    patch = reshape(dict(:,j),[16 16]);
    pad(3:18,3:18) = patch;
    cnt = cnt + 1;
    row = [row pad];
    if mod(cnt,32)==0
        if isempty(finalPad)
            finalPad = row;
        else
            finalPad = [finalPad;row];
        end
        row = [];
    end
end %j
%%
ff = finalPad;
% ff(ff<0) = 0;

figure,imshow(ff*8);
% for i = 1:32
%     row = [];
%     for j = 1:512
%         patch = reshape(dict(:,j),[16 16]);
%         row = [row patch];
%     end %j
%     finalPad = [finalPad;row];
% end%i