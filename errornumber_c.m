
figure(1);
hold on;
plot(1:stumps_to_generate,mat_trainerror);
plot(1:stumps_to_generate,trainerror);
legend('mattrain_errors','mineerrors');
title('Number of train errors')
xlabel('stumps_t');
ylabel('number of errors');
hold off;

figure(2);
hold on;
plot(1:stumps_to_generate,mat_testerror);
plot(1:stumps_to_generate,testerror);
legend('mattest_errors','mine errors');
title('Number of test errors')
xlabel('stumps_t');
ylabel('number of errors');
hold off;


% plot the minimum margins
figure(3);
plot(1:stumps_to_generate,mintrainmargins);
title('Minimum margin for t stumps')
xlabel('stumps_t');
ylabel('min_margin');
