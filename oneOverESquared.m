% Originally designed in python by Chris Gregory
function [ooesPercent,ooesCircDia] = oneOverESquared(image)

[imageWidth,imageHeight] = size(image);

M00 = Moment(image,0,0);
maxPixelVal = max(image,[],'all');
[maxPixelValPositionRow,maxPixelValPositionColumn] = find((image == maxPixelVal));

% Set the threshold 1/e^-2 value. Form here on OOEs means One Over E Squared
OOEs = maxPixelVal * exp(-2.0);

% Spiral search out from the max px position searching for point at which values drop below OOES.
% Once four consecutive spiral segments see no values >= ooes, then the search finishes and the OOES 
% region is defined.

% Setup search
dx = 1; %direction to move in x
dy = 0; %direction to move in y
x = maxPixelValPositionRow(1,:); %x-coord of start point
y = maxPixelValPositionColumn(1,:); %y-coord of start point
stopSearch = 0; %stop search condition
segLen = 1; %size of the current segment
segTrav = 0; %how much of the current segment has been traversed
segLow = 0; %Number of consecutive segments with no value >= ooes
segMax = 0; %Max value measured during a segment
ooesSum = maxPixelVal; %the integrated intensity in the ooes region
ooesPxs = 1; %Number of pixels in the OOES region

% Search until condition is met
while stopSearch == 0
    
    	%Search until condition is met
   		x = x + dx;
		y = y + dy;
		segTrav = segTrav + 1;
		
        %Error checking
		if  x > (imageWidth -1) || y > (imageHeight -1)
    
            Words =  ("Exceeded ROI bounds before reaching 1/e^2 intensity. Extend ROI or perform background subtraction")
       
        end
        pxVal = round(image(x,y));
        segMax= max(pxVal,segMax);
        
        %if the pixel value is >= OOES add it to the integrated intensity
        if pxVal >= OOEs
			
            ooesSum = ooesSum + pxVal;
			ooesPxs = ooesPxs + 1;
			     
        end
        
        %if finished current segment then change direction and perform checks
        if segTrav == segLen
            
            %change direction
            holder = dx;
            dx = -dy;
            dy = holder;

            %check max value and update and segLow if necessary
            if segMax < OOEs
			
                segLow = segLow + 1;
            
            else 
                segLow = 0;
                
            end
       
            %increase segment length if necessary
            if dy == 0
       
                segLen =  segLen + 1;
		
            end
        
            segTrav = 0;
            segMax = 0;
            
            %Stop search if have 4 consecutive segments with no values >= ooes
            if segLow == 4
        
                stopSearch = 1;

           end
        end
        
end

% Calculate the percentage of energy in the OOES region
ooesPercent = 100.0 * ooesSum / M00;
% Calculate diameter of circle covering equivalent area to OOES region
ooesCircDia = 2 *  sqrt (1.0 * ooesPxs / pi);

assignin('base','ooesPercent',ooesPercent)
assignin('base','ooesCircDia',ooesCircDia)
end

