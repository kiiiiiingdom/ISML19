function stump = stumpGenerator(dataX, dataY, Dt)
intervals = 200;%间隔
rangex1 = max(dataX(:,1)) - min(dataX(:,1));rangex2 = max(dataX(:,2)) - min(dataX(:,2));
width = (rangex1/intervals);
height = (rangex2/intervals);
starterx1 = min(dataX(:,1)) - (width/2);
starterx2 = min(dataX(:,2)) - (height/2);
% startingpoint x1,x2 
currepsilon = inf;
stump = [0,0,0,1,0,0];
for i = 1:(intervals + 1)
    horzRightError = sum(Dt(find(((dataX(:,1) - starterx1) .* dataY) < 0)));
    horzLeftError = sum(Dt(find(((dataX(:,1) - starterx1) .* dataY) > 0)));
    vertUpError = sum(Dt(find(((dataX(:,2) - starterx2) .* dataY) < 0)));
    vertDownError = sum(Dt(find(((dataX(:,2) - starterx2) .* dataY) > 0)));
    if (horzRightError <= horzLeftError)
        horzError = horzRightError;
    else
        horzError = -horzLeftError;
    end
    
    if (vertUpError <= vertDownError)
        vertError = vertUpError;
    else
        vertError = -vertDownError;
    end
    if (abs(horzError) <= abs(vertError))
        if (currepsilon > abs(horzError))
            currepsilon = abs(horzError);
            stump(1) = 1;
            stump(2) = 0;
            stump(3) = starterx1;
            stump(4) = horzError/(abs(horzError));
            stump(5) = (log((1 - currepsilon)/currepsilon))/2;
            stump(6) = currepsilon;
        end
    else
        if (currepsilon > abs(vertError))
            currepsilon = abs(vertError);
            stump(1) = 0;
            stump(2) = 1;
            stump(3) = starterx2;
            stump(4) = vertError/(abs(vertError));
            stump(5) = (log((1/currepsilon) - 1))/2;
            stump(6) = currepsilon;
        end
    end
    starterx1 = starterx1 + width;
    starterx2 = starterx2 + height;
end
end