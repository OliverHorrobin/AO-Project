
% Calculate the Mij moment of an image

function [mom] = Moment(imArray,i,j)

[x,y] = meshgrid((0:size(imArray,1)-1),(0:size(imArray,2)-1));

mom   = 1.0*sum(x.^(i) .* y.^(j) .* imArray, "all");
end