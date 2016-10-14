function [b,m] = gradientDescentRunner(points,starting_b,starting_m,learningRate, num_iterations)
    b = starting_b;
    m = starting_m;
    for i=0:num_iterations
        [b, m] = stepGradient(b, m, points, learningRate);
    end
end
