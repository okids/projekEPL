function [newB,newM] = stepGradient(bCurrent,mCurrent,points,learningRate)
    bGradient = 0;
    mGradient = 0;
    N = length(points);
    for i=1:N
        x = points(i,1);
        y = points(i,2);
        bGradient = bGradient -(2/N) * (y - ((mCurrent * x) + bCurrent));
        mGradient = mGradient  -(2/N) * x * (y - ((mCurrent * x) + bCurrent));
    end
    newB = bCurrent - (learningRate * bGradient);
    newM = mCurrent - (learningRate * mGradient);
    
end
   