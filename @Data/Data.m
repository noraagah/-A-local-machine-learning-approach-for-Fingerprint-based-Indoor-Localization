%File Name: Data
%Description: This file serves as the header for the Dataset class
%First created: 8/24/21
%Last Modified: 11/23/21
%File Created By: Nora Agah

classdef Data
    properties
        location_train_df
        location_test_df

        location_train_WAP
        location_test_WAP

        binary_train_df
        binary_test_df

        building_0_1_train_df
        building_0_1_test_df
        building_0_train_df
        building_0_test_df
        building_1_train_df
        building_1_test_df
        building_2_train_df
        building_2_test_df

        floor_0_1_train_df 
        floor_0_1_test_df
        floor_2_3_train_df
        floor_2_3_test_df
        floor_0_train_df
        floor_1_train_df
        floor_2_train_df 
        floor_3_train_df
        floor_0_test_df
        floor_1_test_df
        floor_2_test_df 
        floor_3_test_df

        building_0_section_0_train_df
        building_0_section_1_train_df
        building_0_section_0_test_df
        building_0_section_1_test_df
        building_1_section_0_train_df
        building_1_section_1_train_df
        building_1_section_0_test_df
        building_1_section_1_test_df
        building_2_section_0_train_df
        building_2_section_1_train_df
        building_2_section_0_test_df
        building_2_section_1_test_df
    end
    methods
        function obj = Data(Train_Data, Valid_Data)
            [cleaned_train_df, cleaned_valid_df] = Data_Preprocessing(obj, Train_Data, Valid_Data);
            [nonzero_valid_df, zero_valid_var] = Remove_Validation_Columns(obj, cleaned_valid_df);
            obj = Remove_Training_Columns(obj, zero_valid_var, cleaned_train_df, nonzero_valid_df);
            obj = KNN_Data_Preprocessing(obj);
            obj = Binary_Method_Preprocessing(obj);
        end
        [cleaned_train_df, cleaned_valid_df] = Data_Preprocessing(obj, Train_Data, Valid_Data)
        
        [nonzero_valid_df, zero_valid_var] = Remove_Validation_Columns(obj, cleaned_valid_df)
        
        obj = Remove_Training_Columns(obj, zero_valid_var, cleaned_train_df, nonzero_valid_df);
        
        obj = KNN_Data_Preprocessing(obj);

        obj = Binary_Method_Preprocessing(obj);


    end
end