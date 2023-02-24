%File Name: Remove_Training_Columns
%Original Python code: building2binarysearch_IV 
%Section: Remove columns in the training data that correspond to 
%columns with zero standard deviation in validation data set
%Description: This function removes the columns in the training set that 
%correspond to the columns with zero variation from the validation data as
%well as removing all columns in the validation data that correspond to the
%columns in the training data with zero variation
%Inputs: The indices of the validation data columns with zero variation,
%the training data, and the validation data with zero variation columns
%removed
%Outputs: The training and test data
%First created: 8/12/21
%Last Modified: 8/12/21
%File Created By: Nora Agah

function obj = Remove_Training_Columns(obj, zero_valid_var, cleaned_train_df, nonzero_valid_df)
    
    %Remove the columns in the training data that correspond to the columns
    %in the validation data with zero variation
    location_train_df = cleaned_train_df;
    location_train_df(:, zero_valid_var) = [];

    %Return the indices of all training data columns with zero standard deviation
    zero_train_var = find(std(location_train_df,0,1) == 0);

    %Remove all columns with zero standard deviation from the training data
    location_train_df(:, zero_train_var) = [];
    obj.location_train_df = location_train_df;

    %Remove the columns in the validation data that correspond to the columns
    %in the training data with zero variation)
    location_test_df = nonzero_valid_df;
    location_test_df(:, zero_train_var) = [];
    obj.location_test_df = location_test_df;
    
end