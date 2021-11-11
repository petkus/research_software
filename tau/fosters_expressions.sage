# Various functions involving Fosters Coefficients
load('tau.sage')

def single_integral_first_term(G):
    E = G.edges()
    R = resistance_matrix(G)
    F = fosters(G,R)
    return {(e[0],e[1]):F[e]^2*e[2]^2 for e in E}

def single_integral_second_term(G):
    E = G.edges()
    R = resistance_matrix(G)
    F = fosters(G,R)
    return {(e[0],e[1]):e[2] * F[e] * (R[0,e[0]] + R[0,e[1]]) for e in E}

def single_integral_term(G):
    E = G.edges()
    R = resistance_matrix(G)
    F = fosters(G,R)
    return {(e[0],e[1]): 1/6 *F[e]^2*e[2]^2 + 1/2*e[2] * F[e] * (R[0,e[0]] + R[0,e[1]]) for e in E}

def single_integral(G):
    E = G.edges()
    R = resistance_matrix(G)
    F = fosters(G,R)
    return sum(1/6 *F[e]^2*e[2]^2 + 1/2*e[2] * F[e] * (R[0,e[0]] + R[0,e[1]])
               for e in E)

def test(G):
    E = G.edges()

    print("single integral first term:")
    F = to_function(single_integral_first_term,G)
    L = dictionary_convexity_test(F,E)
    print({e for e in L.keys() if L[e]})

    print("single integral second term:")
    F = to_function(single_integral_second_term,G)
    L = dictionary_convexity_test(F,E)
    print({e for e in L.keys() if L[e]})

    print("single integral term:")
    F = to_function(single_integral_term,G)
    L = dictionary_convexity_test(F,E)
    print({e for e in L.keys() if L[e]})

    print("single integral:")
    F = to_function(single_integral,G)
    print(convexity_test(F, len(E)))

    print("tau convexity:")
    print(tau_test_convexity(G))

    
