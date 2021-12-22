load('voronoi_decomposition.sage')
from sage.plot.plot3d.index_face_set import IndexFaceSet
from sage.graphs.orientations import random_orientation
from sage.plot.plot3d.texture import Texture

G = graphs.CompleteGraph(5)
E = G.edges()
for e in E:
    G.set_edge_label(e[0],e[1],1)
D = G.random_orientation()


