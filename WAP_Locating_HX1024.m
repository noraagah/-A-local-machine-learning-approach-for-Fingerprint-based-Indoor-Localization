%File Name: WAP_Locating
%Description: This function aims to approximate the longitude, latitude,
%and floor of the WAPS using the locations of the strongest RSSI strengths
%Inputs:  The RSSI predictions for each location
%Outputs: Matrix containing the estimated locations of the WAPs, which each
%row being a prediction for a single WAP and each
%First created: 2/11/22
%Last Modified: 4/23/22
%File Created By: Nora Agah


function [WAP_Predictions] = WAP_Locating_HX1024(RSSI_Predictions)
 
    %Each row is the estimate for the location of the WAP
    %The columns are longitude, latitude, and floor
     WAP_Predictions = ones(size(RSSI_Predictions(:, 1:312), 2), 3);
    
    %Get the indices for the maximum RSSI value for each WAP and predict
    %that location as the location of the WAP

    %Idx = knnsearch(WAP_Predictions(:, 1:4), Image_Locations, 'k', Image_numNeighbors);
    k=1;

    [M , Idx] = maxk(RSSI_Predictions(:, 1:312),k,1);

    %[n,m]= size(RSSI_Predictions(:, 1:312));

    %Idx1 = find(RSSI_Predictions(:, 1:312) == M)';

   
    
    for i=1:size(RSSI_Predictions(:, 1:312), 2)


        WAP_Predictions(i, 1:2) = mean(RSSI_Predictions(Idx(:, i), 313:314),1);
        WAP_Predictions(i, 3) = mode(RSSI_Predictions(Idx(:, i), 315),1);
        %WAP_Predictions_var(i) = norm(RSSI_Predictions(Idx(:, i), 313:316)-WAP_Predictions(i, 1:4)) ;

    end
end