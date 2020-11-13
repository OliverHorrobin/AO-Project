%% Startup
clc; clear;

cam = gigecam('50-0503368723');
cam.Timeout = 2; cam.ExposureTimeAbs = 400; cam.PixelFormat = 'Mono12';
preview(cam)

DM = mirror;
%% Correction loop

fhandle = @(r) costfun(r,DM,cam);
% solver = coordinate_search(64,fhandle,5);
solver = pattern_search(64,fhandle);
for i = 1:20
    step(solver);
    clc
   
%     [xCentroid,yCentroid]= Centroid(cam);
%     txt = sprintf("xCentroid: %.2f, yCentroid: %.2f",xCentroid,yCentroid);
%     text(0.6,1.1,txt,'Units','normalized','FontSize',10)
%     
%     [ooesPercent,ooesCircDia]= oneOverESquared(cam);
%     txt = sprintf("ooesPercent: %.2f, ooesCircDia: %.2f",ooesPercent,ooesCircDia);
%     text(0.0,1.1,txt,'Units','normalized','FontSize',10)
%     
%     [xD4S,yD4S,Major_axis_angle] = d4sigma(cam);
%     txt = sprintf("xD4S: %.2f, yD4S: %.2f, Major axis angle:%.2f ",xD4S,yD4S,Major_axis_angle);
%     text(0,.5,txt,'Units','normalized','FontSize',10)

    fprintf('Iteration\t%i\n',i);
end

function cost = costfun(pos,dm,cam)
    volts = 100*pos; % solver coords -> voltages
    
    dm.setChannels(volts);
    
    img = single(snapshot(cam));
    img = medfilt2(img,[3 3]);	% Reducing noise
    cost = -max(img,[],'all');
end