function y = computeErrorForLineGivenPoints(b, m, points)
    totalError = 0
    for i =1:length(points)
        x = points(i,1)
        y = points(i,2)
        totalError = totalError + (y- (m*x +b)).^2
    end
    y = totalError/length(points)
end
    
