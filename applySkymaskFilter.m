function [filteredSatPositions, filteredPseudoranges, filteredCNo, usedSatIdx] = ...
    applySkymaskFilter(satPositions, pseudoranges, CNo, azimuths, elevations, skymaskCSV)
% applySkymaskFilter filters out NLOS satellites based on a skymask.
%
% Inputs:
% - satPositions    : [3 x N] satellite ECEF positions
% - pseudoranges    : [1 x N] corrected pseudoranges
% - CNo             : [1 x N] carrier-to-noise ratios in dB-Hz
% - azimuths        : [1 x N] satellite azimuth angles (in degrees)
% - elevations      : [1 x N] satellite elevation angles (in degrees)
% - skymaskCSV      : filename of skymask CSV file (e.g. 'skymask_A1_urban.csv')
%
% Outputs:
% - filteredSatPositions : [3 x M] satellites after skymask filtering
% - filteredPseudoranges : [1 x M]
% - filteredCNo          : [1 x M]
% - usedSatIdx           : indices of satellites used

% --- Load and process the skymask file ---
raw = readcell(skymaskCSV);
azVals = round(str2double(raw(2:end, 1)));
elVals = str2double(raw(2:end, 2));

% Filter out invalid (NaN or out-of-bounds) entries
validIdx = ~isnan(azVals) & ~isnan(elVals) & azVals >= 0 & azVals < 360;
azVals = azVals(validIdx);
elVals = elVals(validIdx);

% Initialize lookup table
mask = zeros(1, 360);
for i = 1:length(azVals)
    azIdx = round(mod(azVals(i), 360)) + 1;  % Ensure index in 1–360
    mask(azIdx) = elVals(i);
end

% --- Filter satellites using azimuth/elevation vs skymask ---
usedSatIdx = [];
N = length(azimuths);
for i = 1:N
    azIdx = round(mod(azimuths(i), 360)) + 1;  % Ensure index in 1–360
    minElevation = mask(azIdx);

    if elevations(i) >= minElevation
        usedSatIdx(end+1) = i;
    end
end

% --- Ensure sufficient satellites remain ---
if length(usedSatIdx) < 4
    error('Not enough satellites remain after skymask filtering.');
end

% --- Apply the filter ---
filteredSatPositions = satPositions(:, usedSatIdx);
filteredPseudoranges = pseudoranges(usedSatIdx);
filteredCNo = CNo(usedSatIdx);

end
