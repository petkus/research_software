from inspect import signature
from sage.misc.prandom import uniform

# Visualize graph G with assigned variables on each edge
def visualize(G, edge_function = None, vertex_function = None):
    G.relabel()
    options = {
        'edge_labels': False,
        'vertex_labels': False,
        'color_by_label': True
    }
    H = G.graphplot(**options)
    H.show()
    return H

# Returns a ring of rational functions where the indeterminants are assigned to
# the edge lengths of G. If n != 0, then there are n indeterminants assigned to
# the edge lengths of G, assigned in a cyclic fashion based off the order of edges
def assign_variables(G, n=0):
    if n < 0:
        raise ValueError("number of indeterminants must be nonegative")
    if n == 0:
        n = len(G.edges())
    G.allow_multiple_edges(True)
    polys = PolynomialRing(QQ,n,"z").fraction_field()
    z = polys.gens()
    i = 0
    for u,v in G.edges(labels=0):
        G.set_edge_label(u,v,z[i%n])
        i += 1
    return polys

# Assigns edge lengths according to the given list of lengths L
def assign_lengths(G, L):
    if len(G.edges()) != len(L):
        raise ValueError("Number of given lengths is different than number of edges")
    i = 0
    for e in G.edges():
        G.set_edge_label(e[0],e[1], L[i])
        i += 1
    return G

# Assigns edge lengths according to the given list of lengths L
def assign_random_lengths(G):
    for e in G.edges():
        r = random()
        G.set_edge_label(e[0],e[1], r)
    return G

# Removes vertices of degree two from model of metric graph
# TODO
def delete_two_degrees(G):
    no_vertices = True
    while no_vertices:
        no_vertices = True
        for v in G.vertices():
            if G.degree(v) == 2:
                no_vertices = False
                e = G.neighbors(v)
                l1 = G.edge_label(v,e[0])
                l2 = G.edge_label(v,e[0])
                G.delete_vertex(v)
                G.add_edge(e[0],e[1])
                if l1 != None and l2 != None:
                    G.set_edge_label(e[0],e[1],l1 + l2)
    return G

# Subdivides each edge of the input graph n times, then relabels vertices and
# labels each edge as 1/n times the length of the original edge
def subdivide(G,n):
    E = frozenset(G.edges())
    for e in E:
        x = e[0]
        y = e[1]
        G.delete_edge(e)
        i = 1/n
        G.add_edge(x, (x,y,i), e[2]/n)
        for s in range(1,n-1):
            G.add_edge((x,y,i), (x,y,i + 1/n), e[2]/n)
            i += 1/n
        G.add_edge((x,y,i), y, e[2]/n)
    G.relabel()
    return G

# Tests whether the given function f is convex by randomly plotting points
# between lower_bound and upper_bound test_num number of times.
# param_num should be the number of input variables for f. If param_num is 0
# then param_num is automatically set to len(signature(f).parameters)).
def convexity_test(f, param_num = 0, lower_bound = 1, upper_bound = 2, test_num
                   = 100, printing = True):
    x1 = []
    x2 = []
    if param_num == 0:
        param_num = len(signature(f).parameters)
    for i in range(test_num):
        x1 = [RealField(20)(uniform(lower_bound,upper_bound)) for i in range(param_num)]
        x2 = [RealField(20)(uniform(lower_bound,upper_bound)) for i in range(param_num)]
        xm = [(x1[i] + x2[i])/2 for i in range(param_num)]
        y1 = (f(*x1) + f(*x2))/2
        y2 = f(*xm)
        if y1 < y2 - .0001:
            if printing:
                print("Convexity test: False")
                print("y1 < y2 = " + str(y1 < y2))
                print("x1 = " + str(x1))
                print("x2 = " + str(x2))
                print("xm = (x1 + x2)/2 = " + str(xm))
                print("y1 = (f(x1) + f(x2))/2 = " + str(y1))
                print("y2 = f(xm) = " + str(y2))
            return False
    if printing:
        print("Convexity test: True")
    return True

# Same as convexity_test but now F is a function which outputs a dictionary
# indexed by edges E. convexity_test_edge_dictionary outputs a dictionary with
# entries of the form {e: True/False} based off if the eth entry passed a
# convexity test.
def convexity_test_edge_dictionary(F, E, lower_bound = 1, upper_bound =
                              2, test_num = 60, printing = False):
    x1 = []
    x2 = []
    E = [(e[0],e[1]) for e in E]
    ans = {e:True for e in E}
    for i in range(test_num):
        x1 = [RealField(20)(uniform(lower_bound,upper_bound)) for e in E]
        x2 = [RealField(20)(uniform(lower_bound,upper_bound)) for e in E]
        xm = [(x1[i] + x2[i])/2 for i in range(len(E))]
        F1 = F(*x1)
        F2 = F(*x2)
        Y1 = {e: (F1[e] + F2[e])/2 for e in E}
        Y2 = F(*xm) 
        ans = {e: ans[e] and Y1[e] >= Y2[e] - .01 for e in E}
    return ans

# Same as convexity_test but now F is a function which outputs a dictionary
# indexed by vertices V. convexity_test_vertex_dictionary outputs a dictionary
# with entries of the form {v: True/False} based off if the vth entry passed a
# convexity test.
def convexity_test_vertex_dictionary(F, V, param_num, lower_bound = 1, upper_bound =
                              2, test_num = 60, printing = False):
    x1 = []
    x2 = []
    ans = {v:True for v in V}
    for i in range(test_num):
        x1 = [RealField(20)(uniform(lower_bound,upper_bound)) for k in range(param_num)]
        x2 = [RealField(20)(uniform(lower_bound,upper_bound)) for k in range(param_num)]
        xm = [(x1[k] + x2[k])/2 for k in range(param_num)]
        F1 = F(*x1)
        F2 = F(*x2)
        Y1 = {v: (F1[v] + F2[v])/2 for v in V}
        Y2 = F(*xm)
        ans = {v: ans[v] and Y1[v] >= Y2[v] - .01 for v in V}
    return ans
        
# Returns the laplacian_matrix with edge weights treated as resistances 
# i.e L[i,i] = sum over e incident to i of 1/r(e)
# i.e L[i,j] = 1/r(e) where e = (i,j)
# polys should be a field containing indeterminants associated to the edge weights.
def laplacian_matrix(G,polys=RR):
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

# As done in 4.3 of https://arxiv.org/pdf/1810.02639.pdf
# Returns the matrix with (x,y) entry equal to j_q(x,y)
# polys is the fraction field containing the resistances on G
def j_functions(q, G, polys=RR):
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

# Returns effective resistance matrix whose [v,w] entry is the effective
# resistance between vertices v and w
# polys is the fraction field containing the resistances on G
def resistance_matrix(G, J = None, polys = RR):
    if J == None:
        J = j_functions(0,G,polys)
    n = len(G.vertices())
    R = zero_matrix(polys,n)
    for v in range(1,n):
        R[0,v] = J[v,v]
        R[v,0] = J[v,v]
        for w in range(1,n):
            R[v,w] = J[v,v] + J[w,w] - 2*J[v,w]
    return R

# Returns a dictionary of the Foster's coefficients 
# of the form {e: fosters coefficient of e}
def fosters(G, R = None, labels = True, printing = False):
    W = 0
    E = set(G.edges())
    if R != None:
        if labels:
            F = {e:(1 - R[e[0],e[1]]/e[2]) for e in E}
        else:
            F = {(e[0],e[1]):(1 - R[e[0],e[1]]/e[2]) for e in E}
        return F
    if labels:
        F = {e:0 for e in E}
    else:
        F = {(e[0],e[1]):0 for e in E}
    if printing:
        print("Calculating Fosters coefficients")
        print("spanning_trees = %i" %G.spanning_trees_count())
        count = 1
    for T in G.spanning_trees(labels = True):
        if printing:
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
            if labels:
                F[e] += p
            else:
                F[(e[0],e[1])] += p
        W += p
    for e in F.keys():
        F[e] = F[e]/W
    return F

# Returns a dictionary of the curvature at each vertex 
# of the form {v: curvature at v}
def curvature(G, R = None):
    C = {v:1 for v in G.vertices()}
    if R == None:
        R = resistance_matrix(G)
    for e in G.edges():
        v = e[0]
        w = e[1]
        C[v] -= 1/2 * R[v,w] / e[2]
        C[w] -= 1/2 * R[v,w] / e[2]
    return C

# Performs series reduction to graph with edges e and w in series
def series_reduction(e, w, G):
    G.allow_multiple_edges(True)
    G = copy(G)
    r1 = e[2]
    r2 = w[2]
    vertices = list({e[0], e[1]} ^^ {w[0], w[1]})
    if len(vertices) != 2:
        print("Cannot perform series reduction (edges not incident)")
        return 
    v = list({e[0], e[1]} & {w[0], w[1]})[0]
    if G.degree(v) != 2:
        print("Cannot perform series reduction (edges not a bridge)")
        return
    G = copy(G)
    G.delete_edges([e,w])
    G.add_edge(([vertices[0], vertices[1], r1 + r2]))
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
# e is a fixed edge, F is the fosters coefficients, polys is the ring of
# rational functions
def tau_first_summand(e,F,polys=RR):
    return 1/12 * F[e]^2 * e[2]

# Calculates one summand in theorem 10.2 of https://arxiv.org/pdf/1810.02639.pdf
# e is a fixed edge, J is a j_functions matrix, polys is the ring of rational
# functions
def tau_second_summand(e,J,polys=RR):
    return 1/4 * (J[e[0],e[0]] - J[e[1],e[1]])^2/e[2]

# Calculates one summand in theorem 10.2 of https://arxiv.org/pdf/1810.02639.pdf
# e is a fixed edge, F is the fosters coefficients, J is a j_functions matrix,
# polys is the ring of rational functions
def tau_summand(e,F,J,polys=RR):
    return tau_first_summand(e,F,polys) + tau_second_summand(e,J,polys)

# Using theorem 10.2 in https://arxiv.org/pdf/1810.02639.pdf
# calculates the tau constant of a given graph with given fosters coefficients
# Note that this algorithm is fast if the fosters coefficients are known
def tau(G,polys=RR):
    q = G.vertices()[0]
    J = j_functions(q, G, polys)
    R = resistance_matrix(G,J,polys)
    F = fosters(G,R)
    s = 0
    for e in G.edges():
        s += tau_summand(e,F,J,polys)
    return s

# Returns a function whose input is the lengths of G and whose output is the
# input_function applied to G
def to_function(input_function, G, e = False, F = False, labels = True):
    G.relabel()
    if not (e and F) and labels:
        def func(*args):
            assign_lengths(G, args)
            return input_function(G)
    if e and not F and labels:
        def func(*args):
            assign_lengths(G, args)
            E = G.edges()
            return {(e[0], e[1]): input_function(e,G) for e in E}
    if not e and not F and not labels:
        def func(*args):
            assign_lengths(G, args)
            return input_function(G, labels=False)
    if e and F and labels:
        def func(*args):
            assign_lengths(G, args)
            E = G.edges()
            F = fosters(G,resistance_matrix(G))
            return {(e[0], e[1]) :input_function(e, F, G) for e in E}
    return func

# Tests the convexity of the tau constant for a given combinatorial graph G.
def tau_test_convexity(G, printing=False):
    func = to_function(tau,G)
    return convexity_test(func, len(G.edges()), printing=printing)

# Finds the minimum value of tau for a given graph G with total length 1
#TODO
def tau_minimum(G):
    G.relabel()
    polys = assign_variables(G)
    z = polys.gens()
    f = tau_function(G,z)
    

def discrete_tau(G, n):
    Gn = copy(G)
    subdivide(Gn,n)
    R = resistance_matrix(Gn)
    nm = len(Gn.vertices())
    s = 0
    for v in Gn.vertices():
        for w in Gn.vertices():
            s += R[v,w]
    return s/(2 * nm^2)



