% Check the camera is working physically

%% Startup
clc; clear;

 
cam = gigecam('50-0536910683');
% cam = gigecam('169.254.148.123');
cam.Timeout = 20; cam.ExposureTimeAbs = 500; cam.PixelFormat = 'Mono12';
preview(cam)

 
