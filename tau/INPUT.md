# Tau Constant
This is code used to compute examples of the tau constant of a metric graph.
The aim of this project is to verify and prove the Tau constant is convex as a
function of the edge lengths of $G$

The purpose of each file is as follows
- `tau.sage` contains functions relating to the calculation of the tau constant
- `tests.sage` contains various functions I wanted to test for convexity.
- `computations.sage` contains computations of examples using `tau.sage` and
  `fosters.sage`. I will try to keep a list of verified results in this README.
- `output.txt` is the output of `computations.txt` via the command `sage
  computations.sage >> output.txt`
- `old/` contains old code I am no longer using.

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

1. All graphs up with 8 or fewer vertices
2. $K_n$ up to $n = 9$ vertices
3. Complete bipartite graph up to $n = 9$ vertices on both partitions
4. The square grid $P_n \times P_n$ up to $n = 9$ layers
5. The ladder graph $P_2 \times P_n$ up to $n = 9$ layers
6. The Wheel graph up to $n = 14$ spokes
7. $B_n$ for any $n$ (proven)
8. The cube graph $P_1^n = P_1 \times \dots \times P_1$ up to $n = 6$
9. The Octahedral Graph
10. The Tetrahedral Graph
11. The Diamond Necklace with $t = 20$ 
12. The Diamond Necklace with $t = 40$ 
13. The Petersen Graph



## Note for compiling Latex in README
I am using the python script `readme2tex` (https://github.com/leegao/readme2tex). Just following the directions on their page was giving me troubles (it seemed to rely on RawGit https://rawgit.com/ which is shut down). Using the following command seems to work however!

`python3 -m readme2tex --nocdn --readme INPUT.md --output README.md`

