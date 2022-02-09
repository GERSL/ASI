function [ Img_Norm ] = MinMaxNorm( Img, MaskValid )
%HistCut 
% This function is to conduct minimum-maximum normalization for a image.
% Developed by Yongquan Zhao, University of Connecticut, Storrs, 10/07/2021.
%
% Inputs:
%    Img:        The input image.
%    MaskValid:  The valid value mask (1 means valid, 0 means invalid);
%
% Outputs:
%    Img_Norm:   The normalized image has the value range of [0, 1];

[H, W, BandNum] = size(Img);

Img_Norm = Img;

MinVal = zeros(1,BandNum);
MaxVal = zeros(1,BandNum);

%% Normalization with checking the valid mask.
[RowInd, ColInd] = find(MaskValid);
ValidNum = size(RowInd, 1);

ValidImg = zeros(ValidNum, BandNum);

if ValidNum ~= 0
    for iband=1:BandNum
        for i = 1:ValidNum
            ValidImg(i, iband) = Img(RowInd(i) , ColInd(i), iband);
        end
    end
    
    for iband=1:BandNum
        MinVal(iband) = min(ValidImg(:,iband));
        MaxVal(iband) = max(ValidImg(:,iband));
        
        if (MaxVal(iband)-MinVal(iband) ~= 0)
            Img_Norm(:,:,iband) = (Img(:,:,iband) - MinVal(iband)) ./ (MaxVal(iband)-MinVal(iband)); % zero values (fill values) will be normalized as well.
            Img_Norm(:,:,iband) = Img_Norm(:,:,iband) .* MaskValid; % Mask normalized fill values.
        end
    end
end


end

