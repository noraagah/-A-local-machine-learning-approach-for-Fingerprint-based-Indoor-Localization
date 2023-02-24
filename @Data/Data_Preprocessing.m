%File Name: Data_Preprocessing
%Original Python code: building2binarysearch_IV 
%Section: Data Preprocessing
%Description: This function reads in the training and validation data and
%preprocesses it by removing uneccesary columns and replacing signal values
%of WAPs that have not been detected that are difficult to use
%Inputs: The training and validation data
%Outputs: The traning and validation data with unnecessary columns removed
%sets
%First created: 7/24/21
%Last Modified: 7/24/21
%File Created By: Nora Agah

function [cleaned_train_df, cleaned_valid_df] = Data_Preprocessing(obj, Train_Data, Valid_Data)

    %Import data set
    location_df = readtable(Train_Data);
    
    %Import validation data set
    validation_df = readtable(Valid_Data);
    
    %Remove USERID PHONEID TIMESTAMP variance columns
    cleaned_train_df = removevars(location_df,["USERID","PHONEID","TIMESTAMP","SPACEID","RELATIVEPOSITION"]);
    
    %Remove USERID PHONEID TIMESTAMP variance columns
    cleaned_valid_df =  removevars(validation_df,["USERID","PHONEID","TIMESTAMP","SPACEID","RELATIVEPOSITION"]);
    
    %Replace signal values of WAPs that have not been detected by the device
    cleaned_train_df = table2array(cleaned_train_df);
    
    cleaned_train_df(cleaned_train_df == 100) = -105;
    
    cleaned_valid_df = table2array(cleaned_valid_df);
    cleaned_valid_df(cleaned_valid_df == 100) = -105;
    
    
end