function main_ASI()
% An Artificial Surface Index (ASI) calculation demo - Yongquan Zhao, Zhe Zhu, University of Connecticut, Storrs.
% Reference: Yongquan Zhao, Zhe Zhu. 2022. ASI: An artificial surface Index for Landsat 8 imagery. International Journal of Applied Earth Observation and Geoinformation 107: 102703.
% Last revision date: February 09, 2021.
% 
% Inputs:
% InputImgName:  The file name of the input Landsat Collection 2 surface reflectance image.
% OutputAsiName: The file name of the output ASI image.

[InputImgName ] = textread('ASI_Path.txt', '%s', 1); % 1 is the number of reads. 
InputImgName = char(InputImgName); % cell to char.

[OutputAsiName ] = textread('ASI_Path.txt', '%s', 'headerlines',1); % 1 is the number of rows to skip.
OutputAsiName = char(OutputAsiName); % cell to char.

% Check to make sure we've found the input data.
if strcmp(InputImgName, '')
    error('Could not find the input image. \n');
end
if strcmp(OutputAsiName, '')
    fprintf('Could not find the output image.\n');
end

Scale = 10000; % Scale factor
fillV = 0.00000000e+000; % Fill value for outliers.

%% Read image.    
Img = freadenvi(InputImgName);
[filepath, name, ~] = fileparts(InputImgName); % Exclude file extensions.
info = read_envihdr(strcat(filepath, '\', name, '.hdr'));

%% Scaling Landat Collection 2 surface reflectance (not necessary for Landsat Collection 1 surface reflectance products).
[ Img, MaskValid ] = LandsatC2Scale( Img, Scale );

%% Calculating ASI.
[ ASI ] = artificial_surface_index( Img, fillV, MaskValid, Scale );

%% Get valid land mask.
Grn   = Img(:,:,2);
SWIR1 = Img(:,:,5);
MNDWI = (Grn - SWIR1) ./ (Grn + SWIR1);
[ MNDWI ] = HistCut( MNDWI, fillV, 6, [-1 1]);
Water_Thresh  = 0; % Water threshold for MNDWI (may need to be adjusted for different study areas).
MaskLand = (MNDWI < Water_Thresh) .* MaskValid;

%% Write ASI.
rs_imwrite_bands(ASI .* MaskLand, OutputAsiName, info, 'ASI', fillV);

end

