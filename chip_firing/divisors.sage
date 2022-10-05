
# Returns the Canonical Divisor for G as a dictionary 
# of the form {vertex v: integer D(v)}
def canonical_divisor(G):
    V = G.vertices()
    D = {v:0 for v in V}
    for v in V:
        D[v] = G.degree(v) - 2
    return D

# Returns the resulting divisor after chip firing at vertex v
def vertex_fire(v, D, G):
    D[v] = D[v] - G.degree(v)
    for w in G.neighbors():
        D[w] = D[w] + 1
    return D

# Returns the resulting divisor after chip firing at vertex set S
def fire(S, D, G):
    for v in S:
        D = vertexFire(v,D,G)
    return D

# Returns the 
def fire(S, D, G):
    for v in S:
        D = vertexFire(v,D,G)
    return D

# TODO
def q_reduced(D, q = 0, G):
    return D
