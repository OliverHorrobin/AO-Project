% Use CTRL+C in command window to stop simulation

%Scanning across

resolution  = 50;  % Resolution of all surfaces
orders      = 0;   % Aberration orders
channels    = 36;   % Number of mirror channels
crop_amount = 10;   % Amount to remove from polys
iterations  = 42;   % Optimisation Iterations
dm_response = 0.1;  % Mirror response time in sec
Parameter2 = 80; %Set the aim for XD4S here
Parameter3 = 5; %Set the aim for YD4S here
Search2 = 1;
Search3 = 1;

%rng_seed = 1122;
%rng(rng_seed)

addpath('WSAO')
addpath(fullfile('WSAO','AO Simulation'));
addpath(fullfile('WSAO','Optimisation Algorithms'));
addpath(fullfile('WSAO','Utilities'));

% Generate Polynomials
uncropped_polys = leg_polys(orders,resolution + 2*crop_amount);
polys = zeros(resolution,resolution,orders);
for i = 1:orders
    polys(:,:,i) = crop_matrix(uncropped_polys(:,:,i),crop_amount);
end

% Create mirror object
mirror = mirror_model(channels,resolution,0.09);
mirror.volt_const = 1/100;
mirror.set_channels(0);

% Create Farfield sim object
FF = FarField;
FF.settings(4,0.2,0.07,0.07);

% Generate initial wavefront & farfield
coeffs = 0.5*randn(orders,1);
initwf = coeff_surface(coeffs,polys);%Original

initff = FF.generate_farfield(1,initwf)*1e-6; %ORIGINAl

% meaninitff = mean(initff(:))

% int = sum(initff(:))

% Create solver object to solve objective function
fhandle = @(r) cost_function(r,initwf,mirror,FF);
fhandle2 = @(r) cost_function2(r,initwf,mirror,FF,Parameter2);
fhandle3 = @(r) cost_function3(r,initwf,mirror,FF,Parameter3);

solver = pattern_search(channels,fhandle); % Chose one from optimisation algorithms folder <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
solver2 = pattern_search(channels,fhandle2);%not original
solver3 = pattern_search(channels,fhandle3);%not original

%solver.settings(0.01,0.1,0.1,0);

fig = figure(1);
axis tight manual
% fig.Position = [1950 -150 700 871];
fig.Position = [35 0 706 871];

tiledlayout(4,2,'TileSpacing','compact')%Not original

nexttile(1,[1 1])
plotWF(initwf); %<<<<<<<<<<<<<<<<<
pbaspect([1 1 1])
title("Input wavefront")

nexttile(2,[1,1])
plotFF(initff); %<<<<<<<<<<<<<<<<<
pbaspect([1 1 1])
title("Initial farfield")

% Prealocating cost and evaluation arrays
cost = nan(iterations,1); %ORIGINAL
evals = nan(iterations,1);
ds1 = arrayDatastore(initwf);
data = read(ds1);
% Closed Loop

% for i = 1:iterations
% 
% if Search2 == 1
%     solver2.step();
%     v = solver2.position*100;
%     mirror.set_channels(v);
%     outwf = initwf + mirror.shape;
%     outff = FF.generate_farfield(1,outwf)*1e-6;
%     outff = BackgroundRemover(outff,5);
% end
% 
%     [~,yD4S,~] = d4sigma(outff);
%     diff2 = abs(yD4S - Parameter2);
%     
% if diff2 <= (Parameter3 * 0.05)
%     Search3 = 0
% else
%     Search3 = 1
% end
%     
% if Search3 == 1
%     solver3.step();
%     v = solver3.position*100;
%     mirror.set_channels(v);
%     outwf = initwf + mirror.shape;
%     outff = FF.generate_farfield(1,outwf)*1e-6;
%     outff = BackgroundRemover(outff,5);
% end
% 
%     cost(i) = fhandle2(solver2.position);
%     evals(i) = solver2.evaluations;
%     
% %     solver.step();
% % %   Get voltages and plot wavefront & farfield
% %     v = solver.position*100;
% %     mirror.set_channels(v);
% %     outwf = initwf + mirror.shape;
% %     outff = FF.generate_farfield(1,outwf)*1e-6; %ORIGINAL
% % %     Log current cost and number of evals
% %     cost(i) = fhandle(solver.position);
% %     evals(i) = solver.evaluations;
% 
% %     out = sum(outff(:))
%     
%     nexttile(3,[1,1])
%     plotWF(outwf); %<<<<<<<<<<<<<<<<<
%     pbaspect([1 1 1])
%     title("Output wavefront")
%     
%     nexttile(4,[1,1])
%     plotFF(outff); %<<<<<<<<<<<<<<<<
%     pbaspect([1 1 1])
%     title("Current farfield")
%     %subplot(3,2,5:6)
%     
%     nexttile(5,[1,2]);
%     plot(cost);
%     title("Performance");
%     xlabel("Evaluations");
%     ylabel("Cost");
%     txt = sprintf("est.Duration: %.2f min",solver.evaluations*dm_response/60);
%     text(0.6,0.85,txt,'Units','normalized','FontSize',14)
% 
% 
%     [xCentroid,yCentroid]= Centroid(outff);%NOT original
%     txt = sprintf("xCentroid: %.2f, yCentroid: %.2f",xCentroid,yCentroid);
%     text(0.0,-0.6,txt,'Units','normalized','FontSize',10)
%     
% 
% %     [ooesPercent,ooesCircDia]= oneOverESquared(outff);%Not original
% %     txt = sprintf("ooesPercent: %.2f, ooesCircDia: %.2f",ooesPercent,ooesCircDia);
% %     text(0.6,-0.6,txt,'Units','normalized','FontSize',10)
% %     
% 
%     [xD4S,yD4S,Major_axis_angle] = d4sigma(outff);%Not original
%     txt = sprintf("xD4S: %.2f, yD4S: %.2f, Major axis angle:%.2f ",xD4S,yD4S,Major_axis_angle);
%     text(0.0,-1,txt,'Units','normalized','FontSize',10)
%     
%     
%     diff1 = abs(xD4S - Parameter2);
%     
%     if diff1 <= (Parameter2 * 0.05)
%         Search2 = 0
%     else
%         Search2 = 1
%     end
% 
% 
% 
%     % mean_val = mean(outff(:));
%     % area=bwarea(bwareafilt(outff>100,4))
% 
% drawnow
% end



for i = 1:iterations
    
    solver2.step();
    v = solver2.position*100;
    mirror.set_channels(v);
    outwf = initwf + mirror.shape;
    outff = FF.generate_farfield(1,outwf)*1e-6;
    outff = BackgroundRemover(outff,5);

%     solver3.step();
%     v = solver3.position*100;
%     mirror.set_channels(v);
%     outwf = outwf + mirror.shape;
%     outff = FF.generate_farfield(1,outwf)*1e-6;
%     outff = BackgroundRemover(outff,5);

    cost(i) = fhandle2(solver2.position);
    evals(i) = solver2.evaluations;
    topvals = outff >= outff * 0.9;
    area= bwarea( bwareafilt(outff>topvals,1));

%     solver.step();
% %   Get voltages and plot wavefront & farfield
%     v = solver.position*100;
%     mirror.set_channels(v);
%     outwf = initwf + mirror.shape;
%     outff = FF.generate_farfield(1,outwf)*1e-6; %ORIGINAL
% %     Log current cost and number of evals
%     cost(i) = fhandle(solver.position);
%     evals(i) = solver.evaluations;

%     out = sum(outff(:))
    
    nexttile(3,[1,1])
    plotWF(outwf); %<<<<<<<<<<<<<<<<<
    pbaspect([1 1 1])
    title("Output wavefront")
    
    nexttile(4,[1,1])
    plotFF(outff); %<<<<<<<<<<<<<<<<
    pbaspect([1 1 1])
    title("Current farfield")
    %subplot(3,2,5:6)
    
    nexttile(5,[1,2]);
    plot(cost);
    title("Performance");
    xlabel("Evaluations");
    ylabel("Cost");
    txt = sprintf("est.Duration: %.2f min",solver.evaluations*dm_response/60);
    text(0.6,0.85,txt,'Units','normalized','FontSize',14)


    [xCentroid,yCentroid]= Centroid(outff);%NOT original
    txt = sprintf("xCentroid: %.2f, yCentroid: %.2f",xCentroid,yCentroid);
    text(0.0,-0.6,txt,'Units','normalized','FontSize',10)
    

    [xD4S,yD4S,Major_axis_angle] = d4sigma(outff);%Not original
    txt = sprintf("xD4S: %.2f, yD4S: %.2f, Major axis angle:%.2f ",xD4S,yD4S,Major_axis_angle);
    text(0.0,-1,txt,'Units','normalized','FontSize',10)
    
drawnow
end


function CorrectedFF = BackgroundRemover(FF,Border)%Takes the mean value from a ring of pizels from the border(Width Border) 
                                              %and minus's that from the whole image to remove noise
siz  = size(FF);
mask = false(siz(1), siz(2));
mask(1:Border, :) = true;
mask(:, 1:Border) = true;
mask(siz(1)-Border+1:siz(1), :) = true;
mask(:, siz(2)-Border+1:siz(2)) = true;
meanBorder = mean(FF(mask));
CorrectedFF = FF - meanBorder;

% Test = CorrectedFF <= 1;%Values less than 1 = 0
% CorrectedFF(Test) = 0;

end

function error = Errorfunct(FarF,want) %Function to calculate the cost which is the fifference between what you want and what you have
[xD4S,~,~] = d4sigma(FarF);
have = xD4S; %Set the parameter to meet here
error = abs(want - have);
end

function error = Errorfunct2(FarF,want) %Second error to correct
[~,yD4S,~] = d4sigma(FarF);
have = yD4S; %Set the parameter to meet here
error = abs(want - have);
end
% need to check if yd4S is correct and switch back

%Used for the correction of wavefront making it a circle
function cost = cost_function(pos,wf,mirror,FF)
% Returns FF Quality metric from solver position
    v = pos*100; % Solver coord space -> voltage space
    mirror.set_channels(v);
    outwf = wf + mirror.shape;
    ff = FF.generate_farfield(1,outwf)*1e-6;
    ff = medfilt2(ff,[3 3]); % Filter to reduce noise
    maxI = max(ff,[],'all');
    cost = -maxI; %ORIGINAL
    % cost = sqrt(sum(outwf(:).^2)/numel(outwf)); % For debuging.
    drawnow
end

% Used to make WF a line focus
function cost = cost_function2(pos,wf,mirror,FF,Parameter2)
% Returns FF Quality metric from solver position
    v = pos*100; % Solver coord space -> voltage space
    mirror.set_channels(v);
    outwf = wf + mirror.shape;
    ff = FF.generate_farfield(1,outwf)*1e-6;
    ff = BackgroundRemover(ff,3);
    cost = Errorfunct(ff,Parameter2); %Set what you are aiming for here

    drawnow
end

function cost = cost_function3(pos,wf,mirror,FF,Parameter3)
% Returns FF Quality metric from solver position
    v = pos*100; % Solver coord space -> voltage space
    mirror.set_channels(v);
    outwf = wf + mirror.shape;
    ff = FF.generate_farfield(1,outwf)*1e-6;
    ff = BackgroundRemover(ff,3);
    cost = Errorfunct2(ff,Parameter3); %Set what you are aiming for here
    
    drawnow
end

function plotWF(wf)
% Plots wavefront
    surf(wf)
    shading interp
    colormap jet
    zlim([-5 5])
    caxis([-5,5]);
end

function plotFF(ff)
% Plots farfield image
    imagesc(ff)
    colormap jet
    colorbar
end
