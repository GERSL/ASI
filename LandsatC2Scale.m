function [ ScaleImg, MaskValid ] = LandsatC2Scale( Img, Scale )
%LandsatC2Scale
% This function is to rescale the value range of Landsat Collection 2 surface reflecance to [0, Scale].
% Developed by Yongquan Zhao, University of Connecticut, Storrs, 10/07/2021.
%
% Inputs:
%    Img:        The Landsat Collection 2 surface reflectance image.
%    Scale:      The scale factor.
%
% Outputs:
%    ScaleImg:   The rescaled surface reflectance image with the value range of [0, Scale];
%    MaskValid:  The mask of valid observations (1 means valid, 0 means invalid).


ScaleImg = (Img(:,:,1:6)*0.0000275 - 0.2) * Scale;

MaskValid = ScaleImg(:,:,1)>0 & ScaleImg(:,:,1)<Scale&...
    ScaleImg(:,:,2)>0 & ScaleImg(:,:,2)<Scale&...
    ScaleImg(:,:,3)>0 & ScaleImg(:,:,3)<Scale&...
    ScaleImg(:,:,4)>0 & ScaleImg(:,:,4)<Scale&...
    ScaleImg(:,:,5)>0 & ScaleImg(:,:,5)<Scale&...
    ScaleImg(:,:,6)>0 & ScaleImg(:,:,6)<Scale;

end

