function [ ASI ] = artificial_surface_index( Img, fillV, MaskValid, Scale )
%artificial_surface_index
% This function is to calculate Artificial Surface Index (ASI) based on Landsat surface reflecance imagery.
% Developed by Yongquan Zhao, University of Connecticut, Storrs, 10/18/2021.
% Reference: Yongquan Zhao, Zhe Zhu. 2022. ASI: An artificial surface Index for Landsat 8 imagery. International Journal of Applied Earth Observation and Geoinformation 107: 102703.
%
% Inputs:
%    Img:        The Landsat surface reflectance image.
%    fillV:      The fill value for outliers.
%    MaskValid:  The mask of valid observations.
%    Scale:      The scale factor.
%
% Outputs:
%    ASI:        The calculated ASI image with the data value range of [0, 1](higher values mean more artificial surfaces).

%%%%% Extract spectral bands.
Blue  = Img(:,:,1); 
Grn   = Img(:,:,2);
Red   = Img(:,:,3);
NIR   = Img(:,:,4);
SWIR1 = Img(:,:,5);
SWIR2 = Img(:,:,6);


%%%%% Artificial surface Factor (AF).
AF = ( NIR - Blue) ./ ( NIR + Blue);
[ AF ] = HistCut( AF, fillV, 6, [-1 1]);
[ AF_Norm ] = MinMaxNorm( AF, MaskValid );


%%%%% Vegetation Suppressing Factor (VSF).
NDVI = (NIR - Red) ./ (NIR + Red);
[ NDVI ] = HistCut( NDVI, fillV, 6, [-1 1]);
MSAVI = ( 2*NIR+Scale - sqrt((2*NIR+Scale).^2 - 8*(NIR-Red)) ) / 2;
[ MSAVI ] = HistCut( MSAVI, fillV, 6, [-1 1]);
VegIdx= MSAVI .* NDVI; 
VSF = 1 - VegIdx;
[ VSF_Norm ] = MinMaxNorm( VSF, MaskValid ); 


%%%%%  Soil Suppressing Factor (SSF).
%%% Derive the Modified Bare soil Index (MBI).
MBI = (SWIR1 - SWIR2 - NIR) ./ (SWIR1 + SWIR2 + NIR) + 0.5; 
[ MBI ] = HistCut( MBI, fillV, 6, [-0.5 1.5]);
%%% Deriving Enhanced-MBI based on MBI and MNDWI.
MNDWI = (Grn - SWIR1) ./ (Grn + SWIR1);
[ MNDWI ] = HistCut( MNDWI, fillV, 6, [-1 1]);
EMBI = ((MBI+0.5) - (MNDWI+1)) ./ ((MBI+0.5) + (MNDWI+1)); % Enhanced Modified Bare soil Index, EMBI.
[ EMBI ] = HistCut( EMBI, fillV, 6, [-1 1]);
%%% Derive SSF.
SSF = 1-EMBI;
[ SSF_Norm ] = MinMaxNorm( SSF, MaskValid );


%%%%% Modulation Factor (MF).
MF = (Blue+Grn - NIR-SWIR1) ./ (Blue+Grn + NIR+SWIR1); 
[ MF ] = HistCut( MF, fillV, 6, [-1 1]);
[ MF_Norm ] = MinMaxNorm( MF, MaskValid );


%%%%% Derive ASI.
ASI = AF_Norm .* VSF_Norm .* SSF_Norm .* MF_Norm; 
[ ASI ] = HistCut( ASI, fillV, 6, [0 1]);

end

