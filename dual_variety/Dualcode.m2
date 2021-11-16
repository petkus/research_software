k = QQ
--toField (QQ[a]/(a^2-3))
S = k[x0,x1,x2, u0,u1,u2];
d = 3;
pairing = first sum(d,i->(gens S)_i*(gens S)_{i+d});
makedual = I -> (e = codim I;
J = saturate(I + minors(e+1,submatrix(jacobian(I+ideal(pairing)),{0..d-1},)),
minors(e,submatrix(jacobian(I),{0..d-1},)));{I,eliminate((gens S)_{0..d-1},J)})
