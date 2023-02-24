%File Name: RSSI_Prediction_One_Location
%Description: This function gives the estimate of RSSIs for a cell phone 
%at a series of given locations. This function then passes this data to the
%WAP_Locating function which finds the location in which the each RSSI
%strength is the strongest and estimates that location as the location of
%the WAP
%Inputs: Training data, Matrix of all the locations to predict RSSIs for,
%with the columns being longitude, latitude, floor, and building
%Outputs: Matrix of predictions of RSSIs for the different locations with
%each row being RSSI predicitons for a different location
%First created: 2/25/22
%Last Modified: 3/2/22
%File Created By: Nora Agah



%This function gives rssi estimates for each location using the function in
%the paper
% For RSSI_Data Column 313-longitude, 314-latitude, 315-Floor, 316-Building
%For Location matrix, each location is a row with longitude, latitude and
%floor as the columns

%This file is just for me to practice by estimating for just 1 theta r (for the rth ap, for example the 1st)

function [RSSI_Prediction] = RSSI_Prediction_One_Location(RSSI_Data, Location_Matrix)

    N = size(RSSI_Data.location_train_df, 1);

    %Silverman's rule of thumb, use cross validation bandwidth
    ha = 1.06 * std(RSSI_Data.location_train_df(:, 313)) * N^(-1/6);
    ho = 1.06 * std(RSSI_Data.location_train_df(:, 314)) * N^(-1/6);

    top = 0;
    bottom = 0;

    %Sum for all of the samples
    for i = 1:N

        %Gaussian kernel of longitude and latitude values
        na = normpdf((RSSI_Data.location_train_df(i, 313)-Location_Matrix(1, 1))/ha);
        no = normpdf((RSSI_Data.location_train_df(i, 314)-Location_Matrix(1, 2))/ho);

        %Indicator function for the floor, if the floor is the same count
        %the data point
        Indic = (RSSI_Data.location_train_df(i, 315) == Location_Matrix(1, 3));

        %Multiply the appropriate values, then sum for all of the
        %samples, divide 
        top = top + RSSI_Data.location_train_df(i, 1)*na*no*Indic;
        bottom = bottom + na*no*Indic;
    end

    RSSI_Prediction = [(top/bottom) Location_Matrix];

end