function [ ImgCut ] = HistCut( Img, FillV, k, range)
%HistCut 
% This function is to remove outliers of a image based on its histogram.
% Developed by Yongquan Zhao, University of Connecticut, Storrs, 10/07/2021.
%
% Inputs:
%    Img:      The input image;
%    FillV:    The fill value;
%    k:        The range of histogram cut;
%    range:    A pre-defined valid data value range.
%
% Outputs:
%    ImgCut:   The image without outliers.


[H, W, BandNum] = size(Img);

if nargin == 3
    Mean = zeros(BandNum,1);
    StdDev = zeros(BandNum,1);
    for d = 1:BandNum
        Mean(d,:) = mean2(Img(:,:,d));
        StdDev(d,:) = std2(Img(:,:,d));
    end
    
    LowVal = Mean - k*StdDev;
    UpVal = Mean + k*StdDev;
elseif nargin == 4
    LowVal = range(1);
    UpVal = range(2);
end

ImgCut = Img;
for n=1:BandNum    
    for i=1:H
        for j=1:W
            if Img(i, j, n) <= LowVal(n, 1)
                ImgCut(i, j, n) = FillV; 
            end
            if Img(i, j, n) >= UpVal(n, 1)
                ImgCut(i, j, n) = FillV; 
            end
        end
    end
end

end

