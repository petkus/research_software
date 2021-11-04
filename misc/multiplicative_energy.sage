# This is motivated off this blog post from Adam Sheffer blog:
# https://adamsheffer.wordpress.com/2021/07/23/a-basic-question-about-multiplicative-energy/

def mult_energy(A, B):
    s = 0
    S = {}
    for a in A:
        for b in B:
            p = a*b
            if p in S.keys():
                s += S[p]
                S[p] += 1
            else:
                S[p] = 1
    return s

def energy(B):
    n = size(B)
    A = set(range(1,int(sqrt(n)) + 1))
    
