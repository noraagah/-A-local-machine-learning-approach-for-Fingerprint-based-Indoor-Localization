%File Name: Change_WAP
%Original Python code: building2binarysearch_IV 
%Section: Change WAP 100 to -110
%Description: This function takes the validation data and replaces all
%instances of WAPs that were not detected by the device and replaces the
%100 with -105
%Inputs: The validation data
%Outputs: The validation data with WAP data that equalled 100 changed to
%-105
%First created: 8/12/21
%Last Modified: 8/12/21
%File Created By: Nora Agah

function location_test_df = Change_WAP(location_test_df)

    %Replace signal values of WAPs that have not been detected by the device
    location_test_df(location_test_df == 100) = -105;
    
end