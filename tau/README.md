# Tau Constant
This is code used to compute examples of the tau constant of a metric graph.
The aim of this project is to verify and prove the Tau constant is convex as a
function of the edge lengths of <img src="svgs/5201385589993766eea584cd3aa6fa13.svg?invert_in_darkmode" align=middle width=12.92464304999999pt height=22.465723500000017pt/>

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
- <img src="svgs/e6e3d58ab0fb9113d5355378230feaac.svg?invert_in_darkmode" align=middle width=48.01582499999999pt height=22.465723500000017pt/> denotes the cartesion product of graphs <img src="svgs/bc16024f0639478ea3e9f3d70d8a09ab.svg?invert_in_darkmode" align=middle width=35.23051784999999pt height=22.465723500000017pt/>
- <img src="svgs/1b1cbe41a014249f2a00f2b558985631.svg?invert_in_darkmode" align=middle width=18.67967144999999pt height=22.465723500000017pt/> denotes the path graph of length <img src="svgs/55a049b8f161ae7cfeb0197d75aff967.svg?invert_in_darkmode" align=middle width=9.86687624999999pt height=14.15524440000002pt/>
- <img src="svgs/269df1b24837e284ec791de3ae768620.svg?invert_in_darkmode" align=middle width=19.87487204999999pt height=22.465723500000017pt/> denotes the cycle graph of length <img src="svgs/55a049b8f161ae7cfeb0197d75aff967.svg?invert_in_darkmode" align=middle width=9.86687624999999pt height=14.15524440000002pt/>
- <img src="svgs/96b697078d351b7b43bd5b5dce0254cd.svg?invert_in_darkmode" align=middle width=22.08723494999999pt height=22.465723500000017pt/> denotes complete graph on <img src="svgs/55a049b8f161ae7cfeb0197d75aff967.svg?invert_in_darkmode" align=middle width=9.86687624999999pt height=14.15524440000002pt/> verticies
- <img src="svgs/34c759c10ccac82213a2aa1a2bed361b.svg?invert_in_darkmode" align=middle width=20.594674649999988pt height=22.465723500000017pt/> denotes the banana graph of <img src="svgs/55a049b8f161ae7cfeb0197d75aff967.svg?invert_in_darkmode" align=middle width=9.86687624999999pt height=14.15524440000002pt/> edges

### Convexity has been verified for:

1. <img src="svgs/96b697078d351b7b43bd5b5dce0254cd.svg?invert_in_darkmode" align=middle width=22.08723494999999pt height=22.465723500000017pt/> up to <img src="svgs/f7383cf663cc3fbf0211bdc91abca2d2.svg?invert_in_darkmode" align=middle width=40.00371704999999pt height=21.18721440000001pt/> verticies
2. The square grid <img src="svgs/dc78b813ccb780b6209dc8237320b1cb.svg?invert_in_darkmode" align=middle width=58.27244774999999pt height=22.465723500000017pt/> up to <img src="svgs/14d16c011d601ab1480487a911c760d0.svg?invert_in_darkmode" align=middle width=40.00371704999999pt height=21.18721440000001pt/> layers
3. The ladder graph <img src="svgs/918f950bd703da97a26b0d821ca90d18.svg?invert_in_darkmode" align=middle width=56.69896979999999pt height=22.465723500000017pt/> up to <img src="svgs/e1c19934b0354cb428cd4183915b42dc.svg?invert_in_darkmode" align=middle width=40.00371704999999pt height=21.18721440000001pt/> layers
4. <img src="svgs/34c759c10ccac82213a2aa1a2bed361b.svg?invert_in_darkmode" align=middle width=20.594674649999988pt height=22.465723500000017pt/> for any <img src="svgs/55a049b8f161ae7cfeb0197d75aff967.svg?invert_in_darkmode" align=middle width=9.86687624999999pt height=14.15524440000002pt/> (proven)
5. The cube graph <img src="svgs/f4587d87b8a2920ce5a517d5ee1de24f.svg?invert_in_darkmode" align=middle width=138.097014pt height=22.465723500000017pt/> up to <img src="svgs/14d16c011d601ab1480487a911c760d0.svg?invert_in_darkmode" align=middle width=40.00371704999999pt height=21.18721440000001pt/>



TESTING:
<img src="svgs/066eaf1d4b6be7af6c0b351be69fb149.svg?invert_in_darkmode" align=middle width=78.72922859999998pt height=22.465723500000017pt/>

