%File Name: Binary_Method_Preprocessing
%Description: This method prepares the location and test data to be used in
%when doing binary classification. To aide with classification between
%building 0 or 1 and building 2, the training and test data are given an
%extra column that sets all buildings with 0 or 1 classification to a 1
%classification and keeps buildings with a 2 classification as a 2
%classification in order to seperate data in to two categories. To aide
%with classifying between building 0 and 1, a test and data df are created
%including only buildings 0 and 1. To aide with binary floor
%classification, dfs are created for each building with a column added that 
%sets all floors with 0 or 1 classification to a 1 classification and sets
%buildings with a 2 or 3 classification to a 2 classification.
%classification in order to seperate data in to two categories.  To aide
%with classifying between floor 0 and 1 and between floor 2 and 3, test and 
%data dfs for building 0 are created including only floors 0 and 1 and
%floors 2 and 3. Floor specific training and test dfs are created as well
%for building 0. Each building training and testing data is also apended
%with a columns that classifies whether it is above or below a specific
%line
%Inputs: The data object
%Outputs: Data prepared to be used for binary classification
%First created: 11/6/21
%Last Modified: 11/23/21
%File Created By: Nora Agah


function obj = Binary_Method_Preprocessing(obj)

    obj.binary_train_df = obj.location_train_df;
    obj.binary_test_df = obj.location_test_df;
    
    %Add an extra column for binary building classification and convert 
    %all building 0s to building 1s. Leave building 2 as building 2   
    train_binary_buildings = obj.binary_train_df(:, 316);
    test_binary_buildings = obj.binary_test_df(:, 316);

    train_binary_buildings(train_binary_buildings == 0) = 1;
    test_binary_buildings(test_binary_buildings == 0) =  1;

    obj.binary_train_df= [obj.binary_train_df train_binary_buildings];
    obj.binary_test_df = [obj.binary_test_df test_binary_buildings];

    %Add all building 0 and building 1 data into building_0_1_train_df and building_0_1_test_df
    obj.building_0_1_train_df = [obj.location_train_df(obj.location_train_df(:, 316) == 0, :); obj.location_train_df(obj.location_train_df(:, 316) == 1, :)];
    obj.building_0_1_test_df = [obj.location_test_df(obj.location_test_df(:, 316) == 0, :); obj.location_test_df(obj.location_test_df(:, 316) == 1, :)];
    
    %Add an extra column for binary floor classification and convert 
    %all floor 0s to building 1s and convert all floor 3s to floor 2s.  
    train_binary_floors = obj.binary_train_df(:, 315);
    test_binary_floors = obj.binary_test_df(:, 315);

    train_binary_floors(train_binary_floors == 0) = 1;
    train_binary_floors(train_binary_floors == 3) = 2;
    test_binary_floors(test_binary_floors == 0) =  1;
    test_binary_floors(test_binary_floors == 3) =  2;

    temp_binary_train_df= [obj.location_train_df train_binary_floors];
    temp_binary_test_df = [obj.location_test_df test_binary_floors];

    %Create dfs for each building 
    obj.building_0_train_df = temp_binary_train_df(temp_binary_train_df(:, 316) == 0, :);
    obj.building_0_test_df = temp_binary_test_df(temp_binary_test_df(:, 316) == 0, :);
    obj.building_1_train_df = temp_binary_train_df(temp_binary_train_df(:, 316) == 1, :);
    obj.building_1_test_df = temp_binary_test_df(temp_binary_test_df(:, 316) == 1, :);
    obj.building_2_train_df = temp_binary_train_df(temp_binary_train_df(:, 316) == 2, :);
    obj.building_2_test_df = temp_binary_test_df(temp_binary_test_df(:, 316) == 2, :);

    %Add all Building 0 floor 0 and floor 1 data into floor_0_1_train_df and floor_0_1_test_df
    %and add all Building 0 floor 2 and floor 3 data into floor_2_3_train_df and floor_2_3_test_df
    obj.floor_0_1_train_df = [obj.building_0_train_df(obj.building_0_train_df(:, 315) == 0, :); obj.building_0_train_df(obj.building_0_train_df(:, 315) == 1, :)];
    obj.floor_0_1_test_df = [obj.building_0_test_df(obj.building_0_test_df(:, 315) == 0, :); obj.building_0_test_df(obj.building_0_test_df(:, 315) == 1, :)];
    obj.floor_2_3_train_df = [obj.building_0_train_df(obj.building_0_train_df(:, 315) == 2, :); obj.building_0_train_df(obj.building_0_train_df(:, 315) == 3, :)];
    obj.floor_2_3_test_df = [obj.building_0_test_df(obj.building_0_test_df(:, 315) == 2, :); obj.building_0_test_df(obj.building_0_test_df(:, 315) == 3, :)];

    %Create train dfs for each floor in building 0
    obj.floor_0_train_df =  obj.building_0_train_df(obj.building_0_train_df(:, 315) == 0, :);
    obj.floor_1_train_df =  obj.building_0_train_df(obj.building_0_train_df(:, 315) == 1, :);
    obj.floor_2_train_df =  obj.building_0_train_df(obj.building_0_train_df(:, 315) == 2, :);
    obj.floor_3_train_df =  obj.building_0_train_df(obj.building_0_train_df(:, 315) == 3, :);

    %Create test dfs for each floor in building 0
    obj.floor_0_test_df =  obj.building_0_test_df(obj.building_0_test_df(:, 315) == 0, :);
    obj.floor_1_test_df =  obj.building_0_test_df(obj.building_0_test_df(:, 315) == 1, :);
    obj.floor_2_test_df =  obj.building_0_test_df(obj.building_0_test_df(:, 315) == 2, :);
    obj.floor_3_test_df =  obj.building_0_test_df(obj.building_0_test_df(:, 315) == 3, :);


   %Define the equation of the line for the way to split up the
   %building
   %Using these two points: [-7640, 4864960] and [-7400, 4864825]
   % y = -0.5625(x + 7640) + 4864960
   %Section 0 if below line Section 1 if above line
   section_vector = logical(obj.building_0_train_df(:, 314) < (-0.5625*(obj.building_0_train_df(:, 313) + 7640) + 4864960));
   obj.building_0_train_df = [obj.building_0_train_df section_vector];
   section_vector = logical(obj.building_1_train_df(:, 314) < (-0.5625*(obj.building_1_train_df(:, 313) + 7640) + 4864960));
   obj.building_1_train_df = [obj.building_1_train_df section_vector];
   section_vector = logical(obj.building_2_train_df(:, 314) < (-0.5625*(obj.building_2_train_df(:, 313) + 7640) + 4864960));
   obj.building_2_train_df = [obj.building_2_train_df section_vector];

   section_vector = logical(obj.building_0_test_df(:, 314) < (-0.5625*(obj.building_0_test_df(:, 313) + 7640) + 4864960));
   obj.building_0_test_df = [obj.building_0_test_df section_vector];
   section_vector = logical(obj.building_1_test_df(:, 314) < (-0.5625*(obj.building_1_test_df(:, 313) + 7640) + 4864960));
   obj.building_1_test_df = [obj.building_1_test_df section_vector];
   section_vector = logical(obj.building_2_test_df(:, 314) < (-0.5625*(obj.building_2_test_df(:, 313) + 7640) + 4864960));
   obj.building_2_test_df = [obj.building_2_test_df section_vector];


   %Prepare dfs specific to building sections
   obj.building_0_section_0_train_df = obj.building_0_train_df(obj.building_0_train_df(:, 318) == 0, :);
   obj.building_0_section_1_train_df = obj.building_0_train_df(obj.building_0_train_df(:, 318) == 1, :);
   obj.building_0_section_0_test_df = obj.building_0_test_df(obj.building_0_test_df(:, 318) == 0, :);
   obj.building_0_section_1_test_df = obj.building_0_test_df(obj.building_0_test_df(:, 318) == 1, :);

   obj.building_1_section_0_train_df = obj.building_1_train_df(obj.building_1_train_df(:, 318) == 0, :);
   obj.building_1_section_1_train_df = obj.building_1_train_df(obj.building_1_train_df(:, 318) == 1, :);
   obj.building_1_section_0_test_df = obj.building_1_test_df(obj.building_1_test_df(:, 318) == 0, :);
   obj.building_1_section_1_test_df = obj.building_1_test_df(obj.building_1_test_df(:, 318) == 1, :);

   obj.building_2_section_0_train_df = obj.building_2_train_df(obj.building_2_train_df(:, 318) == 0, :);
   obj.building_2_section_1_train_df = obj.building_2_train_df(obj.building_2_train_df(:, 318) == 1, :);
   obj.building_2_section_0_test_df = obj.building_2_test_df(obj.building_2_test_df(:, 318) == 0, :);
   obj.building_2_section_1_test_df = obj.building_2_test_df(obj.building_2_test_df(:, 318) == 1, :);

end