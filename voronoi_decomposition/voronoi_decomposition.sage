# Visualize digraph D with assigned variables on each edge
def visualize(D):
    H = D.plot(edge_labels=True)
    return H

# returns the reverse edge of e
def er(e, labels = True):
    if labels:
        return (e[1],e[0],e[2])
    return (e[1],e[0])

# Returns a vector representing directed edge set C with entries {-1,0,1}
# consistant with orientation of E. Note order of entries of the output vector
# depends on the order E is encoded as a list.
def vec(C, E):
    if type(C) == DiGraph([]):
        C = C.edges()
    n = len(E)
    v = []
    for e in E:
        if e in C and (er(e) not in C):
            v.append(1)
        elif er(e) in C and (e not in C):
            v.append(-1)
        else:
            v.append(0)
    return vector(v)

# Returns a directed edge set which corresponds to the input vector v. This is
# the reversal of the vec function above.
# This method only works if v has entries in {-1,0,1}
def vecToEdgeSet(v,E):
    C = []
    n = len(E)
    for i in range(n):
        if v[i] not in {-1,0,1}:
            raise ValueError("Input vector does not have entries in {-1,0,1}")
        if v[i] == 1:
            C.append(E[i])
        if v[i] == -1:
            C.append(er(e))
    return C

# Returns fundamental cycle of edge e with respect to tree T as a list of
# oriented edges. The orientation of the cycle will be determined by the
# orientation of e
def fundCycle(T,e):
    # Helps return fundamental cycles of tree T
    def fundCycleHelper(T,P,v,s):
        if P == []:
            raise ValueError("no fundamental cycle exists")
        if v == s:
            return P
        for e in T:
            if s in {e[0], e[1]}:
                T.remove(e)
                if s == e[0]:
                    P.append(e)
                    s = e[1]
                else:
                    P.append(er(e))
                    s = e[0]
                return fundCycleHelper(T,P, v,s)
            e = P[len(P) - 1]
            P = P[:len(P) - 1]
            return fundCycleHelper(T, P, v, e[0])
    if e in T or er(e) in T:
        return []
    Tc = copy(T)
    return fundCycleHelper(Tc,[e],e[0], e[1])

# Returns a basis for the cycle space consisting of the fundamental cycles of tree T
# formated as a list of vectors.
def TBasis(T,E):
    Basis = []
    for e in E:
        if e not in T and er(e) not in T:
            C = fundCycle(T,e)
            Basis.append(vec(C))
    return Basis

# Returns a set of the minimal cycles of a directed graph D. This set will
# account for orientation, i.e. contain both orientations of every unoriented
# cycle C
def minimalCycles(D):
    E = D.edges()
    n = len(E)
    S = {}
    T = D.min_spanning_tree()
    B = TBasis(T,D)
    C2 = VectorSpace(GF(3),n)
    H2 = C2.subspace(B)
    for v in H2:
        for i in range(n):
            if v[i] == 2:
                v[i] = -1
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
    
# Returns the f cost of a vector. C should be a minimal cycle of D and f should
# be a vector in the cycle space.
def fCost(f,C,E):
    Cv = vec(C, E)
    return sum(E[i][2]*(1 - 2*Cv[i]*f[i]) for i in range(len(E)))

# Checks whether the given flow is in the Voronoi polytope
def isVoronoi(f, D):
    for C in minimalCycles(D):
        if fCost(f, C) < 0:
            return False
    return True

# Returns digraph associated to a given tree T with orientation away from
# vertex q.
def Tq(T, q, immutable = False):
    E = list(T.edges())
    if T.spanning_trees_count() != 1:
        raise ValueError("T is not a tree: ", str(E))
    S = {q}
    while S != set(T.vertices()):
        for e in E:
            if e[0] in S and e[1] not in S:
                S.add(e[1])
            if e[0] not in S and e[1] in S:
                E.remove(e)
                E.append(er(e))
                S.add(e[0])
    return DiGraph(E, immutable = immutable)

#TODO
def cell_neighbor_graph(G,q):
    count = G.spanning_trees_count()
    if count < 1:
        raise ValueError("G is disconnected")
    Ts = G.spanning_trees(labels = False)
    E = G.edges(labels = False)
    Dict = {Tq(next(Ts), q, immutable = True):i for i in
            range(count)} 
    H = []
    for T in G.spanning_trees():
        Tc = T.complement()
        for e in Tc.edges():
            if e[0] != q:
                Tc = copy(T) 
                Tc.add_edge(e)
                neig = T.neighbors(e[0])
                if len(neig) != 1:
                    raise ValueError("T is not a spanning tree: ",str(T.edges()))
                Tc.delete_edge(e[0], neig[0])
                H += [(Dict[Tc.copy(immutable = True)], Dict[T.copy(immutable = True)])]
            if e[1] != q:
                Tc = copy(T) 
                Tc.add_edge(e)
                neig = T.neighbors(e[1])
                if len(neig) != 1:
                    raise ValueError("T is not a spanning tree: ",str(T.edges()))
                Tc.delete_edge(e[1], neig[0])
                H += [(Dict[Tc.copy(immutable = True)], Dict[T.copy(immutable = True)])]
    H = Graph(H)
    H = H.to_simple()
    return (Dict, H)

# Returns the tree corresponding to the cell containing f
# TODO
def cellMembership(G, f, q):
    return True

