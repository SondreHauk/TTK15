
function speed = underwaterSoundSpeed(temp, sal, depth, pressure, method)
%UNDERWATERSOUNDSPEED Calculate sound speed in seawater.
%
% Inputs:
%   temp     - Temperature [deg C]
%   sal      - Salinity [ppt]
%   depth    - Depth [m], used by Leroy
%   pressure - Measured pressure [dBar], used by Chen-Millero
%   method   - "leroy" or "chen-millero"
%
% Output:
%   speed    - Sound velocity [m/s]

    arguments
        temp
        sal
        depth
        pressure
        method (1,1) string
    end

    switch lower(method)

        case "leroy"
            % Leroy empirical formula (1969)
            speed = 1492.9 ...
                + 3 * (temp - 10) ...
                - 6e-3 * (temp - 10).^2 ...
                - 4e-2 * (temp - 18).^2 ...
                + 1.2 * (sal - 35) ...
                - 1e-2 * (temp - 18) .* (sal - 35) ...
                + depth / 61;

        case "chen-millero"
            % Chen-Millero equation
            % Pressure is supplied directly in bar.
            P = pressure ./ 10;

            % Pure-water sound speed coefficients
            C00 = 1402.388;
            C01 = 5.03830;
            C02 = -5.81090e-2;
            C03 = 3.3432e-4;
            C04 = -1.47797e-6;
            C05 = 3.1419e-9;

            C10 = 0.153563;
            C11 = 6.8999e-4;
            C12 = -8.1829e-6;
            C13 = 1.3632e-7;
            C14 = -6.1260e-10;

            C20 = 3.1260e-5;
            C21 = -1.7111e-6;
            C22 = 2.5986e-8;
            C23 = -2.5353e-10;
            C24 = 1.0415e-12;

            C30 = -9.7729e-9;
            C31 = 3.8513e-10;
            C32 = -2.3654e-12;

            % Salinity coefficients A(T,P)
            A00 = 1.389;
            A01 = -1.262e-2;
            A02 = 7.166e-5;
            A03 = 2.008e-6;
            A04 = -3.21e-8;

            A10 = 9.4742e-5;
            A11 = -1.2583e-5;
            A12 = -6.4928e-8;
            A13 = 1.0515e-8;
            A14 = -2.0142e-10;

            A20 = -3.9064e-7;
            A21 = 9.1061e-9;
            A22 = -1.6009e-10;
            A23 = 7.994e-12;

            A30 = 1.100e-10;
            A31 = 6.651e-12;
            A32 = -3.391e-13;

            % Salinity coefficients B(T,P)
            B00 = -1.922e-2;
            B01 = -4.42e-5;
            B10 = 7.3637e-5;
            B11 = 1.7950e-7;

            % Salinity coefficients D(T,P)
            D00 = 1.727e-3;
            D10 = -7.9836e-6;

            % Pure-water sound speed Cw(T,P)
            Cw = C00 + C01.*temp + C02.*temp.^2 ...
               + C03.*temp.^3 + C04.*temp.^4 + C05.*temp.^5 ...
               + (C10 + C11.*temp + C12.*temp.^2 ...
               + C13.*temp.^3 + C14.*temp.^4).*P ...
               + (C20 + C21.*temp + C22.*temp.^2 ...
               + C23.*temp.^3 + C24.*temp.^4).*P.^2 ...
               + (C30 + C31.*temp + C32.*temp.^2).*P.^3;

            % Coefficient A(T,P)
            A = A00 + A01.*temp + A02.*temp.^2 ...
              + A03.*temp.^3 + A04.*temp.^4 ...
              + (A10 + A11.*temp + A12.*temp.^2 ...
              + A13.*temp.^3 + A14.*temp.^4).*P ...
              + (A20 + A21.*temp + A22.*temp.^2 ...
              + A23.*temp.^3).*P.^2 ...
              + (A30 + A31.*temp + A32.*temp.^2).*P.^3;

            % Coefficients B(T,P) and D(T,P)
            B = B00 + B01.*temp + (B10 + B11.*temp).*P;
            D = D00 + D10.*P;

            % Final Chen-Millero equation
            speed = Cw + A.*sal + B.*sal.^(3/2) + D.*sal.^2;

        otherwise
            error('Unknown method "%s". Use "leroy" or "chen-millero".', ...
                  method);
    end
end
