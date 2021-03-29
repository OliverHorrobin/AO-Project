% Use CTRL+C in command window to stop simulation


resolution  = 200;  % Resolution of all surfaces
orders      = 36;   % Aberration orders
channels    = 36;   % Number of mirror channels
crop_amount = 10;   % Amount to remove from polys
iterations  = 20;   % Optimisation Iterations
dm_response = 0.1;  % Mirror response time in sec

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
% initff = genGauss(30,30,200,200,100,100,250,140,0);% NOT ORIGINAL

% Create solver object to solve objective function
fhandle = @(r) cost_function(r,initwf,mirror,FF);
fhandle2 = @(r) cost_function2(r,initwf,mirror,FF);

% solver = coordinate_search(channels,fhandle); % Chose one from optimisation algorithms folder <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
solver = pattern_search(channels,fhandle);
solver2 = pattern_search(channels,fhandle2);%not original
% solver = adam_optimiser(channels,fhandle);
%solver.settings(0.01,0.1,0.1,0);

fig = figure(1);
axis tight manual
fig.Position = [35 0 706 871];
tiledlayout(4,2,'TileSpacing','compact')%Not original

nexttile(1,[1 1])
plotWF(initwf); %<<<<<<<<<<<<<<<<<
title("Input wavefront")

nexttile(2,[1,1])
plotFF(initff); %<<<<<<<<<<<<<<<<<
title("Initial farfield")

% Prealocating cost and evaluation arrays
cost = nan(iterations,1) %ORIGINAL
% cost = 22 %Not original
evals = nan(iterations,1);
ds1 = arrayDatastore(initwf)
data = read(ds1)
% Closed Loop

for i = 1:iterations
    
    solver.step();
    
    % Get voltages and plot wavefront & farfield
    v = solver.position*100;
    mirror.set_channels(v);
    outwf = initwf + mirror.shape;
    outff = FF.generate_farfield(1,outwf)*1e-6; %ORIGINAL
    
    % Log current cost and number of evals
    cost(i) = fhandle(solver.position);
    evals(i) = solver.evaluations;
    
    nexttile(3,[1,1])
    plotWF(outwf); %<<<<<<<<<<<<<<<<<
    title("Output wavefront")
    
    nexttile(4,[1,1])
    plotFF(outff); %<<<<<<<<<<<<<<<<
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
    

    [ooesPercent,ooesCircDia]= oneOverESquared(outff);%Not original
    txt = sprintf("ooesPercent: %.2f, ooesCircDia: %.2f",ooesPercent,ooesCircDia);
    text(0.6,-0.6,txt,'Units','normalized','FontSize',10)
    

    [xD4S,yD4S,Major_axis_angle] = d4sigma(outff);%Not original
    txt = sprintf("xD4S: %.2f, yD4S: %.2f, Major axis angle:%.2f ",xD4S,yD4S,Major_axis_angle);
    text(0.0,-1,txt,'Units','normalized','FontSize',10)
    
    drawnow
end

for i = iterations:(iterations*2) %not original
    
    solver2.step();
    
    % Get voltages and plot wavefront & farfield
    v = solver2.position*100;
    mirror.set_channels(v);
    outwf = initwf + mirror.shape;
    outff = FF.generate_farfield(1,outwf)*1e-6; %ORIGINAL
    
    % Log current cost and number of evals
    cost(i) = fhandle(solver2.position);
    evals(i) = solver2.evaluations;
    
    nexttile(3,[1,1])
    plotWF(outwf); %<<<<<<<<<<<<<<<<<
    title("Output wavefront")
    
    nexttile(4,[1,1])
    plotFF(outff); %<<<<<<<<<<<<<<<<
    title("Current farfield")
    %subplot(3,2,5:6)
    
    nexttile(5,[1,2]);
    plot(cost);
    title("Performance");
    xlabel("Evaluations");
    ylabel("Cost");
    txt = sprintf("est.Duration: %.2f min",solver2.evaluations*dm_response/60);
    text(0.6,0.85,txt,'Units','normalized','FontSize',14)


    [xCentroid,yCentroid]= Centroid(outff);%NOT original
    txt = sprintf("xCentroid: %.2f, yCentroid: %.2f",xCentroid,yCentroid);
    text(0.0,-0.6,txt,'Units','normalized','FontSize',10)
    

    [ooesPercent,ooesCircDia]= oneOverESquared(outff);%Not original
    txt = sprintf("ooesPercent: %.2f, ooesCircDia: %.2f",ooesPercent,ooesCircDia);
    text(0.6,-0.6,txt,'Units','normalized','FontSize',10)
    

    [xD4S,yD4S,Major_axis_angle] = d4sigma(outff);%Not original
    txt = sprintf("xD4S: %.2f, yD4S: %.2f, Major axis angle:%.2f ",xD4S,yD4S,Major_axis_angle);
    text(0.0,-1,txt,'Units','normalized','FontSize',10)
    
    drawnow
end


function error = Errorfunct(FarF,want) %Function to calculate the cost which is the fifference between what you want and what you have
[xD4S,yD4S,Major_axis_angle] = d4sigma(FarF);
[ooesPercent,ooesCircDia]= oneOverESquared(FarF);
have = Major_axis_angle; %Set the parameter to meet here
error = want - have;
    if error > 0
        error = error;
    else
        error = -error;%Used to keep the difference positive as the program tries to minamalise cost(error)
    end
end

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


function cost = cost_function2(pos,wf,mirror,FF)
% Returns FF Quality metric from solver position
    v = pos*100; % Solver coord space -> voltage space
    mirror.set_channels(v);
    outwf = wf + mirror.shape;
    ff = FF.generate_farfield(1,outwf)*1e-6;
    ff = medfilt2(ff,[3 3]); % Filter to reduce noise
    
    cost = Errorfunct(ff,60); %Set what you are aiming for here
    Test = round(cost,0)
%     if Test == 0
%         return
%     end
    % cost = sqrt(sum(outwf(:).^2)/numel(outwf)); % For debuging.
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

