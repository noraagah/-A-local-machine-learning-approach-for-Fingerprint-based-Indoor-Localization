%File Name: KNN_Prediction
%Description: This function performs KNN on the WAPs in the train data set and
%predicts the building, floor, longitude, and latitude of the samples in
%the test data set
%Inputs: The Data object, the number of neighbors to be calculated
%Outputs: Arrays containing the predicitons for building, floor, longitude,
%and latitude for the samples in the test set
%First created: 9/4/21
%Last Modified: 2/12/22
%File Created By: Nora Agah

function [KNN_Building_prediction, KNN_Floor_prediction, KNN_Longitude_prediction, KNN_Latitude_prediction] = KNN_Prediction(KNN_Data, numNeighbors)

        %Initialize prediction arrays
        KNN_Building_prediction = zeros(size(KNN_Data.location_test_WAP, 1), 1);
        KNN_Floor_prediction = zeros(size(KNN_Data.location_test_WAP, 1), 1);
        KNN_Longitude_prediction = zeros(size(KNN_Data.location_test_WAP, 1), 1);
        KNN_Latitude_prediction = zeros(size(KNN_Data.location_test_WAP, 1), 1);
        
        %Find the numNeighbors number of nearest neighbors in the training data
        %for each of the samples in the test set
        Idx = knnsearch(KNN_Data.location_train_WAP, KNN_Data.location_test_WAP, 'k', numNeighbors);

        for i = 1 : size(Idx, 1)
        %Perform KNN on the data set and return the indices of the numNeighbors
        %nearest neighbors

            Building_prediction_sum = 0;
            Floor_prediction_sum = 0;
            Longitude_prediction_sum = 0;
            Latitude_prediction_sum = 0;

            %Calculate the sum of the data used to predict from the 
            %nearest neighbors in the training set 
            for j = 1 : size(Idx, 2)
                Building_prediction_sum = Building_prediction_sum + KNN_Data.location_train_df(Idx(i, j), 316);
                Floor_prediction_sum = Floor_prediction_sum + KNN_Data.location_train_df(Idx(i, j), 315);
                Longitude_prediction_sum = Longitude_prediction_sum + KNN_Data.location_train_df(Idx(i, j), 313);
                Latitude_prediction_sum = Latitude_prediction_sum + KNN_Data.location_train_df(Idx(i, j), 314);
            end

            %Calculate average for each of the predictions and round building and
            %floor predicition to the nearest integer then append prediction to the
            %prediction arrays

            KNN_Building_prediction(i) = nearest(Building_prediction_sum / size(Idx, 2));

            KNN_Floor_prediction(i) = nearest(Floor_prediction_sum / size(Idx, 2));

            KNN_Longitude_prediction(i) = Longitude_prediction_sum / size(Idx, 2);

            KNN_Latitude_prediction(i) = Latitude_prediction_sum / size(Idx, 2);
       
        end
end