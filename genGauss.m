
% Gaussian = e^-pi(x^2/a^2 + y^2/b^2).
% x,y - number of points at which to evaluate the function in x and y direction
% a,b - constants that describe the Gaussian
% centroids(xBar,yBar) - define the position of the centre of the beam
% amplitude - the peak amplitude of the Gaussian

function gen = genGauss(a,b,x,y,xBar,yBar,amplitude)

[xx,yy] = meshgrid((linspace(1,x,x)),linspace(1,y,y));

Beam = amplitude * exp(-1.0*(pi * ((xx-xBar).^2.0/a.^2.0 + (yy-yBar).^2.0/b.^2.0)));

Rotation_angle = 136;

Beam = imrotate(Beam,Rotation_angle,'nearest','crop'); %To Rotate the beam

% % To add noise: Yes for noise = 1, No for noise = 0
noise = 0;
if noise == 1
   nBeam = zeros(size(Beam));
    c = rand(size(Beam)) < 0.05; %Creates an array of randum numbers between 0-1 the size of the image. Final number corresponds to the percentage of noice in the image, 1 being 100%
    z = nBeam;
    n = rand(1,nnz(c)) * (amplitude/10); %Final number corresponds to the maximum amplitude of the noise/#
    z(c) = n;
    Beam = Beam + z;
elseif noise == 0
    Beam = Beam;
end

% Filters out the noise
Beam = medfilt2(Beam);

imagesc(Beam)

% % saves the image as the perameters and then the outcomes 
[ooesPercent,ooesCircDia] = oneOverESquared(Beam);
[xD4S,yD4S,Major_axis_angle] = d4sigma(Beam);
ImLabel = sprintf("a=%.2f_b=%.2f_x=%.2f_y=%.2f_xBar=%.2f_yBar=%.2f_amplitude=%.2f_Rotation_angle=%.2f_noise=%.2f_xD4S=%.2f_yD4S=%.2f_Major_axis_angle=%.2f_ooesPercent=%.2f_ooesCircDia=%.2f",a,b,x,y,xBar,yBar,amplitude,Rotation_angle,noise,xD4S,yD4S,Major_axis_angle,ooesPercent,ooesCircDia);
J_add = '.jpg';
ImLabeljpg = strcat(ImLabel,J_add);
folder = 'C:\Users\ngp19326\OneDrive - Science and Technology Facilities Council\Phase Correction\MATLAB_Images';
img = getframe(gcf);
fullFileName = fullfile(folder,ImLabeljpg);
imwrite(img.cdata,fullFileName,'jpg');

figure(2)
plot(Beam(100,:))% Displays a lineout along x=#
title('Lineout')

% surf(Beam)
assignin('base','Beam',Beam)
end
