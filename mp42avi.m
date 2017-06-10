clear;
% from a mp4 video to images
fileName = 'zhuchen_0.36/zhuchen.mp4';
fileInfo = mmfileinfo(fileName);
vidObj = VideoReader(fileName);

vidObj.CurrentTime = 0.0;
%frames = cell(fileInfo.Video.Height, fileInfo.Video.Width);
frameRate = vidObj.FrameRate;

nFrames = 0;
resize_scale = 0.36;
while hasFrame(vidObj)
    nFrames = nFrames + 1;
    vidFrame = readFrame(vidObj);
    frames{nFrames} = imresize(vidFrame, resize_scale);
    imwrite(frames{nFrames}, strcat('zhuchen_0.36/s', num2str(nFrames),'.png'));
end

% create avi from images
vidObj = VideoWriter('zhuchen3s.avi');
vidObj.FrameRate = frameRate;
open(vidObj);
for f = 1 : nFrames*0.75
     fprintf('v = %d / %d\n', f, nFrames);
     frame = frames{f};
     writeVideo(vidObj, frame);
end
close(vidObj);