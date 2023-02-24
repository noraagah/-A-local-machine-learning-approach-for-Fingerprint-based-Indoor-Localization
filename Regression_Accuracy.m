%File Name: Regression_Accuracy
%Description: This function returns metrics representing the accuracy
%of the regression data using Euclidean Distance
%Inputs: The predicted values longitude and latitude matrix and the true 
%longitude and latitude values matrix
%Outputs: The mean, median, standard devation, and min and max values of the 
%Euclidean distances, along with a vector containing the quartiles of the distances
%First created: 9/25/21
%Last Modified: 9/30/21
%File Created By: Nora Agah

function [Mean, Median, STD, Min, Max, Quartiles] = Regression_Accuracy(Predicted_Values, True_Values)
    
    %Find the Euclidean Distances between the predicted and true values
    D1 = (Predicted_Values(:, 1)-True_Values(:, 1)).^2;
    D2 = (Predicted_Values(:, 2)-True_Values(:, 2)).^2;
    D = sqrt(D1+D2);
    
    
    Quartiles = zeros(3, 1);
    %Calculate the mean, median, standard deviation, min, max, and
    %quartiles of the distances
    Mean = mean(D);
    Median = median(D);
    STD = std(D);
    Min = min(D);
    Max = max(D);
    Quartiles(1) = prctile(D.',25);
    Quartiles(2) = prctile(D.',50);
    Quartiles(3) = prctile(D.',75);
end