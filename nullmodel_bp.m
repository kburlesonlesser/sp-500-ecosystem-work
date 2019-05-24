function [pval, kavg, kmax_rand, kmax] = nullmodel_bp(adjmat, net)

% compare k-core attributes of an adjacency matrix to a null model for a 
% bipartite graph through repeated testing; inputs are the NxN adjacency 
% matrix "adjmat" and the network from which it was made, outputs are the
% p-value (or how probable it is that the matrix is random), the average
% degree, k-cores_max for the random case, and k-core_max for the actual
% network

N = length(adjmat);
[l,w] = size(net);
k_i = zeros(N,1);
kmax_rand = zeros(10000,1);
% get length of adjacency matrix and size of network; book vectors

for i=1:N
    k_i(i) = length(adjmat(i,adjmat(i,:)~=0));
end, clear i
% get degree of each node

kavg = sum(k_i)/N;
% average degree

for i=1:10000
    randgraph = zeros(N); % book space for random case
    probs = rand(l,w); % throw some numbers
    randgraph(1:l,(l+1):N) = probs<=(kavg/(N-1)); % for the random case, only add a link if the number is within probability defined by average degree
    randgraph = randgraph + randgraph'; % make the graph symmetrical
    [~,~,~,~,shells] = kPerc2(randgraph,1:N); 
    kmax_rand(i) = max(shells); % get the maximum k-core of this random case
    clear randgraph probs shells
end, clear i

[~,~,~,~,shells] = kPerc2(adjmat,1:N);
kmax = max(shells); % get maximum k-core of our actual network
pval = sum(kmax_rand>=kmax)/10000; % average how many trials resulted in kmax_rand equal to or greater than the maximum core for the real case

end


    