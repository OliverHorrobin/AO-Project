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


% a= linspace(10,200,10);
% b= linspace(10,200,10);
% Rotation_angle = linspace(10,180,10);
% a3 = combvec(a,b,Rotation_angle);
% a3'




% % D4 with changing a
% for a=linspace(10,150,14);
%     b= 10
%     Rotation_angle=20
%     Beam = genGauss(a,b,x,y,xBar,yBar,amplitude,Rotation_angle,noise);
%     [xD4S,yD4S,Major_axis_angle] = d4sigma(Beam)
%     figure(2)
%     D4 = (xD4S/yD4S)*Major_axis_angle
%     hold on
%     plot(a,D4,'o')
%     title('D4 with changing a, R_a = 20 b = 10')
%     xlabel('a')
%     ylabel('(D4(xD4S/yD4S)*Major_axis_angle)')
%     hold off
% end

% D4 with changing Rotation_angle
% for Rotation_angle = linspace(0,180,180)
%     Rotation_angle
%     a= 10;
%     b= 40;
%     Beam = genGauss(a,b,x,y,xBar,yBar,amplitude,Rotation_angle,noise);
%     [xD4S,yD4S,Major_axis_angle] = d4sigma(Beam);
%     figure(3)
%     D4 = (xD4S/yD4S)*Major_axis_angle;
%     hold on
%     plot(Major_axis_angle,D4,'o')
%     title('D4 with changing Rotation_angle,a=40, b = 10')
%     xlabel('Major_axis_angle')
%     ylabel('D4((xD4S/yD4S)*Major_axis_angle)')
%     hold off
% end
% 

% || 135 < Major_axis_angle < 180

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


% 
% for a=linspace(20,150,3);
%     for b= linspace(10,100,3);
%         for Rotation_angle = linspace(45,134,3);
%             if (a > b)
%                 
%                 Beam = genGauss(a,b,x,y,xBar,yBar,amplitude,Rotation_angle,noise);
%                 [xD4S,yD4S,Major_axis_angle] = d4sigma(Beam);
% %                 if Major_axis_angle == 0:44
%                 figure(2)
%                 D4 = (yD4S/xD4S)*Major_axis_angle;
%                 ImLabel = sprintf("a=%.2f_b=%.2f_Major_axis_angle=%.2f",a,b,Major_axis_angle);
%                 grid on
%                 hold on
%                 plot(f,D4,'o')
%                 text(f,D4,ImLabel)
%                 title('D4((xD4S/yD4S)) with all combos vs Major axis angle(up to 45)')
%                 xlabel('Major_axis_angle')
%                 ylabel('D4((xD4S/yD4S)')
%                 hold off
%                 
% %                 end
%             end
% 
% 
%         end 
%     end
% end

% dosent work when major axis angle = 0

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


% 
% vals = []';
% % f = 1
% for a=linspace(20,150,3);
%     for b= linspace(10,100,3);
%         for Rotation_angle = linspace(1,44,3);
%             if (a > b)
% %                 f = f+1;
%                 Beam = genGauss(a,b,x,y,xBar,yBar,amplitude,Rotation_angle,noise);
%                 [xD4S,yD4S,Major_axis_angle] = d4sigma(Beam);
% %                 if Major_axis_angle == 0:44
%                 figure(2)
%                 D4 = (xD4S/yD4S)*Major_axis_angle;
%                 ImLabel = sprintf("a=%.2f_b=%.2f_Major_axis_angle=%.2f",a,b,Major_axis_angle);
%                 grid on
%                 hold on
%                 plot(Major_axis_angle,D4,'o')
%                 text(Major_axis_angle,D4,ImLabel)
%                 title('D4((xD4S/yD4S)) with all combos vs Major axis angle(up to 45)')
%                 xlabel('Major_axis_angle')
%                 ylabel('D4((xD4S/yD4S)')
%                 hold off
%                 vals = [vals D4];
% %                 end
%             end
% 
% 
%         end 
%     end
% end
% 
% 
% 
% for a=linspace(20,150,3);
%     for b= linspace(10,100,3);
%         for Rotation_angle = linspace(45,134,3);
%             if (a > b)
%                 
%                 Beam = genGauss(a,b,x,y,xBar,yBar,amplitude,Rotation_angle,noise);
%                 [xD4S,yD4S,Major_axis_angle] = d4sigma(Beam);
% %                 if Major_axis_angle == 0:44
%                 figure(2)
%                 D4 = (yD4S/xD4S)*Major_axis_angle;
%                 ImLabel = sprintf("a=%.2f_b=%.2f_Major_axis_angle=%.2f",a,b,Major_axis_angle);
%                 grid on
%                 hold on
%                 plot(Major_axis_angle,D4,'o')
%                 text(Major_axis_angle,D4,ImLabel)
%                 title('D4((xD4S/yD4S)) with all combos vs Major axis angle(up to 45)')
%                 xlabel('Major_axis_angle')
%                 ylabel('D4((xD4S/yD4S)')
%                 hold off
%                 
% %                 end
%             end
% 
% 
%         end 
%     end
% end
% 
% % dosent work when major axis angle = 0
% 
% for a=linspace(20,150,3);
%     for b= linspace(10,100,3);
%         for Rotation_angle = linspace(135,179,3);
%             if (a > b)
%                 
%                 Beam = genGauss(a,b,x,y,xBar,yBar,amplitude,Rotation_angle,noise);
%                 [xD4S,yD4S,Major_axis_angle] = d4sigma(Beam);
% %                 if Major_axis_angle == 0:44
%                 figure(2)
%                 D4 = (xD4S/yD4S)*Major_axis_angle;
%                 ImLabel = sprintf("a=%.2f_b=%.2f_Major_axis_angle=%.2f",a,b,Major_axis_angle);
% 
%                 grid on
%                 hold on
%                 plot(Major_axis_angle,D4,'o')
%                 text(Major_axis_angle,D4,ImLabel)
%                 title('D4((xD4S/yD4S)) with all combos vs Major axis angle(up to 45)')
%                 xlabel('Major_axis_angle')
%                 ylabel('D4((xD4S/yD4S)')
%                 hold off
%                 
% %                 end
%             end
% 
% 
%         end 
%     end
% end



if numel(vals)~=numel(unique(vals))
   disp('oh no, we have duplicates!')
end





















% Defining_Parameter = (xD4S*yD4S)/Major_axis_angle
% Excel_File_Name = 'C:\Users\ngp19326\OneDrive - Science and Technology Facilities Council\CALTA-O.Horrobin\All Important MATLAB things'
% Excel_fullFileName = fullfile(Excel_File_Name,'MATLAB to excel attempt.xlsx')
% writecell(Defining_Parameter,Excel_fullFileName,'Sheet1','','Range','B2')
% 
% 
% Excel_Label = sprintf("a=%.2f_b=%.2f_Rotation_angle=%.2f_xD4S=%.2f_yD4S=%.2f_Major_axis_angle=%.2f_ooesCircDia=%.2f",a,b,Rotation_angle,xD4S,yD4S,Major_axis_angle,ooesCircDia);
% 
% 
% ps = addParameterSet(tc,'Name','Param Set');
% addParameterOverride(ps,'a',1);
% export(ps,'myPSfile.xlsx','Sheet2');