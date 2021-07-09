% Originally designed in python by Chris Gregory
% Calculate the D4 sigma width of a beam - defined as 4 times sigma, where sigma is the 
% 	standard deviation of the horizontal or vertical marginal distribution, respectively.
% 	imgArray: array-like, required
%         The image to be processed
	
function [xD4S,yD4S,Major_axis_angle] = d4sigma(imgArray)
%Define image moments (http:#en.wikipedia.org/wiki/Image_moment)
%m denotes raw moments, mu denotes central moments normalised to m00 (i.e. mu prime on Wikipedia page)

m00 = Moment(imgArray,0,0);
m10 = Moment(imgArray,1,0);
m01 = Moment(imgArray,0,1);
m20 = Moment(imgArray,2,0);
m02 = Moment(imgArray,0,2);
m11 = Moment(imgArray,1,1);

mu20 = (m20 - m10^2/m00)/m00;
% mu20=round(mu20,10)
mu02 = (m02 - m01^2/m00)/m00;
% mu02=round(mu02,10)
mu11 = (m11 - m10*m01/m00)/m00;
% mu11=round(mu11,10)

% Get angle of major axis in rads

if mu20 > mu02
    imAngle = -0.5*atan(2*mu11/(mu20-mu02));
    
elseif mu20 < mu02
    
    if m11 > 0 %Made a change here < to >
        imAngle = 0.5 * pi - 0.5*atan(2*mu11/(mu20-mu02));
    
    else
        imAngle = -0.5 * pi - 0.5*atan(2*mu11)/(mu20-mu02);
     
    
    end  
    
elseif mu20 == mu02
    if mu11 > 0
        imAngle = pi/4;
        
    elseif mu11 < 1
        imAngle = pi/-4;
        
    else
        imAngle = 0.0;
        
    end
end

gamma = (mu20 - mu02) / abs(mu20 - mu02);

xD4S = 2*sqrt(2.0) * sqrt(mu20 + mu02 + gamma*sqrt((mu20-mu02)^2 + 4*mu11^2));
yD4S = 2*sqrt(2.0) * sqrt(mu20 + mu02 - gamma*sqrt((mu20-mu02)^2 + 4*mu11^2));

if imAngle < 0
    imAngle = imAngle+pi;%To correct it
end

Major_axis_angle = imAngle*180/pi;%to go from radians to degrees

% Note: When mu20 and mu02 are the same (or pretty muchie to a high dp of
% similarity) Major_axis_angle is unreliable and should be ignored. This
% happens when a&b (the constants that describe the Gaussian 
% centroids which definine the position of the centre of the beam 
% amplitude - the peak amplitude of the Gaussian) are the same.

assignin('base','xD4S',xD4S)
assignin('base','yD4S',yD4S)
% assignin('base','mu20',mu20)
% assignin('base','mu02',mu02)
% assignin('base','mu11',mu11)
assignin('base','Major_axis_angle',Major_axis_angle)

end
