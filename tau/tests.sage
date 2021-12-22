# Various functions to test
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

def no_discrete_star(G):
    R = resistance_matrix(G)
    F = fosters(G,R)
    ans = {v:0 for v in G.vertices()}
    for e in G.edges():
        ans[e[0]] += 1/12 * F[e]^2*e[2]^2 + 1/2*R[e[0],0]* e[2]* F[e]
        ans[e[1]] += 1/12 * F[e]^2*e[2]^2 + 1/2*R[e[1],0]* e[2]* F[e]
    return ans

def first_derive_term(G):
    R = resistance_matrix(G)
    F = fosters(G,R)
    ans = {v:0 for v in G.vertices()}
    for e in G.edges():
        ans[e[0]] += (1 - G.degree(e[0])/2 + 1/2 * e[2] * F[e])
        ans[e[1]] += (1 - G.degree(e[1])/2 + 1/2 * e[2] * F[e])
    return ans

def first_derive_e_terms(G):
    R = resistance_matrix(G)
    F = fosters(G,R)
    ans = {e:0 for v in G.edges()}
    for e in G.edges():
        ans[e] += (1/G.degree(e[0]) - 1/2 + 1/2 * e[2] * F[e])
    return ans

def no_F_L_2(G):
    R = resistance_matrix(G)
    F = fosters(G,R)
    ans = {v:0 for v in G.vertices()}
    for e in G.edges():
        ans[e[0]] += (1 - G.degree(e[0])/2 + 1/2 * e[2] * F[e])*R[e[0],0]
        ans[e[1]] += (1 - G.degree(e[1])/2 + 1/2 * e[2] * F[e])*R[e[1],0]
    return ans

def discrete_term(G):
    R = resistance_matrix(G)
    F = fosters(G,R)
    ans = {v:0 for v in G.vertices()}
    for e in G.edges():
        ans[e[0]] += (1 - G.degree(e[0])/2) * R[e[0],0]
        ans[e[1]] += (1 - G.degree(e[1])/2) * R[e[0],0]
    return ans


def log_of_tau(G):
    return log(tau(G))

# Rubrics:

# print("")
# F = to_function( function ,G)
# L = convexity_test_edge_dictionary(F,len(E))
# print("typical values: " + str(function(G)))
# print({e for e in L.keys() if L[e]})

# print("")
# F = to_function( function ,G)
# L = convexity_test_vertex_dictionary(F,V,len(E))
# print("typical values: " + str(function(G)))
# print({v for v in L.keys() if L[v]})

# print("")
# F = to_function( function ,G)
# L = convexity_test(F,len(E))
# print("typical values: " + str(function(G)))
# print("convexity = ", str(L))

def test(G):
    E = G.edges()
    V = G.vertices()
    print("vertices = " + str(V))
    print("edges = " + str(E))

    # print()
    # print("both terms star")
    # function = both_terms_star
    # F = to_function( function ,G)
    # L = convexity_test_vertex_dictionary(F,V,len(E))
    # print("typical values: " + str(function(G)))
    # print("non-convex vertices:")
    # print({v for v in L.keys() if not L[v]})

    # print()
    # print("F_R_l star")
    # function = F_R_l_star
    # F = to_function( function ,G)
    # L = convexity_test_vertex_dictionary(F,V,len(E))
    # print("typical values: " + str(function(G)))
    # print("non-convex vertices:")
    # print({v for v in L.keys() if not L[v]})

    # print()
    # print("No discrete star")
    # function = no_discrete_star
    # F = to_function( function ,G)
    # L = convexity_test_vertex_dictionary(F,V,len(E))
    # print("typical values: " + str(function(G)))
    # print("non-convex vertices:")
    # print({v for v in L.keys() if not L[v]})

    # print()
    # print("No F L 2")
    # function = no_F_L_2
    # F = to_function( function ,G)
    # L = convexity_test_vertex_dictionary(F,V,len(E))
    # print("typical values: " + str(function(G)))
    # print("non-convex vertices:")
    # print({v for v in L.keys() if not L[v]})

    # print()
    # print("firt derive term")
    # function =  first_derive_term
    # F = to_function( function ,G)
    # L = convexity_test_vertex_dictionary(F,V,len(E))
    # print("typical values: " + str(function(G)))
    # print("non-convex vertices:")
    # print({v for v in L.keys() if not L[v]})

    print()
    print("first_derive_e_terms")
    F = to_function(first_derive_e_terms, G)
    L = convexity_test_edge_dictionary(F,E)
    print("typical values: " + str(function(G)))

    # print()
    # print("discrete term")
    # function = discrete_term
    # F = to_function( function ,G)
    # L = convexity_test_vertex_dictionary(F,V,len(E))
    # print("typical values: " + str(function(G)))
    # print("non-convex vertices:")
    # print({v for v in L.keys() if not L[v]})
