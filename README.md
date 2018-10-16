# BokkyPooBahs Red-Black Tree Library

A gas-efficient Solidity data structure to maintain a sorted index for your data.

This library will store `uint`s (equivalent to `uint256`) as the key. Note that the value of 0 is prohibited. Use the sorted keys as indices to your mapping tables of data to access your data in sorted order.

This library uses an iterative (rather than recursive) Red-Black Tree to maintain the sorted keys.

A use-case for this library is to maintain a sorted on-chain decentralise exchange order book.

<br />

<hr />

If you find this library useful for your project, **especially commercial projects**, please donate to [0xb6dAC2C5A0222f6794265249ACE15568B750c2d1](https://etherscan.io/address/0xb6dAC2C5A0222f6794265249ACE15568B750c2d1). I hope to cover my cost of getting this library independently audited.


<br />

<hr />

## Table Of Contents

* [History](#history)
* [Deployment](#deployment)
* [Questions And Answers](#questions-and-answers)
* [Conventions](#conventions)
* [Functions](#functions)
  * [_daysFromDate](#_daysfromdate)
* [Gas Cost](#gas-cost)
* [Algorithm](#algorithm)
* [Testing](#testing)
* [References](#references)

<br />

<hr />


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

Enjoy!

(c) BokkyPooBah / Bok Consulting Pty Ltd - Oct 16 2018. [GNU Lesser General Public License 3.0](https://www.gnu.org/licenses/lgpl-3.0.en.html)
