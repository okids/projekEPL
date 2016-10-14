points = trainingInputsAndOutputs %config
learning_rate = 0.0001 %config
initial_b = 0 %config
initial_m = 0 %config
num_iterations = 1000000 %config
[b, m] = gradientDescentRunner(points, initial_b, initial_m, learning_rate, num_iterations)
scatter(points(:,1),points(:,2))
hold on
minAxis=min(trainingInputsAndOutputs(:,1));
maxAxis=max(trainingInputsAndOutputs(:,1));
plot(minAxis:maxAxis,m*(minAxis:maxAxis)+b);
error = computeErrorForLineGivenPoints(b,m,points);
str = sprintf('Y =  %fX + %f with Error = %f',m,b,error);
title(str)

