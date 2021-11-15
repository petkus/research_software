# Various functions involving Fosters Coefficients
load('tau.sage')

def single_integral_second_term_without_discrete(G):
    E = G.edges()
    R = resistance_matrix(G)
    F = fosters(G,R)
    return {(e[0],e[1]):e[2] * F[e] * (R[0,e[0]] + R[0,e[1]]) for e in E}

def single_integral_term_without_discrete(G):
    E = G.edges()
    R = resistance_matrix(G)
    F = fosters(G,R)
    return {(e[0],e[1]): 1/6 *F[e]^2*e[2]^2 + 1/2*e[2] * F[e] * (R[0,e[0]] + R[0,e[1]]) for e in E}

def single_integral_without_discrete(G):
    E = G.edges()
    R = resistance_matrix(G)
    F = fosters(G,R)
    return sum(1/6 *F[e]^2*e[2]^2 + 1/2*e[2] * F[e] * (R[0,e[0]] + R[0,e[1]])
               for e in E)

# Above is in output_without_discrete.txt

def single_integral_first_term(G):
    E = G.edges()
    R = resistance_matrix(G)
    F = fosters(G,R)
    return {(e[0],e[1]):F[e]^2*e[2]^2 for e in E}

def single_integral_second_term(G):
    E = G.edges()
    R = resistance_matrix(G)
    F = fosters(G,R)
    return {(e[0],e[1]):((1/G.degree(e[0]) - 1/2 + 1/2 * e[2] * F[e] ) * R[0,e[0]] + (1/G.degree(e[1]) - 1/2 + 1/2 * e[2] * F[e]) * R[0,e[1]]) for e in E}

def single_integral_term(G):
    E = G.edges()
    R = resistance_matrix(G)
    F = fosters(G,R)
    return {(e[0],e[1]): 1/6 *F[e]^2*e[2]^2 +  ((1/G.degree(e[0]) - 1/2 + 1/2 * e[2] * F[e]) * R[0,e[0]] + (1/G.degree(e[1]) - 1/2 + 1/2 * e[2] * F[e]) * R[0,e[1]]) for e in E}

def single_integral(G):
    E = G.edges()
    R = resistance_matrix(G)
    F = fosters(G,R)
    return sum(1/6 *F[e]^2*e[2]^2 + ((1/G.degree(e[0]) - 1/2 + 1/2 * e[2] * F[e]) * R[0,e[0]] + (1/G.degree(e[1]) - 1/2 + 1/2 * e[2] * F[e]) * R[0,e[1]]) for e in E) 

# Above is in output_with_discrete.txt

def F_R_l_star(G):
    R = resistance_matrix(G)
    F = fosters(G,R)
    ans = {v:0 for v in G.vertices()}
    for e in G.edges():
        ans[e[0]] += R[0,e[0]] * F[e] * e[2]
        ans[e[1]] += R[0,e[1]] * F[e] * e[2]
    return ans

def second_term_star(G):
    R = resistance_matrix(G)
    F = fosters(G,R)
    ans = {v:0 for v in G.vertices()}
    for e in G.edges():
        ans[e[0]] += (1/G.degree(e[0]) - 1/2 + 1/2 * e[2] * F[e]) * R[0,e[0]]
        ans[e[1]] += (1/G.degree(e[1]) - 1/2 + 1/2 * e[2] * F[e]) * R[0,e[1]]
    return ans

def both_terms_star(G):
    R = resistance_matrix(G)
    F = fosters(G,R)
    ans = {v:0 for v in G.vertices()}
    for e in G.edges():
        ans[e[0]] += (1/G.degree(e[0]) - 1/2 + 1/2 * e[2] * F[e]) * R[0,e[0]] + 1/12 * F[e]^2 * e[2]^2
        ans[e[1]] += (1/G.degree(e[1]) - 1/2 + 1/2 * e[2] * F[e]) * R[0,e[1]] + 1/12 * F[e]^2 * e[2]^2
    return ans

def tau_star(G):
    return sum(both_terms_star(G))

#Above is in output_of_stars.txt

# ABOVE IS OLD TERMS ALREADY TESTED

def vertex_first_term(G):
    V = G.vertices()
    R = resistance_matrix(G)
    F = fosters(G,R,labels=False)
    ans = {v:0 for v in G.vertices()}
    return ans

def log_of_tau(G):
    return log(tau(G))

def test(G):
    E = G.edges()
    V = G.vertices()

    print("log of tau")
    F = to_function(log_of_tau,G)
    L = convexity_test(F,param_num=len(E),test_num=200)
    print("typical values: ",str(log_of_tau(G)))
    print(L)

    # print("F R l star")
    # F = to_function(F_R_l_star,G)
    # L = convexity_test_vertex_dictionary(F,V,len(E),test_num=200)
    # print("typical values: " + str(F_R_l_star(G)))
    # print({v for v in L.keys() if L[v]})

    # print("second term star")
    # F = to_function(second_term_star,G)
    # L = convexity_test_vertex_dictionary(F,V,len(E),test_num=200)
    # print("typical values: ",str(second_term_star(G)))
    # print({v for v in L.keys() if L[v]})

    # print("both term star")
    # F = to_function(both_terms_star,G)
    # L = convexity_test_vertex_dictionary(F,V,len(E),test_num=200)
    # print("typical values: ",str(both_terms_star(G)))
    # print({e for e in L.keys() if L[e]})

    # print("tau star")
    # F = to_function(tau_star,G)
    # L = convexity_test(F,param_num=len(E),test_num=200)
    # print("typical values: ",str(tau_star(G)))
    # print(L)
