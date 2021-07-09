%% Startup
%This is the code to run it properly using hardware (laser mirrors
%driverbox ect). To make this work a connection to the driver box will have
%to be sorted properly. Take a portion of the code from WSAO simmulation
%inorder to analise real beam focus to determine xD4S at start(there is code already for all of this, just needs to be added). 
% Change perameter to something within reason after seening start value and it should work.
clc; clear;

cam = gigecam('50-0536910683');
cam.Timeout = 2; cam.ExposureTimeAbs = 400; cam.PixelFormat = 'Mono12';
preview(cam)

DM = mirror;
%% Correction loop

fhandle = @(r) costfun(r,DM,cam);
% solver = coordinate_search(64,fhandle,5);
solver = pattern_search(64,fhandle);

Parameter = 80 %Set thevalue od xD4S that you are looking for


for i = 1:20
    step(solver);
    clc
    %Add something here to read of current value of perameter (see waso)
    fprintf('Iteration\t%i\n',i);
end

function cost = costfun(pos,dm,cam)
    volts = 100*pos; % solver coords -> voltages
    
    dm.setChannels(volts);
    
    img = single(snapshot(cam));
    img = medfilt2(img,[3 3]);	% Reducing noise
%     cost = -max(img,[],'all');
    ff = BackgroundRemover(img,3);
    cost = Errorfunct(ff,Parameter)
end

function CorrectedFF = BackgroundRemover(FF,Border)%Takes the mean value from a ring pf pizels from the border(Width 'Border') 
                                              %and minus's that from the
                                              %whole image to remove the
                                              %backgrond value. This allows
                                              %parameters to be calculated from focus                                 
siz  = size(FF);
mask = false(siz(1), siz(2));
mask(1:Border, :) = true;
mask(:, 1:Border) = true;
mask(siz(1)-Border+1:siz(1), :) = true;
mask(:, siz(2)-Border+1:siz(2)) = true;
meanBorder = mean(FF(mask));
CorrectedFF = FF - meanBorder;

% Test = CorrectedFF <= 1;% if Want to make calues less than 1 = 0 (Recomend not)
% CorrectedFF(Test) = 0;

end
function error = Errorfunct(FarF,want) %Function to calculate the cost which is the difference between what you want and what you have
[xD4S,~,~] = d4sigma(FarF);
have = xD4S; %Set the parameter to meet here
error = abs(want - have);
end