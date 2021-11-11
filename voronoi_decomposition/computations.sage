load('voronoi_decomposition.sage')
from sage.graphs.orientations import random_orientation

G = graphs.CompleteGraph(5)
E = G.edges()
for e in E:
    G.set_edge_label(e[0],e[1],1)
D =random_orientation(G)




show(visualize(D))

