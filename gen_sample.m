function [tX, tY, teX, teY] = gen_sample(n, m)
data = importdata("wdbc_data.csv");
X = data.data;
y = data.textdata(:,2);y = string(y);
y(y=='M') = -1;y(y=='B') = 1;
tX = X(1:n,:);
tY = double(y(1:n,:));
teX = X((n + 1):(n + m),:);
teY = double(y((n + 1):(n + m),:));
end