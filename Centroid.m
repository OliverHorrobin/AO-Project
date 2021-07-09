% Originally designed in python by Chris Gregory
% Calculate the centoid position of an image along either the x- or y-axis
% 	
% image: array like, required
% 		The array representing the image that is to be processed 
% 	
% 	Returns x and y centroid pixel positions stored in workspace

function [xCentroid,yCentroid]= Centroid(image)

m00 = Moment(image,0,0);
m10 = Moment(image,1,0);
m01 = Moment(image,0,1);

xCentroid = (m10/m00);
yCentroid = (m01/m00);



assignin('base','xCentroid',xCentroid)
assignin('base','yCentroid',yCentroid)

end