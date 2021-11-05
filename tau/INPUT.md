# Tau Constant
This is code used to compute examples of the tau constant of a metric graph.
The aim of this project is to verify and prove the Tau constant is convex as a
function of the edge lengths of $G$

The purpose of each file is as follows
- `tau.sage` contains the functions and software used
- `computations.sage` contains computations of examples using 'tau.sage'. I
  will try to keep a list of verified results in this README.

### For a definition of the tau constant see the following
- https://arxiv.org/abs/math/0407427
- https://getd.libs.uga.edu/pdfs/cinkir_zubeyir_200708_phd.pdf
- https://arxiv.org/abs/1810.02639

## Conventions
This code is assuming the following conditions for each graph
- Loops should be ok (I have not tested thoroughly)
- No parallel edges (the `G.set_edge_label()` method has difficulties with parallel edges
- Graphs should be weighted, edges should be encoded in the form `e = (e^-,
  e^+, length(e))`
- Typically `G` refers to a graph.
- `polys` refers to the field of rational functions with indeterminants
  associated to edge lengths, `z` or `zs` refers to a list of indeterminants
associated edge lengths of `G` (i.e. `z = polys.gens()`),
- Distinct computations in `computations.sage` are seperated by `if False:`
  statements. They can be toggled on/off by changing the if statements.

## Computations

### Notation
- $G \times H$ denotes the cartesion product of graphs $G, H$
- $P_n$ denotes the path graph of length $n$
- $C_n$ denotes the cycle graph of length $n$
- $K_n$ denotes complete graph on $n$ verticies
- $B_n$ denotes the banana graph of $n$ edges

### Convexity has been verified for:

1. $K_n$ up to $n = 6$ verticies
2. The square grid $P_n \times P_n$ up to $n = 3$ layers
3. The ladder graph $P_2 \times P_n$ up to $n = 7$ layers
4. $B_n$ for any $n$ (proven)
5. The cube graph $P_1^n = P_1 \times \dots \times P_1$ up to $n = 3$



TESTING:
$A + B+ C$

