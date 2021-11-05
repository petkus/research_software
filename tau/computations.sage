load('tau.sage')
# Complete Graphs
if False:
    for n in range(3):
        G = graphs.CompleteGraph(n + 3)
        print(tau_test_convexity(G))
#OUTPUT ALL TRUE

# Block Tower Graph TODO CITE
if False:
    T = {}
    R = {}
    Dif = {}
    for n in range(4,10):
        P = graphs.PathGraph(n)
        C = graphs.CycleGraph(4)
        G = P.cartesian_product(C)
        G.relabel()
        for e in G.edges():
            G.set_edge_label(e[0],e[1],1)
        T[n] = N(tau(G,QQ))
        R[n] = N(res(0,4*n - 2,G,QQ))
        if len(R) > 1:
            Dif[n] = R[n] - R[n-1]
        else:
            Dif[n] = R[n]

# Block Tower Graph Calculating Tau constant
if False:
    P = graphs.PathGraph(4)
    C = graphs.CycleGraph(4)
    G = P.cartesian_product(C)
    polys = PolynomialRing(QQ,3,"z").fraction_field()
    z = polys.gens()
    for i in range(4):
        for k in range(4):
            if k < 3:
                G.set_edge_label((k,i),(k+1,i), z[1])
            if i < 3:
                G.set_edge_label((k,i),(k,i+1), z[2])
            G.set_edge_label((k,3),(k,0), z[2])
    for i in range(3):
        G.set_edge_label((0,i),(0,i+1), z[0])
    G.set_edge_label((0,3),(0,0), z[0])
    G.relabel()
    F = fosters(G)
    p = tau(G,F,polys)

# Square Lattice Graph
if False:
    for n in range(2,4):
        G = graphs.Grid2dGraph(n,n)
        print(tau_test_convexity(G))
#OUTPUT ALL TRUE

# Ladder Graph
if False:
    for n in range(2,8):
        G = graphs.LadderGraph(n)
        print(n)
        print(tau_test_convexity(G))
#OUTPUT ALL TRUE

# Banana Graph
if False:
    answer = []
    answer_with_fosters = []
    f = []
    p = []
    for edge_num in range(3,10):
        polys = PolynomialRing(QQ,edge_num,"z").fraction_field()
        z = polys.gens()
        G = Graph([(0, 1, 1/edge_num) for i in range(edge_num)])
        p += [tau(G,polys)]
        answer += [1/12*(1 - (2*edge_num - 4)/edge_num^2)]
    #testing tau_with_fosters
    for edge_num in range(3,10):
        polys = PolynomialRing(QQ,edge_num,"z").fraction_field()
        z = polys.gens()
        G = Graph([(0, 1, 1/edge_num) for i in range(edge_num)])
        p += [tau_using_fosters(G)]
        answer_with_fosters += [1/12*(1 - (2*edge_num - 4)/edge_num^2)]

# Banana graph on three edges
if False:
    edge_num = 3
    polys = PolynomialRing(QQ,edge_num,"z").fraction_field()
    z = polys.gens()
    G = Graph([(0, 1, z[0]), (0,1,z[1]), (0,1,z[2])])
    p = tau(G, polys)
    var('x, y')
    S = {z[0]:x,z[1]:y,z[2]:1-x-y}
    f = p.substitute(S)
    graphic = contour_plot(f, (x,0,1), (y,0,1), fill=False, region=1-x-y,plot_points=300)
    show(graphic)

# Cube Graph
if False:
    dimensions = 3
    edge_num = dimensions * 2^dimensions / 2
    polys = PolynomialRing(QQ,edge_num,"z").fraction_field()
    var('x,y')
    z = polys.gens()
    G = Graph([(0, 1, z[0]),
     (0, 2, z[1]),
     (0, 4, z[2]),
     (1, 3, z[2]),
     (1, 5, z[1]),
     (2, 3, z[0]),
     (2, 6, z[2]),
     (3, 7, z[1]),
     (4, 5, z[0]),
     (4, 6, z[1]),
     (5, 7, z[2]),
     (6, 7, z[0])])
    p = tau(G,polys)
    f = p.substitute({z[0]:x, z[1]:y, z[2]:1/4-x-y})
    graphic = contour_plot(f, (x,0,1/4), (y,0,1/4), fill=False,
                           region=1/4-x-y, plot_points=300)
    show(graphic)

# Cube Graph
if True:
    for n in range(2,5):
        G = graphs.CubeGraph(n)
        print(n)
        print(tau_test_convexity(G))

# Peterson Graph
if False:
    G = graphs.PetersenGraph()
    print("Petersen Graph:")
    print(tau_test_convexity(G))


# Peterson Graph
if False:
    G = graphs.PetersenGraph()
    edge_num = len(G.edges())
    polys = PolynomialRing(QQ,edge_num,"z").fraction_field()
    z = polys.gens()
    S = {0,1,2,3,4}
    for e in G.edges():
        u = e[0]
        v = e[1]
        if u in S and v in S:
            G.set_edge_label(u,v,z[0])
        elif not u in S and not v in S:
            G.set_edge_label(u,v,z[1])
        else:
            G.set_edge_label(u,v,1/5 - z[1] - z[0])
    p = tau(G,polys)
    vars('x,y')
    f = p.substitute({z[0]:x, z[1]:y})
    graphic = contour_plot(f, (x,0,1/5), (y,0,1/5), fill=False,
                           region=1/5-x-y, plot_points=300)
    show(graphic)

# Diamond Necklace
# Page 56 of Cinkir
if False:
    t = 4
    # polys = PolynomialRing(QQ,2,"z").fraction_field()
    # z = polys.gens()
    polys = QQ
    a = 1/100
    b = 1/5 * (1 - t * a)
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

H = visualize(G)
show(H)
