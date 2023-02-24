

function [CNN_Longitude_Prediction, CNN_Latitude_Prediction] = CNN_Loc_Prediction_1209(Loc_Train, Loc_Test)

    num = size(Loc_Train,2)-4;

   Long_responses = (Loc_Train(:,size(Loc_Train,2)-3))/1000;
   Lat_responses = (Loc_Train(:,size(Loc_Train,2)-2))/100000;
   RSSI_train_data  = -105*ones(num,1,1,size(Loc_Train, 1));
   RSSI_test_data   = -105*ones(num,1,1,size(Loc_Test, 1));


    for i = 1:size(Loc_Train, 1)
        RSSI_train_data(:,1,1,i) = Loc_Train(i,1:num)'; 
    end

%     for i = 1:size(Loc_Train2, 1)
%         RSSI_train2_data(:,1,1,i) = Loc_Train2(i,2:num)'; 
%     end

    for i = 1:size(Loc_Test, 1)
        RSSI_test_data(:,1,1,i) = Loc_Test(i,1:num)'; 
    end

    imageSize=[num 1];


    layers = [
    imageInputLayer(imageSize)
    
    convolution2dLayer(1,140,'Padding','same')
    batchNormalizationLayer
    reluLayer  
    averagePooling2dLayer(1,'Stride',1)
    
    convolution2dLayer(1,140,'Padding','same')
    batchNormalizationLayer
    reluLayer   
    averagePooling2dLayer(1,'Stride',1)
    
    convolution2dLayer(1,140,'Padding','same')
    batchNormalizationLayer
    reluLayer   
    averagePooling2dLayer(1,'Stride',1)

    convolution2dLayer(1,140,'Padding','same')
    batchNormalizationLayer
    reluLayer
    averagePooling2dLayer(1,'Stride',1) 

    fullyConnectedLayer(1);
    regressionLayer];



        
    lgraph = layerGraph(layers);
    figure
    plot(lgraph);
    
    miniBatchSize = 1;
    
    options = trainingOptions('sgdm', ...
    'MaxEpochs', 20,...
    'MiniBatchSize',miniBatchSize, ...
    'InitialLearnRate',5e-2, ...
    'Verbose',false, ...
    'Plots','training-progress');


    convnet_Long = trainNetwork(RSSI_train_data, Long_responses, lgraph, options);
    convnet_Lat = trainNetwork(RSSI_train_data, Lat_responses, lgraph, options);

    CNN_Longitude_Prediction = predict(convnet_Long, RSSI_test_data);
    CNN_Latitude_Prediction = predict(convnet_Lat, RSSI_test_data);
