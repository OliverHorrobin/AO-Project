clear all
close all

x=400;
y=400;
xBar=200;
yBar=200;
amplitude=250;
noise=0;

aIterations = 3;
bIterations = 3;
angleIterations = 3;

aStartPoint = 20
bStartPoint = 10

aEndPoint = 120
bEndPoint = 100

on = 0

for a=linspace(10,200,10)
    for b= linspace(20,210,10)
        Rotation_angle = 50;
        Beam = genGauss(a,b,x,y,xBar,yBar,amplitude,Rotation_angle,noise);

        [xD4S,yD4S,Major_axis_angle] = d4sigma(Beam);
        [ooesPercent,ooesCircDia] = oneOverESquared(Beam);

        figure(2)
        D4 = ooesCircDia;

        grid on
        hold on
        f = 1;
        s = plot(a,D4,'x');

        dt = datatip(s,a,D4);
        dt.Visible = 'off';
        s.DataTipTemplate.DataTipRows(1).Label = 'a';
        s.DataTipTemplate.DataTipRows(2).Label = 'D4'; 
        aLabel = dataTipTextRow('a',a);
        s.DataTipTemplate.DataTipRows(end+1) = aLabel;
        bLabel = dataTipTextRow('b',b);
        s.DataTipTemplate.DataTipRows(end+1) = bLabel;
        Major_axis_angleLabel = dataTipTextRow('Major_axis_angle',Major_axis_angle);
        s.DataTipTemplate.DataTipRows(end+1) = Major_axis_angleLabel;


        title('a with all combos vs ooescircdia')
        xlabel('a')
        ylabel('ooesCircDia')
        hold off
                

            end
        end 

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


if on == 1
vals = []';
f = 1;
for a=linspace(aStartPoint,aEndPoint,aIterations)
    for b= linspace(bStartPoint,bEndPoint,bIterations)
        for Rotation_angle = linspace(1,44,angleIterations)
            if (a > b)
%                 f = f+1;
                Beam = genGauss(a,b,x,y,xBar,yBar,amplitude,Rotation_angle,noise);
                
                [xD4S,yD4S,Major_axis_angle] = d4sigma(Beam);
                [ooesPercent,ooesCircDia] = oneOverESquared(Beam);

                figure(2)
                D4 = ooesCircDia;

                grid on
                hold on
                
                s = plot(f,D4,'x');

                dt = datatip(s,f,D4);
                dt.Visible = 'off';
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
                ylabel('D4((ooesCircDia*Major_axis_angle)')
                hold off
                vals = [vals D4]

            end
        end 
    end
end


f=2
for a=linspace(aStartPoint,aEndPoint,aIterations);
    for b= linspace(bStartPoint,bEndPoint,bIterations);
        for Rotation_angle = linspace(45,134,angleIterations);
            if (a > b)
                
                Beam = genGauss(a,b,x,y,xBar,yBar,amplitude,Rotation_angle,noise);
                [ooesPercent,ooesCircDia] = oneOverESquared(Beam);
                [xD4S,yD4S,Major_axis_angle] = d4sigma(Beam);

                figure(2)
                D4 = ooesCircDia;
                
                grid on
                hold on
                
                s = plot(f,D4,'o');

                dt = datatip(s,f,D4);
                dt.Visible = 'off';
                s.DataTipTemplate.DataTipRows(1).Label = 'f';
                s.DataTipTemplate.DataTipRows(2).Label = 'D4'; 
                aLabel = dataTipTextRow('a',a);
                s.DataTipTemplate.DataTipRows(end+1) = aLabel;
                bLabel = dataTipTextRow('b',b);
                s.DataTipTemplate.DataTipRows(end+1) = bLabel;
                Major_axis_angleLabel = dataTipTextRow('Major_axis_angle',Major_axis_angle);
                s.DataTipTemplate.DataTipRows(end+1) = Major_axis_angleLabel;
                
                title('D4((xD4S/yD4S)) with all combos vs Major axis angle(up to 45)')
                xlabel('f')
                ylabel('D4(ooesCircDia*Major_axis_angle)')
                hold off
                vals = [vals D4]

            end


        end 
    end
end

% % dosent work when major axis angle = 0
f=3
for a=linspace(aStartPoint,aEndPoint,aIterations);
    for b= linspace(bStartPoint,bEndPoint,bIterations);
        for Rotation_angle = linspace(135,180,angleIterations);
            if (a > b)
                
                Beam = genGauss(a,b,x,y,xBar,yBar,amplitude,Rotation_angle,noise);
                [xD4S,yD4S,Major_axis_angle] = d4sigma(Beam);
                [ooesPercent,ooesCircDia] = oneOverESquared(Beam);
                figure(2)
                D4 = ooesCircDia;
                
                grid on
                hold on
                
                s = plot(f,D4,'*');
                
                dt = datatip(s,f,D4);
                dt.Visible = 'off';
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
                ylabel('D4(ooesCircDia*Major_axis_angle)')
                hold off
                vals = [vals D4]
            end
        end 
    end
end

vals = round(vals,1)
if numel(vals)~=numel(unique(vals))
   disp('oh no, we have duplicates!')
end

end

