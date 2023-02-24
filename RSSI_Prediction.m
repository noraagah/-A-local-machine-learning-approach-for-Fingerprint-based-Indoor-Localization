%File Name: RSSI_Prediction
%Description: This function gives the estimate of RSSIs for a cell phone 
%at a series of given locations. This function then passes this data to the
%WAP_Locating function which finds the location in which the each RSSI
%strength is the strongest and estimates that location as the location of
%the WAP
%Inputs: Training data, Matrix of all the locations to predict RSSIs for,
%with the columns being longitude, latitude, and floor
%Outputs: Matrix of predictions of RSSIs for the different locations with
%each row being RSSI predicitons for a different location with the
%location matrix concatened as the last three columns being longitude,
%latitude, and floor
%First created: 3/2/22
%Last Modified: 3/6/22
%File Created By: Nora Agah



%This function gives rssi estimates for each location using the function in
%the paper
% For RSSI_Data Column 313-longitude, 314-latitude, 315-Floor, 316-Building
%For Location matrix, each location is a row with longitude, latitude and
%floor as the columns


function [RSSI_Predictions] = RSSI_Prediction(RSSI_Data, Location_Matrix)

    N = size(RSSI_Data.location_train_df, 1);

    %Silverman's rule of thumb, use cross validation bandwidth
    ha = 1.06 * std(RSSI_Data.location_train_df(:, 313)) * N^(-1/6);
    ho = 1.06 * std(RSSI_Data.location_train_df(:, 314)) * N^(-1/6);

    Num_Locs = size(Location_Matrix, 1);
    %Subtract 4 becuase we just want the number of WAPs
    Num_RSSIs = size(RSSI_Data.location_train_df, 2) - 4;
    RSSI_Predictions = ones(Num_Locs, Num_RSSIs);

    for k = 1:Num_RSSIs

        %This is just for 1 RSSI and each location
        for j = 1:Num_Locs
    
            top = 0;
            bottom = 0;
        
            %Sum for all of the samples
            for i = 1:N
        
                %Gaussian kernel of longitude and latitude values
                na = normpdf((RSSI_Data.location_train_df(i, 313)-Location_Matrix(j, 1))/ha);
                no = normpdf((RSSI_Data.location_train_df(i, 314)-Location_Matrix(j, 2))/ho);
        
                %Indicator function for the floor, if the floor is the same count
                %the data point
                Indic = (RSSI_Data.location_train_df(i, 315) == Location_Matrix(j, 3));
        
                %Multiply the appropriate values, then sum for all of the
                %samples, divide 
                top = top + RSSI_Data.location_train_df(i, k)*na*no*Indic;
                bottom = bottom + na*no*Indic;
            end
       
            RSSI_Predictions(j, k) = (top/bottom);
    
        end
    end
   
    RSSI_Predictions = [RSSI_Predictions Location_Matrix];
end