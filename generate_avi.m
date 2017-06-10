%  % from single image
%  I = imread('people_2.png');
%  nFrame = 1;
%  vidObj = VideoWriter('people_2.avi');
%  vidObj.FrameRate = 5;
%  open(vidObj);
%  frame = I;
%  for f = 0 : nFrame - 1
%      fprintf('v = %d / %d\n', f, nFrame - 1);
%      writeVideo(vidObj, frame);
% end
% close(vidObj);

 % from single image
 nFrame = 1;
 vidObj = VideoWriter('zhuchen_inpainted.avi');
 vidObj.FrameRate = 5;
 open(vidObj);
 piclist = dir('*.png');
 for f = 1 : size(piclist,1)
     filename = piclist(f)
     frame = imread(filename.name);
     writeVideo(vidObj, frame);
end
close(vidObj);


