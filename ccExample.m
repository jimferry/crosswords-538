(* ::Package:: *)

(* ::Input:: *)
(*(* Load package *)*)
(*(* If the Needs command fails just open CrosswordCounts.nb or CrosswordCounts.m and run the code *)*)
(*Needs["CrosswordCounts`"]*)


(* ::Input:: *)
(*(* List functions available in package *)*)
(*?CrosswordCounts`**)


(* ::Input:: *)
(*(* The workhorse function in the package is "count".  This counts the number of "valid" crossword puzzle grids, as defined in the January 18, 2019 edition of The Riddler at fivethirtyeight.com. *)*)
(*?count*)


(* ::Input:: *)
(*(* Here we count the number of 6 x 6 grids with words of minimum length 2.  The third argument, 1, indicates we are requiring the grids to be "tight":  i.e., to have white squares touching all four walls so that there are no extraneous black borders -- this was not explicitly required in The Riddler's problem statement, but we will treat this as the standard case. *)*)
(*count[6,2,1]*)


(* ::Input:: *)
(*(* We can check that this count is correct by explicitly enumerating all valid, tight grids.  These grids come in five symmetry classes, depending on which operations map a grid to itself.  When we include only one member from each symmetry class, we reduce the 484 grids to 152. There are 8, 7, 38, 5, and 94 grids in each symmetry class, respectively.  *)*)
(*nValidGrids[6,2,1]*)
(*nValidGridClasses[6,2,1]*)
(*sizeList=sizesValidGridClasses[6,2,1]*)
(*sizeList.{1,2,2,2,4}*)


(* ::Input:: *)
(*(* We now plot these 152 grids, color-coded by symmetry class *)*)
(*plotGrids[allValidGridClasses[6,2,1],10]*)


(* ::Input:: *)
(*(* Most of these grids are not "maximal" -- these are essentially grids with no extraneous black squares. We plot the 11 of these that are maximal. *)*)
(*plotGrids[allMaximalGridClasses[6,2],10,20]*)


(* ::Input:: *)
(*(* The routines that explicitly construct grids do not scale to the 15 x 15 case (with minimum word length w = 3) from The Riddler.  The "count" routine uses a more sophisticated dynamic programming method that (barely) scales to problems this large.  Results of running count are stored in the CrosswordCounts package.  One function that encodes these is tightSquareCount, which stores results of count[n,w,1] for n = 1 to 15 and w = 1 to 7, along with formulas for simple patterns that emerge (these formulas fill in the entire w = 8 row below). The -1 entries are unknown values. *)*)
(*Table[tightSquareCount[n,w],{w,8},{n,16}]//MatrixForm*)


(* ::Input:: *)
(*(* The other stored results are encoded in countMat15[3,1], which could be computed directly (over several days) as countMat[15,3,1].  This gives the number of m x n grids with minimum word length 3 for the tight case (t = 1).  From this matrix we can easily determine that analogous loose result countMat15[3,0].  *)*)
(*countMat15[3,1]//MatrixForm*)
(*countMat15[3,0]//MatrixForm*)
(*(* We take the last element of each matrix to get the answer to The Riddler's puzzle for the tight and loose cases, respectively. Each of these is slightly over 400 trillion (so too large to count directly) *)*)
(*answer538 = {countMat15[3,1][[15,15]],countMat15[3,0][[15,15]]}*)


(* ::Input:: *)
(*(* We can use countMat to compute results like the above in a reasonable time for small cases.  Here are results for grids up through 6 x 10 with minimum word length w = 2 *)*)
(*countMat[6,10,2,1]//MatrixForm*)


(* ::Input:: *)
(*(* Here we redo the count[6,2,1] computation with some additional options. We specify compMode \[Rule] -1 for verbose output and saveQ \[Rule] True to save intermediate results. *)*)
(*count[6,2,1,compMode->-1,saveQ->True]*)


(* ::Input:: *)
(*(* The "count" function builds up partial results one row at a time:  the files "cws_T2_6_2.wl" and "cws_T2_6_3.wl" output by the above command store intermediate states of the computation after row 2 and row 3.  Looking at "cws_T2_6_3.wl" provides an indication of how "count" works. This file contain a list of 105 possible "states" of the third row and an associated count for each.  One entry in this list is {{1, 1, 2, 0, 2, 2}, {1, 1}, True} -> 10.  The {1, 1, 2, 0, 2, 2} indicates a row with 5 white squares (positive numbers) and one black one (the 0).  The positive numbers range from 1 to w, indicating the length of the current vertical run of white squares in each column. This is important to track because positive numbers < w cannot continue with a 0, lest they have a word of length < w.  The second component of the state we're looking at is {1, 1}.  This list has length 2 because there are two runs of white squares in the current row.  The {1, 1} are "labels" for these runs.  The fact that the labels are the same specifies that these two runs are connected somewhere in a previous row:  both are part of "cluster 1".  Finally, the "True" indicates that the requirement of touching both side walls has been met.  The total number of 6 x 3 grids that achieve this state in their third row is 10.  Given all this information, we can then determine the total number of valid 6 x 6 grids that can be formed by matching these partial states to themselves (when rotated by 180\[Degree]). *)*)
(**)
(*(* We can also read the state in and evolve it two more rows to count the number of 10 x 6 grids, which must agree with the 6 x 10 entry in countMat[6,10,2,1] above *)*)
(*count[10,6,2,1,compMode->-1,readIndex->3]*)


(* ::Input:: *)
(*(* When computing the desired result count[15,3,1] the 7th and final-row stage of the computation had 5,967,789 states encompassing a total of 209,631,035,845,190 partial grids.  This large number of partial grids per state is what enabled the algorithm to enumerate all 400 trillion+ grids.  However, this dynamic programming approach is harder to verify that direct computation.  Therefore, the a number of consistency routines are required to check that the numbers being produced by "count" agree with those produced by direct enumeration. *)*)
(*checkAllQ[]*)
