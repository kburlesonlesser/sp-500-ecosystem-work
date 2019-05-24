# sp-500-ecosystem-work
Repository of code used in my final project, wherein I found that ecological and financial networks have a structure that shows precursors to network collapse and markers of network health.

Includes:

1. windowCij.m - divides time-series data into overlapping windows and computes Pearson correlation on each window so that we can see how correlations morph over time (used on stock market data).
2. cthresh.m - thresholds a network where each link is defined by pairwise correlation C(i,j) at increasing values of C(i,j) in order to see where the network breaks down. The value at which the largest connected component increases most drastically in size is the threshold of percolation and we can learn a lot about a given network from this.
3. kPerc2.m - performs a k-shell percolation on the network and finds the k-shell to which each node belongs as well as the fractional size of each k-shell and the absolute population of each k-shell. This is useful for learning which members of a network are the most important.
4. randmodel.m - used on ecological species-interaction networks that were bipartite and directed. Here, we are seeing if the network has a different structure than a same-sized Erdos-Renyi random network by examining the behavior of the k-shells.
4. nullmodel_bp.m - also used on the ecological networks. Finds the probability that the network differs from a null model of a random network.
