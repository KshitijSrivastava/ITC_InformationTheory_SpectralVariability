%% Loading the Indian Pines Data
load Indian_pines;      %Loading the Indian Pines Spectral Data
load Indian_pines_gt;   %Loading the Indian Pines Ground_Verification Data

%% Converting the 3D matrix data to 2D tabular form

[length , breadth ] = size(indian_pines_gt);    %Finding the length and breadth
[ ~ ,  ~ , bands]=size(indian_pines);   %Finding the number of bands in the Indian Pines spectral data

input = zeros(length*breadth, bands);   %Making empty vector for input spectral bands
output = zeros(length*breadth, 1);      %Making empty vector for output ground data

%Extracting the spectral data for all the pixels and putting it into input
%vector
index=1;
for i=1:length
    for j=1:breadth
        y = squeeze(indian_pines(i,j,:)); % Extracting the spectral bands for i,j index
        input(index,:) = y;
        output(index,1) = indian_pines_gt(i,j); %Ground truth data for i,j index
        index = index + 1;
    end
end

%% Plotting Different Spectral Bands

%Some randomly selected spectral bands
index1 = 1;
index2 = 75;
index3 = 100;

figure;
hold on;
plot(input(index1,:))
plot(input(index2,:))
plot(input(index3,:))
title('Spectral Profile of Different Classes')
hold off;
legend;


%% Probability Vector

prob_vector = zeros(length*breadth, bands); %Probability vector for all the input spectral bands 
[input_len , ~] = size(input);              %Total Number of Spectral Bands

%Finding the probability vector for all the spectral bands 
for i=1:input_len
    sums = sum(input(i,:));
    answer = (input(i,:)/sums);
    prob_vector(i,:) = answer ;
end
 
%% Entropy of the Hyper-Spectral Image Pixel
entropy_vector = zeros(length*breadth, 1); %Entropy vector for all the spectral bands

for i=1:input_len
    entropy_vector(i,1) = -1*sum(log10(prob_vector(i,:)).* prob_vector(i,:));
    %Entropy for each pixel
end

%% Spectral Information Divergence

% Selected pixels
pixel_index1 = 1;
pixel_index2 = 75;
%Relative Entropy of y with respect to x
D_xy = sum(prob_vector(pixel_index1,:).*(log10(prob_vector(pixel_index1,:)./prob_vector(pixel_index2,:))));
%Relative Entropy of x with respect to y
D_yx = sum(prob_vector(pixel_index2,:).*(log10(prob_vector(pixel_index2,:)./prob_vector(pixel_index1,:))));
SID_value = D_xy +D_yx;

%% Spectral Discriminatory Probability

% 5 Spectral Signatures
input_database = input([1,25,75,100,150],:);    %Spectral Database 
output_database = output([1,25,75,100,150],:);  %Spectral database output
[len_input_database , ~] = size(input_database);

%Target Pixel for identification
target_pixel_index = 5;
target_pixel = input(target_pixel_index,:);
target_pixel_prob = (input(i,:)/sum(input(i,:)));

%Spectral Similarity measures calculation Vector
%Zero vector for Euclidian Distance Measurement
prob_vector_euclid = zeros(target_pixel_index,1);
%Zero vector for SAM 
prob_vector_sam = zeros(target_pixel_index,1);
%Zero vector for SID 
prob_vector_sid = zeros(target_pixel_index,1);

%Finding SAM and Euclid Distance for all the spectral profiles in Database
for i=1:len_input_database
    prob_vector_euclid(i,1) = Euclid_Distance( target_pixel,input_database(i,:) );
    prob_vector_sam(i,1) = SAM( target_pixel,input_database(i,:) );
    input_database_prob = input_database(i,:)/ (sum(input_database(i,:)));
    prob_vector_sid(i,1) = SID( target_pixel_prob, input_database_prob );
end

% Check the prediction by Euclidian Distance
[~,predicted_index_euclid] = min(prob_vector_euclid);
predicted_output_euclid = output_database(predicted_index_euclid);

% Check the prediction by SAM
[~,predicted_index_sam] = min(prob_vector_sam);
predicted_output_sam = output_database(predicted_index_sam);

% Check the prediction by SAM
[~,predicted_index_sid] = min(prob_vector_sid);
predicted_output_sid = output_database(predicted_index_sid);

%% For showing the figure of the database and the target pixel

figure;
hold on;
for i=1:len_input_database
    plot(input_database(i,:));
end
plot(target_pixel, '-')
title('Spectral Profile of database and target pixel');
hold off;
legend('Data-1','Data-2', 'Data-3', 'Data-4', 'Data-5', 'Target' );

%% Spectral Discriminating Power

reference_pixel_index = 5;                                  %Index of reference pixel
reference_pixel = input(reference_pixel_index,:);           %Reference pixel spectral bands
reference_pixel_output = output(reference_pixel_index,1);   %Reference pixel output
reference_pixel_prob = reference_pixel/ (sum(reference_pixel)); %Reference pixel Prob

Si_index = 25;                                              %Index of Si pixel
Si_pixel = input(Si_index,:);                               %Si pixel spectral bands
Si_pixel_output = output(Si_index,1);                       %Si pixel output
Si_pixel_prob = Si_pixel/ (sum(Si_pixel));                  %Si pixel probability

Sj_index = 75;                                      %Index of Sj pixel
Sj_pixel = input(Sj_index,:);                       %Sj pixel spectral bands
Sj_pixel_output = output(Sj_index,1);               %Sj pixel spectral bands
Sj_pixel_prob = Sj_pixel/ (sum(Sj_pixel));          %Sj pixel probability

% When Euclidian is used for Spectral Similarity Measure
arg1 = Euclid_Distance(Si_pixel,reference_pixel )/Euclid_Distance(Sj_pixel,reference_pixel);
arg2 = Euclid_Distance(Sj_pixel,reference_pixel )/Euclid_Distance(Si_pixel,reference_pixel);
PW_euclid = max(arg1, arg2 );

% When SAM is used for Spectral Similarity Measure
arg1 = SAM(Si_pixel,reference_pixel )/SAM(Sj_pixel,reference_pixel);
arg2 = SAM(Sj_pixel,reference_pixel )/SAM(Si_pixel,reference_pixel);
PW_sam = max(arg1, arg2 );

% When SID is used for Spectral Similarity Measure

arg1 = SID(Si_pixel_prob,reference_pixel_prob )/SID(Sj_pixel_prob,reference_pixel_prob);
arg2 = SID(Sj_pixel_prob,reference_pixel_prob )/SID(Si_pixel_prob,reference_pixel_prob);
PW_sid = max(arg1, arg2 );

%% Spectral Discriminatory Entropy

%Spectral discriminatory entropy of database with respect to reference pixel for Euclid Distance 
spectral_discriminatory_entropy_euclid = -1*sum(log10(prob_vector_euclid).* prob_vector_euclid);
%Spectral discriminatory entropy of database with respect to reference
%pixel for SAM
spectral_discriminatory_entropy_sam = -1*sum(log10(prob_vector_sam).* prob_vector_sam);

%% SAM Vs SID

index1 = 5;
index2 = 75;

sid_dist = SID(prob_vector(index1,:), prob_vector(index2,:));
eucid_dist = Euclid_Distance(input(index1,:),input(index2,:));
sam_dist = SAM(input(index1,:),input(index2,:));
