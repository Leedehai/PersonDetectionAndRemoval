[frameIDs, xs, ys, ws, hs] = textread(strcat('zhuchen/zhuchen', '.avi.txt'),'%d%d%d%d%d');
for frameIndex = 7 : 10 : 45
    % frameIndex = 1;
    display(frameIndex);
    fileName = strcat('zhuchen/', num2str(frameIndex));
    original = imread(strcat(fileName,'.png'));
    imwrite(original, 'original.png');
    frameID = frameIDs(frameIndex); x = xs(frameIndex); y = ys(frameIndex); w = ws(frameIndex); h = hs(frameIndex);
    nPerson = length(x);
    reduce_ratio = 0.1;
    draw_bbox(strcat(fileName,'.png'),frameID, x, y, w, h, nPerson, reduce_ratio);
    inpaintedImg = inpaint('original.png',strcat(fileName,'.png','mask.bmp'),'nlm');
    imwrite(inpaintedImg, strcat(fileName,'-inpainted00','.png'));
end