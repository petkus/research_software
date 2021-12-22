# Visualize digraph D with assigned variables on each edge
def visualize(D):
    H = D.plot(edge_labels=True)
    return H

# Returns the reverse edge of e
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
        if P == [] and T.edges() == []:
            raise ValueError("no fundamental cycle exists")
        if v == s:
            return P
        for e in T.edges():
            if s in {e[0], e[1]}:
                T.delete_edge(e)
                if s == e[0]:
                    P.append(e)
                    s = e[1]
                else:
                    P.append(er(e))
                    s = e[0]
                return fundCycleHelper(T,P, v,s)
        e = P[len(P) - 1]
        s = e[1]
        P = P[:len(P) - 1]
        return fundCycleHelper(T, P, v, e[0])
    if e in T.edges() or er(e) in T.edges():
        return []
    Tc = copy(T)
    return fundCycleHelper(Tc,[e],e[0], e[1])

# Returns a basis for the cycle space consisting of the fundamental cycles of tree T
# formated as a list of vectors.
def TBasis(T,E):
    Basis = {}
    for e in E:
        if e not in T.edges() and er(e) not in T.edges():
            C = fundCycle(T,e)
            Basis[e] = vec(C,E)
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
    H2 = C2.subspace([B[e] for e in B.keys()])
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
def f_cost(f,C,E):
   return sum(E[i][2]*(1 - 2*C[i]*f[i]) for i in range(len(f)))

# Returns the tree with get_vertex() method returning the shortest path from q to v
def T_paths(T,q):
    if T.spanning_trees_count() != 1:
        raise ValueError("T is not a tree: ", str(E))
    T = copy(T)
    E = T.edges()
    S = {q}
    T.set_vertex(q,[])
    while S != set(T.vertices()):
        for e in E:
            if e[0] in S and e[1] not in S:
                S.add(e[1])
                T.set_vertex(e[1], T.get_vertex(e[0]) + [e])
            if e[0] not in S and e[1] in S:
                S.add(e[0])
                T.set_vertex(e[0], T.get_vertex(e[1]) + [e])
    return T

# Returns the tree with get_vertex() method returning f_cost of path to each vertex.
def f_T_cost(f,T,E,q):
    T = T_paths(T,q)
    for v in T.vertices():
        T.set_vertex(v, f_cost(f,T.get_vertex(v),E))
    return T

# Checks whether the given flow is in the Voronoi polytope
def isVoronoi(f, D):
    for C in minimalCycles(D):
        if f_cost(f, C) < 0:
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

# Returns the edges in G that are not in a given subgraph T
def complement_edges(T,G):
    G = copy(G)
    if G.is_directed():
        G.delete_edges([e for e in T.edges()])
        G.delete_edges([er(e) for e in T.edges()])
    else:
        G.delete_edges(T.edges())
        return G.edges()

# TODO CHECK IF TRUE
# Returns the resulting tree from doing an edge exchange with the given
# oriented tree T and edge e. If such an edge exchange is not possible (i.e. e
# corresponds to a direction moving outside the voronoi polytope) then return
# T.
def edge_exchange(T,e,D,immutable=True):
    if e in T.edges() or er(e) in T.edges():
        return T
    Tc = T.copy(immutable=False)
    C = fundCycle(Tc,e)
    v = e[1]
    for w in Tc.neighbors(v):
        if (w,v) in Tc.edges(labels = False):
            Tc.delete_edge([w,v])
            Tc.add_edge(e)
            if Tc.is_connected():
                return Tc.copy(immutable=immutable)
            else:
                return T
    return Tc.copy(immutable=immutable)

# Returns the weight of a spanning tree equal to the product of conductances
# of edges inside of T
def weight(T):
    w = 1
    for e in T.edges():
        w *= 1/e[2]
    return w

# Returns the sum of weights of spanning trees of G
def G_weight(G):
    return sum(weight(T) for T in G.spanning_trees(labels=True))

# TODO Check if true
# Returns the projection matrix from the edge space to the flow space of G
# with respect to the (not necessarily orthonormal) basis of edges.
def kirchhoff_projection_matrix(D):
    E = D.edges()
    G = D.to_undirected()
    dic = {E[i]:i for i in range(len(E))}
    W = G_weight(G)
    M = matrix.zero(QQ,len(E),len(E))
    for T in G.spanning_trees(labels=True):
        w = weight(T)
        B = TBasis(T,E)
        for e in B.keys():
            for i in range(len(E)):
                M[i,dic[e]] += w*B[e][i]
    return (M/W, dic)

# Returns a tuple (d, H) where H is the graph whose vertices corresponds to
# spanning trees of G and whose edges correspond to whether the corresponding
# cells share a facet and d is a dictionary of the form {spanning_tree of G:
# vertex of H}
def cell_neighbor_graph(G,q):
    count = G.spanning_trees_count()
    if count < 1:
        raise ValueError("G is disconnected")
    Ts = G.spanning_trees(labels = False)
    E = G.edges(labels = False)
    d = {}
    H = graphs.EmptyGraph()
    H.add_vertices(range(count))
    for i in range(count):
        T = Tq(next(Ts), q, immutable = True)
        d[T] = i
        H.set_vertex(i, T)
    for T in d.keys():
        for e in complement_edges(T,G):
            Te = edge_exchange(T,e,G)
            if T != Te:
                H.add_edge([d[T],d[Te]])
            Te = edge_exchange(T,er(e),G)
            if T != Te:
                H.add_edge([d[T],d[Te]])
    H = H.to_simple()
    return (d, H)

# TODO
# Returns the spanning tree corresponding to the cell containing f by randomly
# choosing a spanning tree, then performing edge exchanges
def f_q_optimal(D,f,q):
    E = D.edges()
    G = D.to_undirected()
    T = G.random_spanning_tree(output_as_graph=True)
    for e in T.edges():
        T.set_edge_label(e[0],e[1],G.edge_label(e[0],e[1]))
    T = f_T_cost(f,T,E,q)
    for e in complement_edges(T,G):
        return e
