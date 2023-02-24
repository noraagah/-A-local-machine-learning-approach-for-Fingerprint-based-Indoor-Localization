
function [CNN_Floor_Prediction] = CNN_Floor_Prediction_1204(Floor_Train, Floor_Test)

    num = size(Floor_Train,2)-4;

    responses = categorical(Floor_Train(:,size(Floor_Train,2)-1));
   RSSI_train_data  = -105*ones(num,1,1,size(Floor_Train, 1));
   RSSI_test_data   = -105*ones(num,1,1,size(Floor_Test, 1));


    for i = 1:size(Floor_Train, 1)
        RSSI_train_data(:,1,1,i) = Floor_Train(i,1:num)'; 
    end

%     for i = 1:size(Floor_Train2, 1)
%         RSSI_train2_data(:,1,1,i) = Floor_Train2(i,2:num)'; 
%     end

    for i = 1:size(Floor_Test, 1)
        RSSI_test_data(:,1,1,i) = Floor_Test(i,1:num)'; 
    end

    imageSize=[num 1];


    layers = [
    imageInputLayer(imageSize)
    
    convolution2dLayer(1,140,'Padding','same')
    batchNormalizationLayer
    reluLayer  
    maxPooling2dLayer(1,'Stride',1)
    
    convolution2dLayer(1,140,'Padding','same')
    batchNormalizationLayer
    reluLayer   
    maxPooling2dLayer(1,'Stride',1)
    
    convolution2dLayer(1,140,'Padding','same')
    batchNormalizationLayer
    reluLayer   
    maxPooling2dLayer(1,'Stride',1)

    convolution2dLayer(1,140,'Padding','same')
    batchNormalizationLayer
    reluLayer
    maxPooling2dLayer(1,'Stride',1) 

    fullyConnectedLayer(3)
    softmaxLayer
    classificationLayer];



        
    lgraph = layerGraph(layers);
    figure
    plot(lgraph);
    
    miniBatchSize = 1;
    
    options = trainingOptions('sgdm', ...
    'MaxEpochs',30,...
    'MiniBatchSize',miniBatchSize, ...
    'InitialLearnRate',5e-5, ...
    'GradientThreshold',1, ...
    'Verbose',false, ...
    'Plots','training-progress');



%current accuracy 79%
% 
% layers = [ ...
%     image3dInputLayer([9 9 4 1])
%     convolution3dLayer(4,50,'Stride',4)
%     batchNormalizationLayer
%     reluLayer
%     maxPooling3dLayer(1,'Stride',1)
%     fullyConnectedLayer(4)
%     softmaxLayer
%     classificationLayer]




% 
% maxEpochs = 100;
% miniBatchSize = 15;
% 
% options = trainingOptions('sgdm', ...
%     'ExecutionEnvironment','cpu', ...
%     'MaxEpochs',maxEpochs, ...
%     'MiniBatchSize',miniBatchSize, ...
%     'InitialLearnRate',5e-5, ...
%     'GradientThreshold',1, ...
%     'Verbose',false, ...
%     'Plots','training-progress');
% %     
% size(floor_data)
% size(responses)

    convnet_Floor = trainNetwork(RSSI_train_data, responses, lgraph, options);

  
   % Floor_prediction_in_sample = predict(convnet_Floor, floor_data);

    %[M_in_sample, Floor_in_sample_prediction] = max(double(predict(convnet_Floor, floor_data)), [], 2);
    %Floor_in_sample_prediction

    

    %[M_out_sample, Floor_out_sample_prediction] = max(double(predict(convnet_Floor, floor_test_data)), [], 2);


%     CNN_Longitude_Prediction = predict(convnet_Longitude, loc_test_data);
% 
%     CNN_Latitude_Prediction = predict(convnet_Latitude, loc_test_data);



    [M, CNN_Floor_Prediction] = max(double(predict(convnet_Floor, RSSI_test_data)), [], 2);
    CNN_Floor_Prediction=CNN_Floor_Prediction-1;

