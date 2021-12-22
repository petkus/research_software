load('voronoi_decomposition.sage')
from sage.plot.plot3d.index_face_set import IndexFaceSet
from sage.graphs.orientations import random_orientation
from sage.plot.plot3d.texture import Texture

G = graphs.CompleteGraph(5)
E = G.edges()
for e in E:
    G.set_edge_label(e[0],e[1],1)
D = G.random_orientation()

# For the graphic
D = DiGraph([[0,1,1], [1,2,1], [0,2,1], [0,3,1],[2,3,1/2],[0,4,3/2],[4,3,3/2]]) 
G = D.to_undirected()
E = D.edges()

# Cols of M are pi(e)
M, dic = kirchhoff_projection_matrix(D)
# basis of H1
C1 = [(0,2,1),(2,1,1),(1,0,1)]
C2 = [(0,2,1),(2,3,1/2),(3,0,1)]
C3 = [(3,0,1),(4,3,3/2),(0,4,3/2)]
v1 = vec(C1,E)
v2 = vec(C2,E)
v3 = vec(C3,E)

# Identifying H1 with RR^3
b1 = vector([sqrt(3),0,0])
b2 = vector([1/sqrt(3),1/2,sqrt(5/2 - 1/3 - 1/2)])
b3 = vector([0,2,0])
Bs = matrix(RR,[b1,b2,b3]).transpose()
o = vector([0,0,0])

# H += line3d([o, b1], color='black',)

# B has col basis corresponding to cycles
B = matrix(QQ,[v1,v2,v3]).transpose()
Binv = B.pseudoinverse()   

# We have B * Minv = M
Minv = Binv * M

Vs = Bs*Minv
#Deleting duplicates
Vs = Vs.delete_columns([4,6])  
S = matrix.identity(RR, len(E)-2,len(E)-2)
S[0,0] = 2
S[3,3] = 2
Vs = Vs * S
v0, v1, v2, v3, v4 = Vs.columns()
v01, v11, v21, v31, v41 = Vs.columns()


face_list = []

B = [o,b1,b2,b3,b1+b2, b1+b3, b2+b3, b1+b2+b3]
B += [2*b2,2*b3,-b3, b1 - b2 + b3, b1 - b2, b3 - b2]

# for v in [v0,v1,v2,v3]:
#     S = [v0,v1,v2,v3]
#     S.remove(v)
#     face_list += [[tuple(b),tuple(v + b),tuple(w + b),tuple(v + w + b)] for w
#                   in S for b in B]

for v in [v1, v2, v3]:
    face_list += [[tuple(b), tuple(b + v0), tuple(b + v + v0), tuple(b + v)] for b in B]

for v in [v2, v3]:
    face_list += [[tuple(b), tuple(b + v1), tuple(b + v + v1), tuple(b + v)] for b in B]

face_list += [[tuple(b), tuple(b + v2), tuple(b + v2 + v3), tuple(b + v3)] for b in B]

for v in [v0, v1, v2, v3]:
    face_list += [[tuple(b + v1), tuple(b + v1 + v4), tuple(b + v1 + v4 + v), tuple(b + v1 + v)] for b in B]

face_list += [[tuple(o), tuple(v1), tuple(v3 + v1), tuple(v3)]]
# face_list += [[tuple(b + v1),tuple(w + b + v1),tuple(v4 + b + v1),tuple(v4 + w + b + v1)]
#               for w in [v0,v1,v2,v3] for b in B]

col = rainbow(10, 'rgbtuple')
H = IndexFaceSet(face_list, frame=False, color='blue', alpha=.2)

def condi(x,y,z):
    S = Bs.inverse() * vector([x,y,z],RR)
    xslope = 0.577350269189626/1.29099444873581
    yslope = .5/1.29099444873581
    ans = bool(1.29099444873581 >= z and z >= 0 
               and x >= z * xslope and z * xslope + 1.73205080756888 >= x)
    return ans

def condi2(x,y,z):
    yslope = .5/1.29099444873581
    return y >= z*yslope and z* yslope +2 >= y

H = H.add_condition(condi, N=200)
H = H.add_condition(condi2, N=200)

H += line3d([o, b1], color='black',frame=False)
H += point3d(b1, color='black')
H += text3d("b1", b1, color='black')
H += line3d([o, b2], color='black')
H += point3d(b2, color='black')
H += text3d("b2", b2, color='black')
H += line3d([o, b3], color='black')
H += point3d(b3, color='black')
H += text3d("b3", b3, color='black')
H += text3d("0", o, color='black')

H += line3d([b1, b1 + b2], color='black')
H += line3d([b1, b1 + b3], color='black')
H += line3d([b2, b2 + b3], color='black')
H += line3d([b2, b1 + b2], color='black',linestyle=":")
H += line3d([b3, b1 + b3], color='black',linestyle=":")
H += line3d([b3, b2 + b3], color='black',linestyle=":")
H += line3d([b1 + b2, b1 + b2 + b3], color='black',linestyle=":")
H += line3d([b1 + b3, b1 + b2 + b3], color='black',linestyle=":")
H += line3d([b2 + b3, b1 + b2 + b3], color='black',linestyle=":")


H += point3d(v1 + b3, color='blue')
H += text3d("q1", v1 + b3, color='blue')
H += point3d(v1 + b3 + v4, color='blue')
H += text3d("q2", v1+b3 + v4, color='blue')
H += line3d([b3 + b1,v1 + b3], color='blue')
H += line3d([b3,v1 + b3], color='blue')
H += line3d([v1 + b3 + v4,v1 + b3], color='blue')
H += line3d([v1 + b3 + v4,b2 + b3], color='blue')
H += line3d([v1 + b3 + v4,b2], color='blue')


# Vs = matrix.zero(RR,3,len(E))

# for i in range(len(E)): 
#     for j in range(3): 
#         Vs[j,i] += RR(b1[j])*RR(Minv[0][i]) 

# for i in range(len(E)): 
#     for j in range(3): 
#         Vs[j,i] += RR(b2[j])*RR(Minv[1][i]) 

# for i in range(len(E)): 
#     for j in range(3): 
#         Vs[j,i] += RR(b3[j])*RR(Minv[2][i]) 


visualize(D).plot()

