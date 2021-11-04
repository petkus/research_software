# CELL MEMBERSHIP

#TODO
D = DiGraph(G)

# V is vertex set of D. V is number of verticies
Vs = D.vertices()
V = len(Vs)

# l:E \to R is weight vector
def l(e):
    return e[2]

# Es is ordered list of edges of D. E is number of edges
Es = D.edges()

# Returns a vector representing edge set C with entries {-1,0,1} consistant with
# orientation of Es
def vec(C, Es):
    E = len(Es)
    v = []
    for i in srange(E):
        e = Es[i]
        er = (e[1], e[0], e[2])
        if e in C and (er not in C):
            v.append(1)
        elif er in C and (e not in C):
            v.append(-1)
        else:
            v.append(0)
    return vector(v)

def vecToEdgeSet(v,Es):
    C = []
    for i in srange(len(Es)):
        if v[i] == 1:
            C.append(Es[i])
        if v[i] == 2:
            er = (Es[i][1], Es[i][0], Es[i][2])
            C.append(er)
    return C


# Helps return fundamental cycles of tree T
def fundCycleHelper(T,P,v,s):
    if v == s:
        return P
    for e in T:
        if s in (e[0], e[1]):
            T.remove(e)
            if s == e[0]:
                P.append(e)
                s = e[1]
            else:
                P.append((e[1], e[0], e[2]))
                s = e[0]
            return fundCycleHelper(T,P, v,s)
    for e in P:
        if s in (e[0], e[1]):
            P.remove(e)
            return fundCycleHelper(T, P, v, e[0])

# Returns fundamental cycle of edge e with respect to tree T as a list of
# oriented edges
def fundCycle(T,e):
    if e in T:
        return []
    Tc = copy(T)
    return fundCycleHelper(Tc,[e],e[0], e[1])

# Returns a basis for the cycle space consisting of the fundamental cycles of tree T
def TBasis(T,Es):
    Basis = []
    for i in srange(len(Es)):
        e = Es[i]
        er = (e[1], e[0], e[2])
        if e not in T and er not in T:
            C = fundCycle(T,e)
            Basis.append(vec(C))
    return Basis

# Returns the minimal cycles of a directed graph D
def minimalCycles(D):
    Es = D.edges()
    S = set()
    T = D.min_spanning_tree()
    B = TBasis(T,D)
    C2 = VectorSpace(GF(3),len(Es))
    H2 = C2.subspace(B)
    for v in H2:
        C = vecToEdgeSet(v,Es)
        minimal = True
        for Co in S:
            if all(e in Co for e in C):
                S.remove(Co)
            if all(e in C for e in Co):
                minimal = False
                break
        if minimal:
            S.add(tuple(C))
    return S
    
# Returns the f cost of a vector
def fCost(f,C,E):
    Cv = vec(C)
    return sum(l(e)*(1 - 2*Cv[e]*f[e]) for e in srange(E))

# Checks whether the given flow is in the Voronoi polytope
def isVoronoi(f, D):
    for C in minimalCycles(D):
        if fCost(f, C) < 0:
            return False
    return True

# Returns the tree corresponding to the cell containing f
# TODO
def cellMembership(D, f):
    return True

