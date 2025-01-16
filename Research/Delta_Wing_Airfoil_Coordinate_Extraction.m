%--------------------------------------------------------------------------
% Flow Physics and Control Lab
%
% Description: 
%    Delta wing airfoil coordinate extraction from a matlab coordinate
%    image found in the masters thesis "Dynamic Active Flow Control of 
%    the Roll Moment on a Generic UCAS Wing" by Xiaowei He
%
% Brandon Lim
% 1/15/2025
%--------------------------------------------------------------------------
clear, clc, close all

% Importing image 
Airfoil_Image = imread("Delta Wing Airfoil Coordinates.jpg");

% Calculating the size of the image
[M,N,~] = size(Airfoil_Image);

n = 1;
for i = 1:M
    for j = 1:N
        redVal = Airfoil_Image(i,j,1);
        greenVal = Airfoil_Image(i,j,2);
        blueVal = Airfoil_Image(i,j,3);
        colorMatrix{i,j} = [redVal, greenVal, blueVal];

        mathone = redVal/greenVal;
        mathtwo = redVal/blueVal;
        maththree = greenVal/blueVal;
        if (mathone < 1.01 || mathone > 0.99) && (mathtwo < 1.01 || mathtwo > 0.99) && (maththree < 1.01 || maththree > 0.99)
              colorMatrix{i,j} = 0;
        end
         % if (redVal >= 200 && redVal <= 255) && (greenVal >= 200 && greenVal <= 255) && (blueVal >= 200 && blueVal <= 255)
         %     colorMatrix{i,j} = 0;
         % end
         % 
         % if (redVal >= 0 && redVal <= 50) && (greenVal >= 0 && greenVal <= 50) && (blueVal >= 0 && blueVal <= 50)
         %     colorMatrix{i,j} = 4;
         % end
         % 
         % if (redVal >= 200 && redVal <= 255) && (greenVal >= 100 && greenVal <= 200) && (blueVal >= 0 && blueVal <= 100)
         %     colorMatrix{i,j} = 1;
         % end
         % 
         % if (redVal >= 0 && redVal <= 100) && (greenVal >= 150 && greenVal <= 255) && (blueVal >= 0 && blueVal <= 100)
         %     colorMatrix{i,j} = 2;
         % end
         % 
         % if (redVal >= 0 && redVal <= 100) && (greenVal >= 0 && greenVal <= 100) && (blueVal >= 150 && blueVal <= 255)
         %    colorMatrix{i,j} = 3;
         %    x(n) = i;
         %    y(n) = j;
         %    n = n+1;
         % end
    end
end

image(Airfoil_Image)
% 
% plot(x,y)