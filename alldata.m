
% plot training data
figure(1);
title('Training data');
xlabel('x1');
ylabel('x2');
hold on;
positives = scatter(trainX(find(trainY == 1),1),trainX(find(trainY == 1),2),10);
negatives = scatter(trainX(find(trainY == -1),1),trainX(find(trainY == -1),2),10);
legend([positives,negatives],'+1','-1','Location','NorthEast');
hold off;


% plot testing data
figure(2);
title('Testing data');
xlabel('x1');
ylabel('x2');
hold on;
positives = scatter(testX(find(testY == 1),1),testX(find(testY == 1),2),10);
negatives = scatter(testX(find(testY == -1),1),testX(find(testY == -1),2),10);
legend([positives,negatives],'+1','-1','Location','NorthEast');
hold off;
