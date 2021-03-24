% Use CTRL+C in command window to stop simulation

resolution  = 100;  % Resolution of all surfaces
orders      = 36;   % Aberration orders
channels    = 36;   % Number of mirror channels
crop_amount = 10;   % Amount to remove from polys
iterations  = 42;   % Optimisation Iterations
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
initwf = coeff_surface(coeffs,polys);
initff = FF.generate_farfield(1,initwf)*1e-6;


% Create solver object to solve objective function
fhandle = @(r) cost_function(r,initwf,mirror,FF);
solver = pattern_search(channels,fhandle); % Chose one from optimisation algorithms folder
%solver.settings(0.01,0.1,0.1,0);

fig = figure(1);
axis tight manual
fig.Position = [35 0 706 871];
tiledlayout(4,2,'TileSpacing','compact')

nexttile(1,[1 1])
plotWF(initwf);
title("Input wavefront")

nexttile(2,[1,1])
plotFF(initff);
title("Initial farfield")

% Prealocating cost and evaluation arrays
cost = nan(iterations,1);
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
    outff = FF.generate_farfield(1,outwf)*1e-6;
    
    % Log current cost and number of evals
    cost(i) = fhandle(solver.position);
    evals(i) = solver.evaluations;
    
    nexttile(3,[1,1])
    plotWF(outwf);
    title("Output wavefront")
    
    nexttile(4,[1,1])
    plotFF(outff);
    title("Current farfield")
    %subplot(3,2,5:6)
    
    nexttile(5,[1,2]);
    plot(cost);
    title("Performance");
    xlabel("Evaluations");
    ylabel("Cost");
    txt = sprintf("est.Duration: %.2f min",solver.evaluations*dm_response/60);
    text(0.6,0.85,txt,'Units','normalized','FontSize',14)

    [xCentroid,yCentroid]= Centroid(outff);
    txt = sprintf("xCentroid: %.2f, yCentroid: %.2f",xCentroid,yCentroid);
    text(0.0,-0.6,txt,'Units','normalized','FontSize',10)
    
    [ooesPercent,ooesCircDia]= oneOverESquared(outff);
    txt = sprintf("ooesPercent: %.2f, ooesCircDia: %.2f",ooesPercent,ooesCircDia);
    text(0.6,-0.6,txt,'Units','normalized','FontSize',10)
    
    [xD4S,yD4S,Major_axis_angle] = d4sigma(outff);
    txt = sprintf("xD4S: %.2f, yD4S: %.2f, Major axis angle:%.2f ",xD4S,yD4S,Major_axis_angle);
    text(0.0,-1,txt,'Units','normalized','FontSize',10)
    
    drawnow
end

function cost = cost_function(pos,wf,mirror,FF)
% Returns FF Quality metric from solver position
    v = pos*100; % Solver coord space -> voltage space
    mirror.set_channels(v);
    outwf = wf + mirror.shape;
    ff = FF.generate_farfield(1,outwf)*1e-6;
    ff = medfilt2(ff,[3 3]); % Filter to reduce noise
    maxI = max(ff,[],'all');
    % cost = -maxI; % Original
    
    % Converges on the value of cost that you want.
     [ooesPercent,ooesCircDiam]= oneOverESquared(ff);
    cost = ooesCircDiam
    want = 11;
    Test = round(cost,1);
    
    if Test == want
        return
    elseif Test > want
        cost = cost;
    elseif Test < want
        cost = - cost;
        if cost < -want
            cost = -cost;
        end
    end
    
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
