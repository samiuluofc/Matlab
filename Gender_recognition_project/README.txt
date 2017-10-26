# Visual Aesthetics for Gender prediction.
# Developed by Samiul Azam and Dr. Marina Gavrilova


# Each step folder have its own README.txt

## Step 0: Feature Extraction
-------------------------------------------------------------------------------	
>> Use the male-female Flickr database provided with this pendrive.
>> Use the correct data-path during feature extraction (change it inside the code if necessary).
>> Pls read the README.txt inside "Step_0_feature_extraction"
>> It will generate two mat files (F_60.mat and M_113.mat) contains all extracted features 
(57 Dimension) for all 12000 images from 60 females and 22600 images from 113 males.

F_60.mat (a matrix of 12000 rows and 57 columns)
M_113.mat (a matrix of 22600 rows and 57 columns)


## Step 1: Feature Selection
-------------------------------------------------------------------------------	
>> SBS feature selection process for KNN, SVM and DTree
>> Generate binary selection information (for 57 features) at the Matlab CLI output.
>> Execute seperate files for KNN, SVM and DTree.

## Step 2: Generate Test scores
-------------------------------------------------------------------------------	
>> As test data we randomly select 33 males out of 113 and 17 females out of
60 females. This makes total 50 persons as test data. Rest of them is used as training
data. We do this selection for 5 times (makes 5 different experiments).

>> Generate test scores (or gender probability by individual classifiers: LASSO, SVM, KNN, DTREE))
>> The mat file "score.mat" contains all the gender probabilities.

score.mat (a matrix of 4 columns (SVM, KNN, DTREE, LASSO) and 250 rows (50 x 5 experiments)


## Step 3: GA Optimization
-------------------------------------------------------------------------------
>> To get the combined perdiction results (in mixture of experts model) we need to find 
the optimal weights for the weighted average equation using GA.

>> GA will utilize the "score.mat" file and "fitness_mix" function in order to do it.
>> The code "main_GA.m" will generate the generation graph for visualization and best weight
values with maximized accuracy in the matlab CLI.
	  




