load('tests.sage')
for k in range(5,10):
    print('k = ' + str(k))
    args = '-C ' + str(k)
    for G in graphs.nauty_geng(args):
        print(G)
        T = tau_test_convexity(G)
        print(T)
        if not T:
            print("G is not convex")
            print("vertices")
            print(G.vertices())
            print("edges")
            print(G.edges())
