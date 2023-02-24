%File Name: Remove_Validation_Columns
%Original Python code: building2binarysearch_IV 
%Section: Remove columns with zero standard deviation in validation data set
%Description: This function removes columns with zero variation from the
%validation data
%Inputs: The validation data
%Outputs: The validation data with all columns with zero variation removed
%and the indices of all columns of the validation data with zero variation
%First created: 8/11/21
%Last Modified: 8/11/21
%File Created By: Nora Agah

function [nonzero_valid_df, zero_valid_var] = Remove_Validation_Columns(obj, cleaned_valid_df)
    
    %Create a data table with all columns of the cleaned validation data with a
    %zero standard deviation removed

    nonzero_valid_df = cleaned_valid_df(:, std(cleaned_valid_df,0,1) ~= 0);
 
    
    %Create a table with only the columns of the cleaned validation data
    %that have a standard deviation of zero
    %zero_valid_df  = cleaned_valid_df(:, std(cleaned_valid_df,0,1) == 0);

    %Return the indices of all columns with zero standard deviation
    zero_valid_var = find(std(cleaned_valid_df,0,1) == 0);
    
end