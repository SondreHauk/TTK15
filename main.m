clear;
ctdFile = 'data/CTD/CC1437011_20261015_123037.mat';
load(ctdFile);

%% ------------ PLOT CTD ------------ %%
plotCtd(Depth, Temperature, Conductivity, Salinity, Sound_velocity, false);

%% ------------ CALCULATE SOUND SPEEDS ------------ %%
Sound_velocity_CHENMILLERO = underwaterSoundSpeed(Temperature, Salinity, [], Pressure, "chen-millero");
Sound_velovity_LEROY = underwaterSoundSpeed(Temperature, Salinity, Depth, [], "leroy");

%% ------------ PLOT SOUND SPEEDS ------------ %%
figure;
plot(Sound_velocity, Depth, 'b');
hold on;
plot(Sound_velocity_CHENMILLERO, Depth, 'g', 'LineStyle','--');
plot(Sound_velovity_LEROY, Depth, 'r');
set(gca, 'YDir', 'reverse');
legend('CTD', 'Chen-Millero', 'Leroy');

%% ------------ 3D GRID: Load all values ------------ %%
clear;
files = dir("data/CTD/*.mat");
N = numel(files);
param = 'Sound_velocity';   %'Temperature', 'Salinity' or 'Sound_velocity' 

lonStations = zeros(numel(files), 1);
latStations = zeros(numel(files), 1);

for k = 1:N
    D = load(fullfile(files(k).folder, files(k).name));
    lonStations(k) = D.LongitudeStart;
    latStations(k) = D.LatitudeStart;
end

% Common reference position
lonRef = mean(lonStations);
latRef = mean(latStations);

xCTD = []; yCTD = []; zCTD = [];
xAll = []; yAll = []; zAll = [];
pAll = [];

for k = 1:N
    D = load(fullfile(files(k).folder, files(k).name));

    lon0 = D.LongitudeStart;
    lat0 = D.LatitudeStart;

    z = D.Depth(:);
    p = D.(param)(:);
    n = numel(z);

    x0 = (lon0 - lonRef) * 111320 * cosd(latRef);
    y0 = (lat0 - latRef) * 110540;

    xCTD = [xCTD; x0]; 
    yCTD = [yCTD; y0];
    zCTD = [zCTD; max(z)];
    
    xAll = [xAll; repmat(x0, n, 1)];
    yAll = [yAll; repmat(y0, n, 1)];
    zAll = [zAll; z];
    pAll = [pAll; p];
end

clear x0 y0 z T lat0 lon0 lonRef latRef lonStations latStations;

%% ------------ 3D GRID: Create grid ------------ %%
% Define grid resolution (metres)
dx = 10;
dy = 10;
dz = 1;

xq = min(xAll):dx:max(xAll);
yq = min(yAll):dy:max(yAll);
zq = min(zAll):dz:max(zAll);

[Xq, Yq, Zq] = meshgrid(xq, yq, zq);

% Interpolate temperature
Tq = griddata(xAll, yAll, zAll, pAll, Xq, Yq, Zq, 'linear');

%% ------------ 3D GRID: Plot slice ------------ %%
figure;

slice(Xq, Yq, Zq, Tq, ...
      xCTD, yCTD, 5);

shading interp;
colorbar;
xlabel('x (m)');
ylabel('y (m)');
zlabel('Depth (m)');
title(['3D ' strrep(param, '_', ' ') ' distribution']);
set(gca, 'ZDir', 'reverse');
hold on;
for k = 1:(N)
    plot3([xCTD(k) xCTD(k)], ...
          [yCTD(k) yCTD(k)], ...
          [0 zCTD(k)], 'r-', 'LineWidth', 2);
end
hold off;

%% ------------ Sound ray tracing ------------ %%
clear;
ctdFile = 'data/CTD/CC1437011_20261015_123037.mat';
load(ctdFile);

s = 1;           % seconds
degRange = 10;    % range of angles
degStep  = 0.5;    % angle step size
degStart = -(degRange / 2);
nAngles  = degRange / degStep;
theta0 = zeros(nAngles,1);

for k = 1:(nAngles+1)
    theta0(k) = degStart + (k-1) * degStep;
end

[~, idx] = max(Depth);
zz = Depth(1:idx);
cc = Sound_velocity(1:idx);

% For testing
[zzTest, ccTest] = generateSoundProfile(100, 1, 20, 80, 'parabola', 'down', 1400,1450);
[x, z, t, d] = raytrace(0, 30, theta0 ,3 ,zz.',cc.',true);