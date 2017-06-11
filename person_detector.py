#!/usr/bin/python
import numpy as np
import cv2
import io
import os

class PersonDetector:
    def __init__(self, videoDir, videoFileName, outputDir, numFrames):
        # arguments
        self.videoDir = videoDir
        self.videoFileName = videoFileName
        self.outputDir = outputDir
        self.numFrames = numFrames
        # video itself
        self.video = cv2.VideoCapture(os.path.join(videoDir, videoFileName))
        # hog
        self.hog = cv2.HOGDescriptor()
        self.hog.setSVMDetector(cv2.HOGDescriptor_getDefaultPeopleDetector())
        # result file
        self.resFile = open(os.path.join(outputDir, videoFileName) + '.txt', 'w', 0)
    
    def work(self):
        # do real work and write to file
        for frameIdx in range(self.numFrames):
            bSuccess, frameImg = self.video.read()
            if bSuccess:
                # perform multiscale hog detection
                rects, weights = self.hog.detectMultiScale(frameImg, winStride=(8,8), padding=(32,32), scale=1.05)
                for rect1_ind, rect1 in enumerate(rects):
                    for rect2_ind, rect2 in enumerate(rects):
                        if (rect1_ind != rect2_ind) and (PersonDetector.inside(rect1, rect2)):
                            break
                    else:
                    # executed only if the "for" terminates NOT by "break"
                        outputLine = str(frameIdx) + ' ' + ' '.join(map(str, r)) + '\n'
                        self.resFile.write(outputLine)
    
    @staticmethod
    def inside(rect1, rect2):
        # return True if rect1 is inside rect2
        x1, y1, w1, h1 = rect1; x2, y2, w2, h2 = rect2
        return (x1 > x2) and (y1 > y2) and (x1 + w1 < x2 + w2) and (y1 + h1 < y2 + h2)
    
    def __del__(self):
		self.resFile.close()
        self.video.release()

        
if __name__ == "__main__":
    # configuration
    videoDir  = "/home/zclovefd/PersonDetector-py-opencv"
    videoName = "zhuchen.avi"
    numFrames = 123 # if it is a video converted from an image, then numFrames = 1
    outputDir = "/home/zclovefd/PersonDetector-py-opencv"
    
    # work
    pd = PersonDetector(videoDir, videoName, outputDir, numFrames)
    pd.work()