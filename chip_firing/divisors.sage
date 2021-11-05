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

