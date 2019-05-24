function [BC, SC, thresh] = cthresh(Cij)

% cthresh - Percolation threshold of Cij
% Find the percolation threshold of Cij by seeing where there's a jump in
% the giant component. Input is the correlations matrix Cij, outputs are
% giant component and second component sizes "BC" and "SC" (respectively), 
% and the percolation threshold "thresh."

percs = -1:.01:1; %thresholds to percolate over
BC = zeros(length(percs),1);
SC = zeros(length(percs),1); %book arrays
l = length(Cij);

for i=1:length(percs)
    temp = Cij;
    temp(temp<=percs(i)) = 0; %get rid of all edges that are too low
    [~,s,~] = networkComponents(temp);
    BC(i) = s(1); %size of giant component
    if length(s)>1
        SC(i) = s(2); %size of second component, if it exists
    end
    clear temp s
end, clear i

BC = BC/l;
SC = SC/l; %scale to network size

cdiff = BC(1:end-1) - BC(2:end); %find all jumps in giant component size
thresh = percs(find(cdiff==max(cdiff),1,'last') + 1); %get threshold

end

