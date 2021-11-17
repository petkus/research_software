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
    for n in range(7,9):
        G = graphs.CompleteGraph(n)
        print("Complete graph on %i vertices"%n)
        print("***************************************************************************************")
        test(G)
        print()

if True:
    # Complete Bipartite Graph
    for n in range(5,7):
        G = graphs.CompleteBipartiteGraph(n,n)
        print("Complete bipartite graph on (%i , %i) vertices"%(n,n))
        print("***************************************************************************************")
        test(G)
        print()

if True:
    # Ladder Graphs
    for n in range(8,9):
        G = graphs.GridGraph([2,n])
        G.relabel()
        print("Ladder graph with %i rows"%n)
        print("***************************************************************************************")
        test(G)
        print()

if True:
    # 2d Grid Graphs
    for n in range(4,6):
        G = graphs.GridGraph([n,n])
        G.relabel()
        print("2d Grid graph with %i rows and columns"%n)
        print("***************************************************************************************")
        test(G)
        print()

if True:
    # 3d Grid Graphs
    for n in range(2,5):
        G = graphs.GridGraph([n,n,n])
        G.relabel()
        print("3d Grid graph with %i rows and columns"%n)
        print("***************************************************************************************")
        test(G)
        print()

if True:
    # Wheel Graphs
    for n in range(3,8):
        G = graphs.WheelGraph(n)
        print("***************************************************************************************")
        G.relabel()
        print("Wheel graph with %i spokes"%n)
        test(G)
        print()

if True:
    # Petersen Graph
    G = graphs.PetersenGraph()
    G.relabel()
    print("Petersen Graph")
    print("***************************************************************************************")
    test(G)
    print()

if True:
    # Cube Graph
    for n in range(3,5):
        G = graphs.CubeGraph(n)
        G.relabel()
        print("Cube Graph, dimension = ", n)
        print("***************************************************************************************")
        test(G)
        print()

if True:
    # Octahedral Graph
    G = graphs.OctahedralGraph()
    G.relabel()
    print("Octahedral Graph")
    print("***************************************************************************************")
    test(G)
    print()

if True:
    # Tetrahedral Graph
    G = graphs.TetrahedralGraph()
    G.relabel()
    print("Tetrahedral Graph")
    print("***************************************************************************************")
    test(G)
    print()

if True:
    # Dodecahedral Graph
    G = graphs.DodecahedralGraph()
    G.relabel()
    print("Dodecahedral Graph")
    print("***************************************************************************************")
    test(G)
    print()

if True:
    # Fosters Graph
    G = graphs.FosterGraph()
    G.relabel()
    print("Fosters Graph")
    print("***************************************************************************************")
    test(G)
    print()

if True:
    # Robertson Graph
    G = graphs.RobertsonGraph()
    G.relabel()
    print("Robertson Graph")
    print("***************************************************************************************")
    test(G)
    print()

if True:
    # Sylvester Graph
    G = graphs.SylvesterGraph()
    G.relabel()
    print("Sylvester Graph")
    print("***************************************************************************************")
    test(G)
    print()

if True:
    # Blanusa First Snark
    G = graphs.BlanusaFirstSnarkGraph()
    G.relabel()
    print("Blanusa First Snark")
    print("***************************************************************************************")
    test(G)
    print()

if True:
    # Blanusa Second Snark
    G = graphs.BlanusaSecondSnarkGraph()
    G.relabel()
    print("Blanusa Second Snark")
    print("***************************************************************************************")
    test(G)
    print()

if True:
    # Double Star Snark Graph
    G = graphs.DoubleStarSnark()
    G.relabel()
    print("Double Star Snark Graph")
    print("***************************************************************************************")
    test(G)
    print()

if True:
    # Flower Snark
    G = graphs.FlowerSnark()
    G.relabel()
    print("Flower Snark")
    print("***************************************************************************************")
    test(G)
    print()

if True:
    # Szekeres Snark
    G = graphs.SzekeresSnarkGraph()
    G.relabel()
    print("Szekeres Snark")
    print("***************************************************************************************")
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
    print("***************************************************************************************")
    test(G)
    print()
    t = 40
    print("Diamond Necklace with t = %i"%t)
    print("***************************************************************************************")
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

