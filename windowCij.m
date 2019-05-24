function [Cij, CAvg, CSize, Nodes, Dates, RMean] = windowCij(data, winsize, step)

% Find matrix of correlations Cij over a moving window. Inputs are the
% data, the size of the window by which to step, and the step size. Outputs
% are the Cij in each window; the average of each Cij; the size and members
% of the network in each window; the sum of data in each window; and the 
% date on which the window ends. For best results, missing data should be
% NaN.

n = 1;
m = 1; 
w = winsize;

while w<=size(data,1)
    if w>size(data,1)
        break
    end
    Dates(m) = n; % index of date where window ends 
    temp = data(n:w,:); % take data in specified time window
    tempsum = sum(temp);
    Nodes(1:length(tempsum(~isnan(tempsum) & tempsum~=0)),m) = find(~isnan(tempsum) & tempsum~=0);
    temp(:,isnan(tempsum)) = [];
    tempsum = sum(temp);
    temp(:,tempsum==0) = [];% find members with partial data and cut out those members
    CSize(m) = size(temp,2); %#ok<*AGROW> % get network size
    RMean(m) = mean(mean(temp))*winsize; % get mean of data in this window
    temp = temp - repmat(mean(temp),winsize,1);
    for i=1:CSize(m)
        divby(i) = sqrt(temp(:,i)'*temp(:,i));
    end
    Cij{m} = (temp'*temp)./(divby'*divby);
    % get Cij for this window
    uptri = triu(Cij{m},1);
    uptri = uptri(uptri~=0);
    CAvg(m) = mean(uptri(~isnan(uptri))); % get average Cij
    m = m + 1;
    n = n + step;
    w = w + step; %update indices
    clear temp col uptri i j tempsum divby
end

clear n m w

end

