# BokkyPooBahs Red-Black Tree Library

Status: **Work in progress. Tidying, testing, documenting before getting audits - don't use yet**

A gas-efficient Solidity library using the Red-Black binary search tree algorithm to help you maintain a sorted index for your data. Insertions, deletions and searches are in **O(log n)** time (and ~gas).

This library will store `uint`s (equivalent to `uint256`) as the key. Note that the value of 0 is prohibited. Use the sorted keys as indices to your mapping tables of data to access your data in sorted order.

This library uses an iterative (rather than recursive) Red-Black Tree to maintain the sorted keys.

A use-case for this library is to maintain a sorted on-chain decentralise exchange order book.

From Wikipedia's [Red-Black Tree](https://en.wikipedia.org/wiki/Red%E2%80%93black_tree) page, the following Red-Black tree was created by inserting the items `[13,8,17,11,15,22,25,27,1,6]`:

<kbd><img src="https://upload.wikimedia.org/wikipedia/commons/6/66/Red-black_tree_example.svg" /></kbd>


What is a [Red-Black Tree](https://en.wikipedia.org/wiki/Red%E2%80%93black_tree)? Following is a representation of Red-Black binary search tree of a randomise list of entries from 1 to 32, inserted in the order `[15,14,20,3,7,10,11,16,18,2,4,5,8,19,1,9,12,6,17,13]`. The RBT algorithm maintains a self-balancing tree.

<kbd><img src="docs/RedBlackTree1To32Random.png" /></kbd>

The root node of the tree is 18, `k` represents the key numbers, `p` the parent, `l` the left node, `r` the right node, and the red-black colouring of each node is used to maintain the tree balance. Nodes with `l0 r0` are the leaves of the tree:

<br />

<hr />

If you find this library useful for your project, **especially commercial projects**, please donate to [0xb6dAC2C5A0222f6794265249ACE15568B750c2d1](https://etherscan.io/address/0xb6dAC2C5A0222f6794265249ACE15568B750c2d1). I hope to cover my cost of getting this library independently audited.


<br />

<hr />

## Table Of Contents

* [History](#history)
* [Deployment](#deployment)
* [Questions And Answers](#questions-and-answers)
* [Functions](#functions)
  * [insert](#insert)
  * [remove](#remove)
* [Algorithm](#algorithm)
* [Gas Cost](#gas-cost)
* [Testing](#testing)
* [References](#references)

<br />

<hr />

## History

<br />

<hr />

## Deployment

This library has been designed to be automatically compiled into your Ethereum Solidity contract or library, instead of having to deploy this library and then linking your contract or library to this library.

<br />

<hr />

## Questions And Answers

<br />

<hr />

## Functions

See [contracts/TestBokkyPooBahsRedBlackTree.sol](contracts/TestBokkyPooBahsRedBlackTree.sol) (or the [flattened](flattened/TestBokkyPooBahsRedBlackTree_flattened.sol) version) for an example contract that uses this library.

### insert

```javascript
function insert(Tree storage self, uint z) internal;
```

<br />

### remove

```javascript
function remove(Tree storage self, uint z) internal;
```

<br />

<hr />

## Algorithm

The main algorithm is listed in [Algorithms for Red Black Tree Operations
(from CLRS text)](http://www.cse.yorku.ca/~aaw/Sotirios/RedBlackTreeAlgorithm.html).

There is one complication with the algorithm above in the function `RB-Delete` in the line `then key[z] := key[y]` replaced with the algorithm in [Iterative Algorithm for Red-Black Tree](https://stackoverflow.com/a/11328289).


<br />

<hr />

## Gas Cost

TODO:

* [ ] Min, Max, Average for 10, 100, 1000, 10000 entries

### Average Case

The following number of items were inserted in random order

The following number of items were inserted in sequential order

Items | Ins Min | Ins Avg     | Ins Max | Rem Min | Rem Avg    | Rem Max
-----:| -------:| -----------:| -------:| -------:| ----------:| -------:
1     | 68459   | 68459       | 68459   | 44835   | 44835      | 44835
5     | 68459   | 99166.2     | 140002  | 30521   | 48024.4    | 74259
10    | 68459   | 118401.5    | 167610  | 30671   | 71973.5    | 119593
50    | 68459   | 124688.32   | 182637  | 30067   | 82894.66   | 213514
100   | 68459   | 123377.19   | 190137  | 30521   | 79761.56   | 191060
500   | 68459   | 124567.396  | 191240  | 30521   | 80108.078  | 261153
1000  | 68459   | 125334.687  | 188278  | 29950   | 81032.364  | 219352
5000  | 68523   | 127270.3138 | 196563  | 30521   | 81972.7506 | 283499

<br />

### Worst Case

The following number of items were inserted in sequential order

Items | Ins Min | Ins Avg     | Ins Max | Rem Min | Rem Avg    | Rem Max
-----:| -------:| -----------:| -------:| -------:| ----------:| -------:
1     | 68459   | 68459       | 68459   | 44835   | 44835      | 44835
5     | 68459   | 107349.4    | 140753  | 29918   | 56072.4    | 86075
10    | 68459   | 116513      | 149588  | 30067   | 75757.2    | 119064
50    | 68459   | 137949.4    | 158598  | 30067   | 86001.76   | 213537
100   | 68459   | 142906.91   | 163103  | 30521   | 87266.18   | 218371
500   | 68459   | 149290.434  | 191089  | 30521   | 86199.74   | 266556
1000  | 68459   | 150802.324  | 208341  | 29950   | 87266.115  | 287889
5000  | 68459   | 153263.3122 | 242846  | 30521   | 88335.6862 | 310295

<br />

<hr />

## Testing

TODO:

* [ ] Test random insertions 10, 1000, 10000
* [ ] Test random insertions and deletions
* [ ] Test repeated random insertions and deletions
* [ ] Test the `view` functions, including what happens when a non-existent key is passed
* [ ] Test deleting a non-existent key
* [ ] Insert duplicate
* [ ] Test adding sequentially increasing and decreasing keys
* [ ] Test whether `nodes[0]` is used now (was used when the algorithm was not quite working correctly)

<br />

<hr />

## References

* [Red–black tree](https://en.wikipedia.org/wiki/Red%E2%80%93black_tree).
* Mihail Buricea's *Laboratory Module 6 - Red-Black Trees* at http://software.ucv.ro/~mburicea/lab8ASD.pdf, a copy of which has been saved to [docs/lab8ASD.pdf](docs/lab8ASD.pdf)
* https://stackoverflow.com/questions/3758356/iterative-algorithm-for-red-black-tree

https://stackoverflow.com/a/3759681
-> http://oopweb.com/Algorithms/Documents/Sman/Volume/RedBlackTrees.html
& https://www.epaperpress.com/sortsearch/txt/var.txt
& https://www.epaperpress.com/sortsearch/txt/rbtr.txt
& http://www.cse.yorku.ca/~aaw/Sotirios/RedBlackTreeAlgorithm.html

Also http://read.seas.harvard.edu/~kohler/notes/llrb.html

And https://www.cs.dartmouth.edu/~thc/cs10/lectures/0519/0519.html :
* https://www.cs.dartmouth.edu/~thc/cs10/lectures/0519/RBTree.java

https://www.csee.umbc.edu/courses/undergraduate/341/fall13/section3/lectures/10-Red-Black-Trees.pdf

http://code.activestate.com/recipes/576817-red-black-tree/

http://cseweb.ucsd.edu/~kube/cls/100/Lectures/lec7/lec7.pdf

https://www.geeksforgeeks.org/red-black-tree-set-3-delete-2/

<br />

<br />

Thanks to [Solidified](https://solidified.io/) for the 3 minor issues they picked up at the Web3 Summit.


Enjoy!

(c) BokkyPooBah / Bok Consulting Pty Ltd - Oct 16 2018. The MIT Licence.
