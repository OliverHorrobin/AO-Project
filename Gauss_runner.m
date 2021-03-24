clear all
close all
%(a,b,x,y,xBar,yBar,amplitude,Rotation_angle,noise)
%When b is more than a, the length of the beam in y is more than in x, and the major axis angle reflects this accordingly

genGauss(30,60,200,200,100,100,250,1,0);
Centroid(Beam);
d4sigma(Beam);
oneOverESquared(Beam);
