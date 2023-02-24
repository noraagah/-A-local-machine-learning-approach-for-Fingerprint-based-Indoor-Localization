%File Name: Floor_Train_RSSI_Image_Generation
%Description: This function generates a "pixel style image" for the input RSSI readings 
%from the input cell phones and observations.
%To do this it takes in the discretized grid of points from
%all of the buildings and generates RSSI "pixel" values at those locations using K
%nearest neighbors by averaging the k nearest WAP's RSSI values recieved by
%the observations
%Inputs: The Data object, the number of neighbors, the locations of grid of points to be
%calculated for, the observations that we are constructing an image for,
%the number of points per grid
%the name of the folder that the matrices are to be saved to
%Outputs: A matrix for each of the cell phone observations that contains the RSSI Image information for the input observation.
%Each matrix contains the RSSI "pixel" value prediction for each grid point in each row with the
%locations of the points concatenated to the end of each row. These
%matrices are saved to a folder in the current directory with the name passed in as an input
%function call
%First created: 9/24/22
%Last Modified: 10/6/22
%File Created By: Nora Agah

function Floor_Train_RSSI_Image_Generation(Observations, Image_Locations, Image_numNeighbors, WAP_Predictions, folder_name)
    
        %Make folder to save matrices to 
        mkdir(folder_name);

        %Set weight factor
        gamma = -1;

        %Initialize the strength averages
        RSSI_Strength = ones(size(Image_Locations, 1), 1);
        %aa = ones(size(Image_Locations, 1), 1);
        [m,n]=size(Image_Locations);
        Num1 = 16;
        Num2 = 16;


    
        %Find the numNeighbors number of nearest WAPS to the points in
        Idx = ones(1,Image_numNeighbors);
%            for i = 1:size(Observations, 1)
%                for j = 1:size(Image_Locations, 1)
%                    WAP_Predictions_subset=WAP_Predictions(WAP_Predictions(:,3)==Image_Locations(j,3),:);
%                    Observations_subset(i, :)=Observations(i, WAP_Predictions(:,3)==Image_Locations(j,3));
%                    Idx = knnsearch(WAP_Predictions_subset(:,1:2), Image_Locations(j,1:2), 'k', Image_numNeighbors);
%                    RSSI_Strength(j) = mean(Observations_subset(i, Idx));
%                end
%            end



%         size(WAP_Predictions(:,3))
%         size(Image_Locations(:,3))
        %WAP_Predictions_subset =
        %WAP_Predictions((abs(WAP_Predictions(:,3)-Image_Locations(:,3))==0),1:3); 
%         for k = 1:size(WAP_Predictions, 1)
%             RSSI_Strength(j)=
%         end


       % Idx = knnsearch(WAP_Predictions(:,1:2), Image_Locations(:,1:2), 'k', Image_numNeighbors);
        % size(Idx)
        
        ee=10^(-3);
        %count=0;





        %For each observation we create a matrix picture and save to file
        for i = 1:size(Observations, 1)

%             Observations(i,:315)
%             WAP_Predictions(:,3)=Observations(i,:315);

            for j = 1:size(Image_Locations, 1)

                

                %Idx = knnsearch(WAP_Predictions(j,1:2), Image_Locations(:,1:2), 'k', Image_numNeighbors);
                %WAP_Predictions_samefloor = WAP_Predictions(WAP_Predictions(:,3)=,:) 

                %Idx=(WAP_Predictions(:,3)==Image_Location(j,3));
                %RSSI_Strength(j) = mean(Observations(i, Idx(j, :)));
                %RSSI_Strength(j) = mean(Observations(i, Idx);

                WAP_Predictions_subset=WAP_Predictions(WAP_Predictions(:,3)==Image_Locations(j,3),:);
                Observations_subset=Observations(i, WAP_Predictions(:,3)==Image_Locations(j,3));
                Idx = knnsearch(WAP_Predictions_subset(:,1:2), Image_Locations(j,1:2), 'k', Image_numNeighbors);
                RSSI_Strength(j) = mean(Observations_subset(Idx));
                clear Observation_subset
                clear WAP_Predictions_subset
             
               
            end
         
%             count=count+(aa==RSSI_Strength);
% 
%             aa = RSSI_Strength;
     
            
            RSSI_Image_Matrix_Temp = [RSSI_Strength Image_Locations];

            

            
            %Make 1D arrays 
            numFloors = 4;
            %Num_Points = size(Image_Locations,1)/5


            RSSI_Image_Matrix = zeros(Num1, Num2, 4);

            %for k = 1:1
            for k = 1:numFloors
                %input_temp = RSSI_Image_Matrix_Temp(RSSI_Image_Matrix_Temp(:, 4) == (k-1), 1:5);
                %input_temp = input_temp(input_temp(:, 5) == 1, 1:5);
                input_temp = RSSI_Image_Matrix_Temp(RSSI_Image_Matrix_Temp(:, 4) == k-1, 1:4);
                input_temp = input_temp(:,1:4);
  

  
                
                for l = 1:16

     
                    RSSI_Image_Matrix(:,l,k) = input_temp((1+Num1*(l-1)) : (Num1+Num1*(l-1)), 1);
                end
                %Make file name observation.mat
                file = sprintf('%d_%d.mat', i); 
                f = fullfile(folder_name, file);
                save(f, 'RSSI_Image_Matrix');    
              
            end



            clear RSSI_Image_Matrix;

        end
                    %count
end