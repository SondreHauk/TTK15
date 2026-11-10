function [zz, cc] = generateSoundProfile(depth, step, zstart, zend, shape, direction, cMax, cMin)

    assert(zstart >= 0 && zend <= depth && zstart < zend, ...
        'Require 0 <= zstart < zend <= depth.');

    zz = (0:step:depth).';
    if zz(end) < depth
        zz = [zz; depth];
    end

    idx = zz >= zstart & zz <= zend;
    u = (zz(idx) - zstart) / (zend - zstart);

    switch lower(shape)
        case 'square'
            profile = ones(size(u));

        case 'triangle'
            profile = 1 - abs(2*u - 1);

        case 'parabola'
            profile = 4*u.*(1-u);

        case 'gaussian'
            sigma = 0.2;
            profile = exp(-0.5*((u-0.5)/sigma).^2);
            profile = profile / max(profile);

        otherwise
            error('Unknown shape. Use square, triangle, parabola or gaussian.');
    end

    switch lower(direction)
        case 'down'
            % Default: minimum speed, maximum inside the shape
            cc = cMin * ones(size(zz));
            cc(idx) = cMin + (cMax-cMin)*profile;
    
        case 'up'
            % Default: maximum speed, minimum inside the shape
            cc = cMax * ones(size(zz));
            cc(idx) = cMax - (cMax-cMin)*profile;
    
        otherwise
            error('Direction must be either up or down.');
    end

end