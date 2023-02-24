%File Name: KNN_Data_Preprocessing
%Description: This method prepares the location and test data to be used in
%KNN by seperating the WAP signals from the rest of the data
%Inputs: The data object
%Outputs: knn_location_train_WAP and knn_location_test_WAP prepared to be
%used for KNN search
%First created: 9/3/21
%Last Modified: 9/3/21
%File Created By: Nora Agah

function  obj = KNN_Data_Preprocessing(obj)

    obj.location_train_WAP = obj.location_train_df(:, 1:312);
    obj.location_test_WAP = obj.location_test_df(:, 1:312);
    
end

