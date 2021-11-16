load('tests.sage')

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
if True:
    # Complete Graphs
    for n in range(5,8):
        G = graphs.CompleteGraph(n)
        print("Complete graph on %i vertices"%n)
        test(G)
        print()

if True:
    # Complete Bipartite Graph
    for n in range(3,6):
        G = graphs.CompleteBipartiteGraph(n,n)
        print("Complete bipartite graph on (%i , %i) vertices"%(n,n))
        test(G)
        print()

if True:
    # Ladder Graphs
    for n in range(3,6):
        G = graphs.GridGraph([2,n])
        G.relabel()
        print("Ladder graph with %i rows"%n)
        test(G)
        print()

if True:
    # 2d Grid Graphs
    for n in range(3,6):
        G = graphs.GridGraph([n,n])
        G = delete_two_degrees(G)
        G.relabel()
        print("2d Grid graph with %i rows and columns"%n)
        test(G)
        print()

if True:
    # 3d Grid Graphs
    for n in range(3,6):
        G = graphs.GridGraph([n,n,n])
        G = delete_two_degrees(G)
        G.relabel()
        print("3d Grid graph with %i rows and columns"%n)
        test(G)
        print()

if True:
    # Wheel Graphs
    for n in range(3,10):
        G = graphs.WheelGraph(n)
        G.relabel()
        print("Wheel graph with %i spokes"%n)
        test(G)
        print()

if True:
    # Petersen Graph
    G = graphs.PetersenGraph()
    G.relabel()
    print("Petersen Graph")
    test(G)
    print()

if True:
    # Cube Graph
    for n in range(3,7):
        G = graphs.CubeGraph(n)
        G.relabel()
        print("Cube Graph, dimension = ", n)
        test(G)
        print()

if True:
    # Octahedral Graph
    G = graphs.OctahedralGraph()
    G.relabel()
    print("Octahedral Graph")
    test(G)
    print()

if True:
    # Tetrahedral Graph
    G = graphs.TetrahedralGraph()
    G.relabel()
    print("Tetrahedral Graph")
    test(G)
    print()

if True:
    # Dodecahedral Graph
    G = graphs.DodecahedralGraph()
    G.relabel()
    print("Dodecahedral Graph")
    test(G)
    print()

if False:
    # Diamond Necklace
    t = 20
    if False:
        for a in [RR(1/200), RR(1/100), RR(1/50), RR(1/20)]:
            print("Diamond Necklace with t = %i and a = %f"% (t,a))
            G = diamond_necklace(t,a)
            print("tau = ", tau(G))
    print("Diamond Necklace with t = %i"%t)
    test(G)
    print()
    t = 40
    print("Diamond Necklace with t = %i"%t)
    G = diamond_necklace(t,1)
    test(G)
    print()

# All graphs
if False:
    K = 11
    print("Testing Convexity for all graphs up to %i vertices"%K)
    convexity = True
    for k in range(3,K):
        for G in graphs.nauty_geng('-c ' + str(k)):
            if not tau_test_convexity(G):
                convexity = False
                print("Convexity test failed:")
                show(G)
                break
        if not convexity:
            break
        print("verified for %i vertices"%k)

