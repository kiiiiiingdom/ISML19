clear all;clc;
tic
trainsize = 300;testsize = 200;
stumps_to_generate = 25;
[trainX, trainY, testX, testY] = gen_sample(trainsize,testsize);
%fprintf('getting samples... \n');
Dt = zeros(trainsize,1);
Dt = Dt + (1/trainsize);stumps = [];
for i = 1:stumps_to_generate
    newStump = cell2mat(struct2cell(build_stump(trainX, trainY, Dt)));
    stumps = vertcat(stumps,newStump);
    if (newStump(1) == 1 && newStump(2) == 0)
        if (newStump(4) == 1)
            Dt(((trainX(:,1) - newStump(3)) .* trainY) < 0) = (Dt(((trainX(:,1) - newStump(3)) .* trainY) < 0))*exp(newStump(5));
            Dt(((trainX(:,1) - newStump(3)) .* trainY) >= 0) = (Dt(((trainX(:,1) - newStump(3)) .* trainY) >= 0))*exp(-newStump(5));
        else
            Dt(((trainX(:,1) - newStump(3)) .* trainY) > 0) = (Dt(((trainX(:,1) - newStump(3)) .* trainY) > 0))*exp(newStump(5));
            Dt(((trainX(:,1) - newStump(3)) .* trainY) <= 0) = (Dt(((trainX(:,1) - newStump(3)) .* trainY) <= 0))*exp(-newStump(5));
        end
    elseif (newStump(1) == 0 && newStump(2) == 1)
        if (newStump(4) == 1)
            Dt(((trainX(:,2) - newStump(3)) .* trainY) < 0) = (Dt(((trainX(:,2) - newStump(3)) .* trainY) < 0))*exp(newStump(5));
            Dt(((trainX(:,2) - newStump(3)) .* trainY) >= 0) = (Dt(((trainX(:,2) - newStump(3)) .* trainY) >= 0))*exp(-newStump(5));
        else
            Dt(((trainX(:,2) - newStump(3)) .* trainY) > 0) = (Dt(((trainX(:,2) - newStump(3)) .* trainY) > 0))*exp(newStump(5));
            Dt(((trainX(:,2) - newStump(3)) .* trainY) <= 0) = (Dt(((trainX(:,2) - newStump(3)) .* trainY) <= 0))*exp(-newStump(5));
        end
    else
        break;
    end
    Dt = Dt/sum(Dt);
    % Normalize the new weights matrix
end
trainclassifier = zeros(trainsize,stumps_to_generate);trainmargins = zeros(trainsize,stumps_to_generate);mintrainmargins = zeros(1,stumps_to_generate);
for i = 1:trainsize
    alphasum = 0;
    tempclassifier = 0;
    for j = 1:size(stumps,1)
        if (stumps(j,1) == 1) && (stumps(j,2) == 0)
            if (stumps(j,4) == 1)
                tempclassifier = tempclassifier + (sign(trainX(i,1) - stumps(j,3)))*stumps(j,5);
            else
                tempclassifier = tempclassifier - (sign(trainX(i,1) - stumps(j,3)))*stumps(j,5);
            end
            
        elseif (stumps(j,1) == 0) && (stumps(j,2) == 1)
            if (stumps(j,4) == 1)
                tempclassifier = tempclassifier + (sign(trainX(i,2) - stumps(j,3)))*stumps(j,5);
            else
                tempclassifier = tempclassifier - (sign(trainX(i,2) - stumps(j,3)))*stumps(j,5);
            end
            
        else
            break;
        end
        alphasum = alphasum + stumps(j,5);
        trainmargins(i,j) = (trainY(i) * tempclassifier) / alphasum;
        trainclassifier(i,j) = sign(tempclassifier);
    end
end

for i = 1:stumps_to_generate
    mintrainmargins(1,i) = min(trainmargins(:,i));
end
testclassifier = zeros(testsize,stumps_to_generate);
testmargins = zeros(testsize,stumps_to_generate);
mintestmargins = zeros(1,stumps_to_generate);
for i = 1:testsize
    alphasum = 0;
    tempclassifier = 0;
    for j = 1:size(stumps,1)
        if (stumps(j,1) == 1) && (stumps(j,2) == 0)
            if (stumps(j,4) == 1)
                tempclassifier = tempclassifier + (sign(testX(i,1) - stumps(j,3)))*stumps(j,5);
            else
                tempclassifier = tempclassifier - (sign(testX(i,1) - stumps(j,3)))*stumps(j,5);
            end
        elseif (stumps(j,1) == 0) && (stumps(j,2) == 1)
            if (stumps(j,4) == 1)
                tempclassifier = tempclassifier + (sign(testX(i,2) - stumps(j,3)))*stumps(j,5);
            else
                tempclassifier = tempclassifier - (sign(testX(i,2) - stumps(j,3)))*stumps(j,5);
            end
        else
            break;
        end
        alphasum = alphasum + stumps(j,5);
        testmargins(i,j) = (testY(i) * tempclassifier) / alphasum;
        testclassifier(i,j) = sign(tempclassifier);
    end
end
for i = 1:stumps_to_generate
    mintestmargins(1,i) = min(testmargins(:,i));
end
trainaccuracy = zeros(1,stumps_to_generate);
testaccuracy = zeros(1,stumps_to_generate);
for i = 1:stumps_to_generate
    trainaccuracy(1,i) = size(find(trainclassifier(:,i) == trainY),1);
    testaccuracy(1,i) = size(find(testclassifier(:,i) == testY),1);
end
trainerror = size(trainY,1) - trainaccuracy;
testerror = size(testY,1) - testaccuracy;
trainerror_rate = trainerror/size(trainY,1);
testerror_rate = testerror/size(testY,1);
mat_trainerror_rate = zeros(1,stumps_to_generate);mat_trainerror = zeros(1,stumps_to_generate);
mat_testerror_rate = zeros(1,stumps_to_generate) ;mat_testerror = zeros(1,stumps_to_generate);

%compare_ada_tracc = size(find(train_predict_labels == ada_train),1)/trainsize;
% for loop for calc mat rate.
for n = 1:stumps_to_generate
m_out = fitensemble(trainX,trainY,'AdaBoostM1',n,'Tree');
predict_label = predict(m_out, testX);
predict_labelt = predict(m_out,trainX);
%train_label1 = predict(m_out, train_data);
sco = max(size(find(predict_label~=testY)));
sco1 = max(size(find(predict_labelt~=trainY)));
%sco = 1 - max(size(find(train_label1~=train_label1)))/300;
%disp('Matlab lib calculation accuracy:');
mat_testerror_rate(n) = sco/testsize;
mat_trainerror(n) = sco1;
mat_testerror(n) = sco;
mat_trainerror_rate(n) = sco1/testsize;
end
% ------Compare build-in SVM predict data with adaboost.
[svmtrainacc,svmtestacc,adatrainacc,adatestacc]=svm_calc_compare(trainX, trainY, testX, testY, predict_labelt, predict_label,trainsize,testsize);

%fprintf('Free variables from memory... \n')
%clearvars -except stumps_to_generate mat_trainerror trainerror mat_testerror testerror mintrainmargins trainerror_rate mat_trainerror_rate testerror_rate mat_testerror_rate svmtr svmte cadatr cadate

disp('All done!')
toc
