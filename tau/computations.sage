load('fosters_expressions.sage')

# Diamond Necklace Definition
def diamond_necklace(t,a):
    b = RR(1/5 * (1/t - a))
    es = []
    v = '00'
    vs = [v]
    for i in range(t - 1):
        vs += [str(i) + '1', str(i) + '2', str(i) + '3']
        vs += [str(i + 1) + '0']
        es += [(str(i) + '0', str(i) + '1', a),
               (str(i) + '1', str(i) + '2', b),
               (str(i) + '1', str(i) + '3', b),
               (str(i) + '2', str(i) + '3', b),
               (str(i + 1) + '0', str(i) + '2', b),
               (str(i + 1) + '0', str(i) + '3', b)]
    n = t - 1
    vs += [str(n) + '1', str(n) + '2', str(n) + '3']
    es += [(str(n) + '0', str(n) + '1', a),
           (str(n) + '1', str(n) + '2', b),
           (str(n) + '1', str(n) + '3', b),
           (str(n) + '2', str(n) + '3', b),
           ('00', str(n) + '2', b),
           ('00', str(n) + '3', b)]
    G = Graph(es)
    G.relabel()
    return(G)

# Computations:
if False:
    # Complete Graphs
    for n in range(4,9):
        G = graphs.CompleteGraph(n)
        print("Complete graph on %i verticies"%n)
        test(G)
        print()

    # Ladder Graphs
    for n in range(3,8):
        G = graphs.GridGraph([2,n])
        G.relabel()
        print("Ladder graph with %i rows"%n)
        test(G)
        print()

    # Grid Graphs
    for n in range(3,8):
        G = graphs.GridGraph([n,n])
        G.relabel()
        print("Grid graph with %i rows and columns"%n)
        test(G)
        print()

    # Petersen Graph
    G = graphs.PetersenGraph()
    G.relabel()
    print("Petersen Graph")
    test(G)
    print()

if True:
    # Diamond Necklace
    t = 20
    for a in [RR(1/200), RR(1/100), RR(1/50), RR(1/20)]:
        print("Diamond Necklace with t = %i and a = %f"% (t,a))
        G = diamond_necklace(t,a)
        print("tau = ", tau(G))
    test(G)


