function [r] = exprndBounded(mu,sizeOut,r1,r2)
%This function generates a set of rates following the exponential
%distribution given a mean, size of rate vector, lower bound and upper
%bound

minE = exp(-r1/mu); 
maxE = exp(-r2/mu);

randBounded = minE + (maxE-minE).*rand(sizeOut);
r = -mu .* log(randBounded);

end

