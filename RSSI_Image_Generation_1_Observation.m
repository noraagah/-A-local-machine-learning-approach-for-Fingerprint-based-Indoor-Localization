%File Name: RSSI_Image_Generation
%Description: This function generates a "pixel style image" for the input RSSI readings from a single cell phone.
%To do this it takes in the discretized grid of points from
%all of the buildings and generates RSSI "pixel" values at those locations using K
%nearest neighbors by averaging the k nearest WAP's RSSI values recieved by
%the observations
%Inputs: The Data object, the number of neighbors, the locations of grid of points to be
%calculated for, the observation that we are constructing an image for
%Outputs: A matrix that contains the RSSI Image information for the input observation.
%The matrix contains the RSSI "pixel" value prediction for each grid point in each row with the
%locations of the points concatenated to the end of each row.
%First created: 4/17/22
%Last Modified: 4/23/22
%File Created By: Nora Agah

function [RSSI_Image_Matrix] = RSSI_Image_Generation(Observation, Image_Locations, Image_numNeighbors, WAP_Predictions)
    
        %Initialize the strength averages
        RSSI_Strength = ones(size(Image_Locations, 1), 1);
    
        %Find the numNeighbors number of nearest WAPS to the points in
        %the grid
        Idx = knnsearch(WAP_Predictions(:, 1:4), Image_Locations, 'k', Image_numNeighbors);

        for i = 1:size(Image_Locations, 1)

                RSSI_Strength(i, :) = mean(Observation(1, Idx(i)));
        end

        RSSI_Image_Matrix = [RSSI_Strength Image_Locations];
end