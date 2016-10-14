function y = computeErrorForLineGivenPoints(b, m, points)
    totalError = 0
    for i =0:length(points)
        x = points(i,0)
        y = points(i,1)
        totalError = totalError + (y- (m*x +b)).^2
    end
    y = totalError/length(points)
end
    
