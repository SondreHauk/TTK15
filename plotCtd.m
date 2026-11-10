function plotCtd(depth, temp, cond, sal, soundVel, fixedAxis)
    % Plots four graphs in a 2 x 2 grid
    % 1: depth VS temperature% 
    % 2: depth VS conductivity
    % 3: depth VS salininty
    % 4: depth VS sound velocity
    
    figure;
    title('Temperature, conductivity, salinity and sound velocity plotted against depth');
    subplot(2, 2, 1);
    plot(temp, depth);
    set(gca, 'YDir', 'reverse');
    if(fixedAxis); xlim([0 20]); end
    xlabel('temperature [°C]'); ylabel('depth [m]');
    
    subplot(2, 2, 2);
    plot(cond, depth);
    set(gca, 'YDir', 'reverse');
    if(fixedAxis); xlim([30000 40000]); end
    xlabel('conductivity [µS/cm]'); ylabel('depth [m]');
    
    subplot(2, 2, 3);
    plot(sal, depth);
    set(gca, 'YDir', 'reverse');
    if(fixedAxis); xlim([25 35]); end
    xlabel('salininty [‰]'); ylabel('depth [m]');
    
    subplot(2, 2, 4);
    plot(soundVel, depth);
    set(gca, 'YDir', 'reverse');
    if(fixedAxis); xlim([1450 1570]); end
    xlabel('sound velocity [m/s]');ylabel('depth [m]');
end