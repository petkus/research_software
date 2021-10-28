# Generates the flip graph of the n-gon
def flipGraph(n):
    #initialize triangulation t
    t = set([frozenset([1,s,s+1]) for s in range(2,n)])
    i = 0
    #dictionary labeling of triangulations
    D = {frozenset(t): i}
    #collection of triangulations with no new edges
    exhausted = set([])
    E = []
    while exhausted != set(D.keys()):
        for s in t:
            noFreeEdges = False
            Break = False
            ts = copy(t)
            ts.remove(s)
            for c in ts:
                S = list(s ^^ c)
                #if s and c can flip
                if len(S) == 2:
                    #tc is triangulation from resulting flip
                    tc = copy(ts)
                    tc.remove(c)
                    I = list(s & c)
                    tc.add(frozenset([S[0],S[1],I[0]]))
                    tc.add(frozenset([S[0],S[1],I[1]]))
                    # if tc has not been indexed before
                    if not(frozenset(tc) in D.keys()):
                        i = i+1
                        D[frozenset(tc)] = i
                    edge = set([D[frozenset(t)],D[frozenset(tc)]])
                    # if (t, tc) is a new edge
                    if not (edge in E):
                        E += [edge]
                        Break = True
                        t = tc
                        break
            if(Break):
                break
            noFreeEdges = True
        #if there is no free edge
        if noFreeEdges:
            exhausted.add(frozenset(t))
            for tri in D.keys():
                if not (tri in exhausted):
                    t = set(tri)
                    break
    G = Graph(E)
    return G



