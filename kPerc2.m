function [coresize, iter, corenodes, shellpop, shellnodes] = kPerc2(data,levels)

% K-core percolation. Input is a network and levels at which to try the
% percolation; outputs are (for each level) the size of the "core" left 
% after successive pruning of the network, the number of iterations taken
% to prune the network, and the cores left after each pruning.
% Edited 30 Jan 2017 to include function of getPoppin.m, which finds the 
% population of each shell -> new outputs include the percentage of nodes
% populating each shell from zero to the maximum and which nodes these are.

l = length(data);
data = data - eye(l).*data; % get rid of self-connexions since we don't need them
data = data~=0; % since we only need degree, just set all connexions to 1 for ease of computing
v = min([max(sum(data)),length(levels)]); % if desired maximum level is greater than the maximum possible level for this network, reduce and also tell the user
%if v<max(levels)
%    fprintf('The maximum level you input is larger than the maximum level possible for this network. I have changed it to %f.\n',v)
%end
coresize = [1; zeros(v,1)];
iter = ones(v+1,1);
corenodes = [ones(1,l); zeros(v,l)]; % put a row of ones at the top since everyone is a member of the zero shell (ditto for coresize)
shellnodes = zeros(l,1);
levels = [0 levels]; % append a zero since this step is included

for i=2:v
    s = sum(data); % if just pruning singletons, all we need is to find those nodes with no connexions
    if levels(i)>1
        f = find(s<levels(i) & s>0); % if pruning more than singletons: find all nodes with fewer connexions than the k-level we want
        while f
            r = f(randi(length(f))); % choose a node to delete at random
            data(r,:) = 0;
            data(:,r) = 0; % get rid of this guy; this deletes also all his connexions
            s = sum(data);
            f = find(s<levels(i) & s>0); % and now again, find all nodes with too-few connexions...lather, rinse, repeat
            iter(i) = iter(i) + 1;
        end
    clear f
    end
    coresize(i) = length(s(s>0))/l; % get fraction of original network which makes up the core for this level of k
    corenodes(i,s>0) = 1; % mark with a "1" if this node is still surviving
end

shellpop = coresize(1:end-1) - coresize(2:end); % find percentage of nodes that belong to each k-shell, i.e., who will disappear if k = n+1

for i=1:l
   shellnodes(i) = find(corenodes(:,i),1,'last'); % find the shell at which each node vanishes; this is its k-shell
end

end
        
    
