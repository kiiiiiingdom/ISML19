figure(1);
hold on;
plot(1:stumps_to_generate,testerror_rate);
plot(1:stumps_to_generate,mat_testerror_rate);
legend('testerror','matlab buildin testerror');
title('Percentage of errors based on classifier built')
xlabel('stumps used t');
ylabel('rate of errors');
hold off;