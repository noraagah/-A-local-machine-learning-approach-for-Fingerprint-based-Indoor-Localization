%File Name: WAP_Locating
%Description: This function aims to approximate the longitude, latitude,
%and floor of the WAPS using the locations of the strongest RSSI strengths
%Inputs:  The RSSI predictions for each location
%Outputs: Matrix containing the estimated locations of the WAPs, which each
%row being a prediction for a single WAP and each
%First created: 2/11/22
%Last Modified: 4/23/22
%File Created By: Nora Agah


function [WAP_Predictions] = WAP_Locating(RSSI_Predictions)
 
    %Each row is the estimate for the location of the WAP
    %The columns are longitude, latitude, and floor
     WAP_Predictions = ones(size(RSSI_Predictions(:, 1:312), 2), 4);
    
    %Get the indices for the maximum RSSI value for each WAP and predict
    %that location as the location of the WAP
    [M , Idx] = max(RSSI_Predictions(:, 1:312), [], 1);
    
    for i=1:size(RSSI_Predictions(:, 1:312), 2)

        WAP_Predictions(i, 1:4) = RSSI_Predictions(Idx(1, i), 313:316);

    end
end