%File Name: CNN_Prediction_2
%Description: This function uses the RSSI Image information and
%neighborhood information in order to predict the location of the cell
%phones
%Inputs: The Data object, the RSSI image with neighborhoods matrix
%Outputs: Vectors containing the predicitons for floor, building, longitude,
%and latitude for the samples in the test set
%First created: 4/20/22
%Last Modified: 5/10/22
%File Created By: Nora Agah

function [CNN_Longitude_Prediction, CNN_Latitude_Prediction, CNN_Floor_Prediction] = CNN_Prediction_2(CNN_Data, Training_Image_Folder, Test_Image_Folder, Train_Observations, Test_Observations, numPoints)
    
    %Put data into appropriate form
    numIms = size(Training_Image_Folder, 1);
    A = arrayDatastore(Training_Image_Folder);
    for i = 2:numIms
        arrds = arrayDatastore(Training_Image_Folder);
        A = [A arrds];
    end

    data = combine(A);

    %Make response vector that has labels for all three buildings 
    %(that's why we need 3 copies)
    responses = zeros(3*size(Train_Observations, 1), 1);

    for i = 1:size(Train_Observations, 1)
        responses(3*(i-1)+1 : 3*(i-1)+3) = Train_Observations(i, 313);
    end

    flip(responses, 1);

    layers = [
            %The 1 indicates greyscale and the 5 is the number of floors
            image3dInputLayer([sqrt(numPoints) sqrt(numPoints) 5 1])
            convolution3dLayer(5,16,'Stride',4)
            reluLayer
            maxPooling3dLayer(2,'Stride',4)
            fullyConnectedLayer(10)
            softmaxLayer
            regressionLayer];
    lgraph = layerGraph(layers);
    figure
    plot(lgraph);
    options = trainingOptions('sgdm');
    convnet_Longitude = trainNetwork(data, responses, lgraph, options);

    %Train for latitude next
    for i = 1:size(Train_Observations, 1)
        responses(3*(i-1)+1 : 3*(i-1)+3)  = Train_Observations(i, 314);
    end

    flip(responses, 1);
                
%     layers = [
%           %The 1 indicates greyscale and the 5 is the number of floors
%           imageInputLayer([sqrt(numPoints) sqrt(numPoints) 5 1])
%           convolution3dLayer(5,20)
%           reluLayer
%           maxPooling3dLayer(2,'Stride',2)
%           fullyConnectedLayer(10)
%           softmaxLayer
%           regressionLayer];
%     lgraph = layerGraph(layers);
%     figure
%     plot(lgraph);
%     options = trainingOptions('sgdm');
    convnet_Latitude = trainNetwork(data, responses, lgraph, options);


    %Train for floor last
    for i = 1:size(Train_Observations, 1)
        responses(3*(i-1)+1 : 3*(i-1)+3) = Train_Observations(i, 315);
    end

    flip(responses, 1);
%                 
%     layers = [
%           %The 1 indicates greyscale and the 5 is the number of floors
%           imageInputLayer([sqrt(numPoints) sqrt(numPoints) 5 1])
%           convolution3dLayer(5,20)
%           reluLayer
%           maxPooling3dLayer(2,'Stride',2)
%           fullyConnectedLayer(10)
%           softmaxLayer
%           classificationLayer];
%        lgraph = layerGraph(layers);
%        figure
%        plot(lgraph);
%     options = trainingOptions('sgdm');
    convnet_Floor = trainNetwork(data, responses, lgraph, options);

    %Use the convnets to make predictions
end