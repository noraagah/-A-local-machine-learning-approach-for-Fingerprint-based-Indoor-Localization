%File Name: Classification_Accuracy
%Description: This function returns an accuracy value that represents 
%how many accurate classifications were made out of the total number 
%of classifications 
%Inputs: The predicted values vector and the true values vector
%Outputs: An accuracy percentage
%First created: 9/25/21
%Last Modified: 9/30/21
%File Created By: Nora Agah

function [Accuracy] = Classification_Accuracy(Predicted_Values, True_Values)

%XNOR the two data sets to get the accurate predictions (will get a matrix
%of ones and zeros)

%C = xor(Predicted_Values, True_Values)
%C = ~C;


C = (Predicted_Values== True_Values);

%Sum number of ones and divide by the size of one of the data sets



Accuracy = sum(C) / size(Predicted_Values, 1);

end