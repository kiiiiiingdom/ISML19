%clear all;
%clc;

function [svm_tracc,svm_teacc, compare_ada_tracc,compare_ada_teacc] = svm_calc_compare(trX,trY,teX,teY,ada_train,ada_test,trainsize,testsize);
mis_classification_number = 1;
svm_train_set = trX;
svm_train_set_labels = trY;
svm_test_set = teX;
svm_test_set_labels = teY;
svmModel = fitcsvm(svm_train_set, svm_train_set_labels,'BoxConstraint',mis_classification_number);
test_predict_labels = predict(svmModel, svm_test_set);
train_predict_labels = predict(svmModel, svm_train_set);
%sv = svmModel.SupportVectors;
svm_tracc = size(find(train_predict_labels == svm_train_set_labels),1)/trainsize;
svm_teacc = size(find(test_predict_labels == svm_test_set_labels),1)/testsize;
%svm result fig for the report.
%figure('name','svm result')
%gscatter(svm_train_set(:,1),svm_train_set(:,2), svm_train_set_labels)
%hold on
%plot(sv(:,1),sv(:,2),'ko','MarkerSize',10)%looking for the support vectors
%legend('class 1','class 2','SVM Support Vector')
%hold off

compare_ada_tracc = size(find(train_predict_labels == ada_train),1)/trainsize;
compare_ada_teacc = size(find(test_predict_labels == ada_test),1)/testsize;

end
%------- the figure for testY and predict-test-Y
%figure
%gscatter(svm_test_set(:,1),svm_test_set(:,2), test_predict_labels)
%figure
%gscatter(svm_test_set(:,1),svm_test_set(:,2), svm_test_set_labels)
