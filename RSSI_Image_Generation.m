%File Name: RSSI_Image_Generation
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
%First created: 4/17/22
%Last Modified: 9/24/22
%File Created By: Nora Agah

function RSSI_Image_Generation(Observations, Image_Locations, Image_numNeighbors, WAP_Predictions, Num_Points, folder_name)
    
        %Make folder to save matrices to 
        mkdir(folder_name);

        %Set weight factor
        gamma = -1;

        %Initialize the strength averages
        RSSI_Strength = ones(size(Image_Locations, 1), 1);
    
        %Find the numNeighbors number of nearest WAPS to the points in
        %the grid
        Idx = knnsearch(WAP_Predictions(:, 1:4), Image_Locations, 'k', Image_numNeighbors);
        
        %For each observation we create a matrix picture and save to file
        for i = 1:size(Observations, 1)

            for j = 1:size(Image_Locations, 1)
                    

                    %Calculate distance to each close point to use for
                    %weight, use floor, longitude, and latitude
                    D1 = (Image_Locations(j, 1)-WAP_Predictions(Idx(j, :), 1)).^2;    
                    D2 = (Image_Locations(j, 2)-WAP_Predictions(Idx(j, :), 2)).^2;
                    D = sqrt(D1+D2);
                    F = 4*(Image_Locations(j, 3)-WAP_Predictions(Idx(j, :), 3));
                    Dist = D+F;
                    weight = exp(gamma*Dist) ./ sum(exp(gamma*Dist));
                    RSSI_Strength(j, :) = weight.'*(Observations(1, Idx(j, :))).';
            end
            
            

             RSSI_Image_Matrix_Temp = [RSSI_Strength Image_Locations];

            %Make images into a format that works for CNN and heatmap
            %generation
            %Make 1D arrays
            numBuildings = 3; 
            numFloors = 5;
            Full_RSSI_Matrix = numFloors*numBuildings*Num_Points;
        

            for j = 1:numBuildings
                for k = 1:numFloors
                    input_temp = RSSI_Image_Matrix_Temp(RSSI_Image_Matrix_Temp(:, 4) == (k-1), 1:5);
                    input_temp = input_temp(input_temp(:, 5) == (j-1), 1:5);
                    
                    for l = 1:sqrt(Num_Points)
                        RSSI_Image_Matrix(l, 1:sqrt(Num_Points)) = input_temp(((1+sqrt(Num_Points)*(l-1)) : (sqrt(Num_Points)+sqrt(Num_Points)*(l-1))), 1);
                    end

                    Full_RSSI_Matrix(1+sqrt(Num_Points)*(k-1) : sqrt(Num_Points)*k, 1+sqrt(Num_Points)*(j-1) : sqrt(Num_Points)*j) =  RSSI_Image_Matrix;
                end
            end

            clear RSSI_Image_Matrix;
            
            %Make file name observation.mat
            file = sprintf('%d.mat', i); 
            f = fullfile(folder_name, file);
            save(f, 'Full_RSSI_Matrix');

%             for j = 1:numBuildings
%                 clear RSSI_Image_Matrix;
%                 for k = 1:numFloors
%                     input_temp = RSSI_Image_Matrix_Temp(RSSI_Image_Matrix_Temp(:, 4) == (k-1), 1:5);
%                     input_temp = input_temp(input_temp(:, 5) == (j-1), 1:5);
%                     
%                     for l = 1:sqrt(Num_Points)
%                         RSSI_Image_Matrix(l, 1:sqrt(Num_Points)) = input_temp(((1+sqrt(Num_Points)*(l-1)) : (sqrt(Num_Points)+sqrt(Num_Points)*(l-1))), 1);
%                     end
% 
%                     %Make file name observation_building_floor.mat
%                     file = sprintf('%d_%d_%d.mat', i, (j-1), (k-1)); 
%                     f = fullfile(folder_name, file);
%                     save(f, 'RSSI_Image_Matrix');
%                 end
%             end
    


%             numFloors = 5;
%             for k = 1:numFloors
%                     clear RSSI_Image_Matrix;
%                     input_temp = RSSI_Image_Matrix_Temp(RSSI_Image_Matrix_Temp(:, 4) == (k-1), 1:5);
%                     input_temp = input_temp(input_temp(:, 5) == 2, 1:5);
%             
%                     for l = 1:sqrt(Num_Points)
%                         RSSI_Image_Matrix(l, 1:sqrt(Num_Points)) = input_temp(((1+sqrt(Num_Points)*(l-1)) : (sqrt(Num_Points)+sqrt(Num_Points)*(l-1))), 1);
%                     end
%                     file = sprintf('%d_%d_%d.mat', i, 2, (k-1)); 
%                     f = fullfile(folder_name, file);
%                     save(f, 'RSSI_Image_Matrix');
%             end

        end
end