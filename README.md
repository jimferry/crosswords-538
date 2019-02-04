# crosswords-538
Solution to The Riddler puzzle on counting the number of possible crossword puzzles

The January 18, 2019 edition of The Riddler at 538 (https://fivethirtyeight.com/features/how-many-crossword-puzzles-can-you-make/)
asked for the number of connected, 180-degree-symmetric 15 x 15 crossword grids with minimum word length of 3.  The answer is
404,139,015,237,875 if we require each grid to fill the full 15 x 15 region (i.e., white squares touch every edge), and
409,764,131,469,788 if we do not require this.  These numbers are large enough to rule out direct-enumeration approaches.

The Mathematica package CrosswordCounts provides a dynamic-programming solution to the problem.  It computes the number of partial
grids which end in various possible bottom-row "states", updates these counts over states one row at a time, and then calculates
how many of these states survive matching to their 180-degree-rotated counterparts.  The state information includes the length of
the current vertical run of white squares in each column, and the specification of which horizontal runs of white squares are
connected to which (higher up in the partial grid).

The .nb and .m files are essentially identical, except that ccExample.nb contains the results of sample calculations that can be
performed with CrosswordCounts, whereas ccExample.m leaves the sample calculations unevaluated.
