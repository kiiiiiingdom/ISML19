figure(1);
hold on;
plot(1:stumps_to_generate,trainerror_rate);
plot(1:stumps_to_generate,mat_trainerror_rate);
legend('Trainerror','matlab buildin trainerror');
title('Percentage of errors based on classifier built')
xlabel('stumps used t');
ylabel('rate of errors');
hold off;