% Used to generate a multitude of gaussian focal spots (eg from a= 2 to 80 and b = 2 to 90 and all in between) and analyse them on
% a graph against each other (can edit what to see and click on individual
% spots to see what are the a, b xd4S values are ect. 
% Be aware that when a = b are the same D4s is unreliable (see d4Sigma
% documentation
clear all
close all

x=400;
y=400;
xBar=200;
yBar=200;
amplitude=250;
noise=0;
% b=10
% Rotation_angle = 10



vals = []';
f = 1;
for a=linspace(20,120,5)
    for b= linspace(10,100,5)
        for Rotation_angle = linspace(1,44,5)
            if (a > b)
%                 f = f+1;
                Beam = genGauss(a,b,x,y,xBar,yBar,amplitude,Rotation_angle,noise);
                
                [xD4S,yD4S,Major_axis_angle] = d4sigma(Beam);
%                 if Major_axis_angle == 0:44
                figure(2)
                D4 = (xD4S/yD4S)*Major_axis_angle;
%                 ImLabel = sprintf("a=%.2f_b=%.2f_Major_axis_angle=%.2f",a,b,Major_axis_angle);
%                 ImLabel = sprintf(a,b,Major_axis_angle);
                grid on
%                 legend(ImLabel)
                hold on
                s = plot(f,D4,'x');
%                 text(f,D4,ImLabel)
                dt = datatip(s,f,D4);
                s.DataTipTemplate.DataTipRows(1).Label = 'f';
                s.DataTipTemplate.DataTipRows(2).Label = 'D4'; 
                aLabel = dataTipTextRow('a',a);
                s.DataTipTemplate.DataTipRows(end+1) = aLabel;
                bLabel = dataTipTextRow('b',b);
                s.DataTipTemplate.DataTipRows(end+1) = bLabel;
                Major_axis_angleLabel = dataTipTextRow('Major_axis_angle',Major_axis_angle);
                s.DataTipTemplate.DataTipRows(end+1) = Major_axis_angleLabel;
                
                title('D4 with all combos vs Major axis angle(up to 45 and past 135)')
                xlabel('f')
                ylabel('D4((xD4S/yD4S)*Major_axis_angle)')
                hold off
                vals = [vals D4];
%                 end
            end


        end 
    end
end

% When rotation angle <45 or >135 (max 180 min 0) xD4S = xD4S and same with yD4S. between those angles they swap. needs to be changed in d4sigma code.

for a=linspace(20,150,5);
    for b= linspace(10,100,5);
        for Rotation_angle = linspace(135,180,5);
            if (a > b)
                
                Beam = genGauss(a,b,x,y,xBar,yBar,amplitude,Rotation_angle,noise);
                [xD4S,yD4S,Major_axis_angle] = d4sigma(Beam);
%                 if Major_axis_angle == 0:44
                figure(2)
                D4 = (xD4S/yD4S)*Major_axis_angle;
%                 ImLabel = sprintf("a=%.2f_b=%.2f_Major_axis_angle=%.2f",a,b,Major_axis_angle);

                grid on
                hold on
                s = plot(f,D4,'x');
%                 text(f,D4,ImLabel)

                dt = datatip(s,f,D4);
                s.DataTipTemplate.DataTipRows(1).Label = 'f';
                s.DataTipTemplate.DataTipRows(2).Label = 'D4'; 
                aLabel = dataTipTextRow('a',a);
                s.DataTipTemplate.DataTipRows(end+1) = aLabel;
                bLabel = dataTipTextRow('b',b);
                s.DataTipTemplate.DataTipRows(end+1) = bLabel;
                Major_axis_angleLabel = dataTipTextRow('Major_axis_angle',Major_axis_angle);
                s.DataTipTemplate.DataTipRows(end+1) = Major_axis_angleLabel;
                
%                 text(f,D4,ImLabel)
                title('D4 with all combos vs Major axis angle(up to 45 and past 135)')
                xlabel('f')
                ylabel('D4((xD4S/yD4S)*Major_axis_angle)')
                hold off
                
%                 end
            end


        end 
    end
end



if numel(vals)~=numel(unique(vals))
   disp('oh no, we have duplicates!')
end



