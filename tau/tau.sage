from inspect import signature
from sage.misc.prandom import uniform

# Visualize graph G
def visualize(G):
    H = G.plot(edge_labels=True)
    return H

def assignVariables(G):
    G.allow_multiple_edges(True)
    polys = PolynomialRing(QQ,len(G.edges()),"z").fraction_field()
    z = polys.gens()
    i = 0
    for u,v in G.edges(labels=0):
        G.set_edge_label(u,v,z[i])
        i += 1
    return polys

# Implimenting https://onlinelibrary.wiley.com/doi/10.1002/net.1975.5.3.237
# TODO  https://sci-hubtw.hkvisa.net/10.1002/net.1975.5.3.237
# https://www.w3schools.com/python/python_iterators.asp
def set_of_spanning_trees(G):
    if not G.connected():
        return {}

# TODO
def set_of_spanning_trees_helper(G):
    return {}

# Tests whether the given function f is convex by randomly plotting points
def convexity_test(f, param_num, lower_bound = 0, upper_bound = 1, test_num = 500):
    x1 = []
    x2 = []
    for i in range(test_num):
        x1 = [uniform(0,1) for i in range(param_num)]
        x2 = [uniform(0,1) for i in range(param_num)]
        xm = [(x1[i] + x2[i])/2 for i in range(param_num)]
        y1 = N((f(*x1) + f(*x2))/2, digits=6)
        y2 = N(f(*xm), digits=6) - .000001
        if y1 < y2:
            print("Failed test: ")
            print("y1 < y2 = " + str(y1 < y2))
            print("x1 = " + str(x1))
            print("x2 = " + str(x2))
            print("xm = " + str(xm))
            print("y1 = " + str(y1))
            print("y2 = " + str(y2))
            return False
    return True
        

# Returns the Canonical Divisor for G as a dictionary 
# of the form {vertex v: integer D(v)}
def canonical_divisor(G):
    V = G.vertices()
    D = {v:0 for v in V}
    for v in V:
        D[v] = G.degree(v) - 2
    return D

# Returns the edges incident to vertex v
def star(v, G):
    S = set()
    for e in G.edges():
        if v in e:
            S.add(e)
    return S

# Returns the resulting divisor after chip firing at vertex v
def vertex_fire(v, D, G):
    D[v] = D[v] - G.degree(v)
    for e in star(v, G):
        w = filter(lambda s: s != v, e)[0]
        D[w] = D[w] + 1
    return D

# Returns the resulting divisor after chip firing at vertex set S
def fire(S, D, G):
    for v in S:
        D = vertexFire(v,D,G)
    return D

# Returns the laplacian_matrix with edge weights treated as resistances 
# i.e L[i,i] = sum over e incident to i of 1/r(e)
# i.e L[i,j] = 1/r(e) where e = (i,j)
def laplacian_matrix(G,polys):
    n = len(G.vertices())
    L = matrix(polys,n,n)
    for e in G.edges():
        i = e[0]
        j = e[1]
        L[i,i] += 1/e[2]
        L[j,j] += 1/e[2]
        L[i,j] -= 1/e[2]
        L[j,i] -= 1/e[2]
    return L

# As done in 4.3 of Metric graphs, cross ratios, and Rayleigh's laws
# Returns the matrix with (x,y) entry equal to j_q(x,y)
# polys is the fraction field containing the resistances on G
def j_functions(q, G, polys):
    L = laplacian_matrix(G,polys)
    Lq = L.delete_columns([q]).delete_rows([q])
    n = Lq.dimensions()[0]
    Q = Lq.inverse()
    rows = Q.rows()
    rows[q:q] = [(0,)*n]
    Q = matrix(rows)
    rows = Q.transpose().rows()
    rows[q:q] = [(0,)*(n+1)]
    Q = matrix(rows).transpose()
    return Q

# Returns effective resistance between vertices v and w
# polys is the fraction field containing the resistances on G
def res(v,w,G, polys):
    return j_functions(v,G, polys)[w,w]

# Returns Foster's coefficient of given edge
# polys is the fraction field containing the resistances on G
def fosters(G):
    W = 0
    E = set(G.edges())
    F = {e:0 for e in G.edges()}
    print("Calculating Fosters coefficients")
    print("spanning_trees = %i" %G.spanning_trees_count())
    count = 1
    for T in G.spanning_trees(labels = True):
        if count % 10000 == 0:
            print("count = %i" %count)
        count += 1
        p = 1
        S = E.copy()
        for s in T.edges():
            S.remove(s)
        for e in S:
            w = e[2]
            p *= w
        for e in S:
            w = e[2]
            F[e] += p
        W += p
    for e in G.edges():
        F[e] = F[e]/W
    return F

# Performs series reduction to graph with edges e and w in series
def series_reduction(e, w, G):
    G.allow_multiple_edges(True)
    G = copy(G)
    r1 = e[2]
    r2 = w[2]
    verticies = list({e[0], e[1]} ^^ {w[0], w[1]})
    if len(verticies) != 2:
        print("Cannot perform series reduction (edges not incident)")
        return 
    v = list({e[0], e[1]} & {w[0], w[1]})[0]
    if G.degree(v) != 2:
        print("Cannot perform series reduction (edges not a bridge)")
        return
    G = copy(G)
    G.delete_edges([e,w])
    G.add_edge(([verticies[0], verticies[1], r1 + r2]))
    G.delete_vertex(v)
    return G

# Performs parallel reduction to graph with edges e and w in parallel
def parallel_reduction(e, w, G):
    G.allow_multiple_edges(True)
    vs = list({e[0], e[1]} & {w[0], w[1]})
    if len(vs) != 2:
        print("Cannot perform parallel reduction (edges not parallel)")
        return
    G = copy(G)
    r1 = e[2]
    r2 = w[2]
    G.delete_edges([e,w])
    G.add_edge([e[0],e[1], r1 * r2 / (r1 + r2)])
    return G

# Check if given edge is a loop
def checkLoop(e):
    if e[0] == e[1]:
        return True
    else:
        return False

# Performs Y to delta reduction to graph with edges e1, e2 and e3 in forming a Y
def wye_to_delta_reduction(e1,e2,e3, G):
    G.allow_multiple_edges(True)
    if checkLoop(e1) or checkLoop(e2) or checkLoop(e3):
        print("Cannot perform Y to delta reduction (one edge is a loop)")
        return 
    vs = list({e1[0], e1[1]} & {e2[0], e2[1]} & {e3[0], e3[1]})
    if len(vs) != 1:
        print("Cannot perform Y to delta reduction (edges not incident at one vertex)")
        return 
    v = vs[0]
    if G.degree(v) != 3:
        print("Cannot perform Y to delta reduction (common vertex is not degree three)")
        return 
    G = copy(G)
    r1 = e1[2]
    r2 = e2[2]
    r3 = e3[2]
    R = (r1*r2 + r2*r3 + r3*r1)
    l1 = list(({e2[0], e2[1]} | {e3[0], e3[1]}) ^^ {v})
    l1 += [R/r1]
    G.add_edge(l1)
    l2 = list(({e1[0], e1[1]} | {e3[0], e3[1]}) ^^ {v})
    l2 += [R/r2]
    G.add_edge(l2)
    l3 = list(({e1[0], e1[1]} | {e2[0], e2[1]}) ^^ {v})
    l3 += [R/r3]
    G.add_edge(l3)
    G.delete_vertex(v)
    return G

# Performs delta to Y reduction to graph with edges e1, e2 and e3 in forming a triangle
def delta_to_wye_reduction(e1,e2,e3, G):
    G.allow_multiple_edges(True)
    if checkLoop(e1) or checkLoop(e2) or checkLoop(e3):
        print("Cannot perform delta to Y reduction (one edge is a loop)")
        return 
    v1 = list({e2[0], e2[1]} & {e3[0], e3[1]})
    v2 = list({e1[0], e1[1]} & {e3[0], e3[1]})
    v3 = list({e2[0], e2[1]} & {e1[0], e1[1]})
    if len(v1) != 1 or len(v2) != 1 or len(v3) != 1:
        print("Cannot perform delta to Y reduction (edges do not form triangle)")
        return
    G = copy(G)
    v = max(G.vertices()) + 1
    G.add_vertex(v)
    r1 = e1[2]
    r2 = e2[2]
    r3 = e3[2]
    R = r1 + r2 + r3
    v1 = v1[0]
    G.add_edge(v1,v,r2*r3/R)
    v2 = v2[0]
    G.add_edge(v2,v,r1*r3/R)
    v3 = v3[0]
    G.add_edge(v3,v,r1*r2/R)
    G.delete_edges([e1,e2,e3])
    return G

# Calculates one summand in theorem 10.2 of https://arxiv.org/pdf/1810.02639.pdf
def tau_summand(e,F,J,polys):
        return 1/12 * F[e]^2 * e[2] + 1/4 * (J[e[0],e[0]] - J[e[1],e[1]])^2/e[2]

# Using theorem 10.2 in https://arxiv.org/pdf/1810.02639.pdf
# calculates the tau constant of a given graph with given fosters coefficients
# Note that this algorithm is fast if the fosters coefficients are known
def tau(G,F,polys):
    s = 0
    q = G.vertices()[0]
    J = j_functions(q, G, polys)
    for e in G.edges():
        s += tau_summand(e,F,J,polys)
    return s

# Returns a function whose inputs are indexed by the zs and whose output is the
# tau constant
# TODO
def tau_function(G,zs):
    F = fosters(G)
    i = 0
    func = 1
    def func(*args):
        S = {zs[j]:args[j] for j in range(len(zs))}
        Gc = G.copy()
        Fc = {}
        i = 0
        for e in Gc.edges():
            Gc.set_edge_label(e[0],e[1],S[e[2]])
            Fc[(e[0],e[1],S[e[2]])] = F[e].substitute(S)
        return tau(Gc,Fc,QQ)
    return func

# tests the convexity of the tau constant for a given graph G.
#TODO
def tau_test_convexity(G):
    polys = assignVariables(G)
    z = polys.gens()
    f = tau_function(G,z)
    return convexity_test(f, len(z))

# Finds the minimum value of tau for a given graph G with total length 1
#TODO
def tau_minimum(G):
    return {}
