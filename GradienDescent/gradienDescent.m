points = trainingInputsAndOutputs %config
learning_rate = 0.0001 %config
initial_b = 0 %config
initial_m = 0 %config
num_iterations = 100000 %config
[b, m] = gradientDescentRunner(points, initial_b, initial_m, learning_rate, num_iterations)
plot(points(:,1),points(:,2))
hold on
plot(1:100,m*(1:100)+b)