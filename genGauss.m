
% Gaussian = e^-pi(x^2/a^2 + y^2/b^2).
% x,y - number of points at which to evaluate the function in x and y direction
% a,b - constants that describe the Gaussian
% centroids(xBar,yBar) - define the position of the centre of the beam
% amplitude - the peak amplitude of the Gaussian

function gen = genGauss(a,b,x,y,xBar,yBar,amplitude)

[xx,yy] = meshgrid((linspace(1,x,x)),linspace(1,y,y));

Beam = amplitude * exp(-1.0*(pi * ((xx-xBar).^2.0/a.^2.0 + (yy-yBar).^2.0/b.^2.0)));

imagesc(Beam)
% surf(Beam)
assignin('base','Beam',Beam)
end