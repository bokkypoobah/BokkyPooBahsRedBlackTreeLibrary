pragma solidity ^0.4.25;

// ----------------------------------------------------------------------------
// BokkyPooBah's RedBlackTree Library v0.90
//
// A Solidity Red-Black Tree library to store and maintain a sorted data
// structure
//
// Based on the algorithm from Mihail Buricea's *Laboratory Module 6 -
// Red-Black Trees* at http://software.ucv.ro/~mburicea/lab8ASD.pdf and
// https://en.wikipedia.org/wiki/Red%E2%80%93black_tree
// http://www.cse.yorku.ca/~aaw/Sotirios/RedBlackTreeAlgorithm.html
//
// Notes:
// * Cannot have a key of 0
//
// https://github.com/bokkypoobah/BokkyPooBahsRedBlackTreeLibrary
//
//
// Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018.
//
// GNU Lesser General Public License 3.0
// https://www.gnu.org/licenses/lgpl-3.0.en.html
// ----------------------------------------------------------------------------

library BokkyPooBahsRedBlackTreeLibrary {
    struct Node {
        uint parent;
        uint left;
        uint right;
        bool red;
    }

    struct Tree {
        uint root;
        mapping(uint => Node) nodes;
    }

    uint private constant NULL = 0;

    event Log(string where, string action, uint key, uint parent, uint left, uint right, bool red);

    function first(Tree storage self) internal view returns (uint _key) {
        _key = self.root;
        while (_key != 0 && self.nodes[_key].left != 0) {
            _key = self.nodes[_key].left;
        }
    }
    function last(Tree storage self) internal view returns (uint _key) {
        _key = self.root;
        while (_key != 0 && self.nodes[_key].right != 0) {
            _key = self.nodes[_key].right;
        }
    }
    function exists(Tree storage self, uint key) internal view returns (bool _exists) {
        uint _key = self.root;
        while (_key != NULL) {
            if (key == _key) {
                _exists = true;
            }
            if (key < _key) {
                _key = self.nodes[_key].left;
            } else {
                _key = self.nodes[_key].right;
            }
        }
    }
    function getNode(Tree storage self, uint key) internal view returns (Node node) {
        uint _key = self.root;
        while (_key != NULL) {
            if (key == _key) {
                return self.nodes[key];
            }
            if (key < _key) {
                _key = self.nodes[_key].left;
            } else {
                _key = self.nodes[_key].right;
            }
        }
    }
    function parent(Tree storage self, uint key) internal view returns (uint _parent) {
        _parent = self.nodes[key].parent;
    }
    function parentNode(Tree storage self, uint key) internal view returns (Node _parentNode) {
        _parentNode = self.nodes[self.nodes[key].parent];
    }
    function grandparent(Tree storage self, uint key) internal view returns (uint _grandparent) {
        uint _parent = self.nodes[key].parent;
        if (_parent != NULL) {
            _grandparent = self.nodes[_parent].parent;
        }
    }
    function grandparentNode(Tree storage self, uint key) internal view returns (Node _grandparentNode) {
        uint _parent = self.nodes[key].parent;
        if (_parent != NULL) {
            _grandparentNode = self.nodes[self.nodes[_parent].parent];
        }
    }
    function sibling(Tree storage self, uint key) internal view returns (uint _sibling) {
        uint _parent = self.nodes[key].parent;
        if (_parent != NULL) {
            if (key == self.nodes[_parent].left) {
                _sibling = self.nodes[_parent].right;
            } else {
                _sibling = self.nodes[_parent].left;
            }
        }
    }
    function siblingNode(Tree storage self, uint key) internal view returns (Node _siblingNode) {
        uint _parent = self.nodes[key].parent;
        if (_parent != NULL) {
            if (key == self.nodes[_parent].left) {
                _siblingNode = self.nodes[self.nodes[_parent].right];
            } else {
                _siblingNode = self.nodes[self.nodes[_parent].left];
            }
        }
    }
    function uncle(Tree storage self, uint key) internal view returns (uint _uncle) {
        uint _grandParent = grandparent(self, key);
        if (_grandParent != NULL) {
            uint _parent = self.nodes[key].parent;
            _uncle = sibling(self, _parent);
        }
    }
    function uncleNode(Tree storage self, uint key) internal view returns (Node _uncleNode) {
        uint _grandParent = grandparent(self, key);
        if (_grandParent != NULL) {
            uint _parent = self.nodes[key].parent;
            _uncleNode = siblingNode(self, _parent);
        }
    }

    function rotateLeft(Tree storage self, uint x) private {
        uint y = self.nodes[x].right;
        uint _parent = self.nodes[x].parent;
        // emit Log("rotateLeft", "x", x, parent, self.nodes[x].left, self.nodes[x].right, self.nodes[x].red);
        uint yLeftKey = self.nodes[y].left;
        self.nodes[x].right = yLeftKey;
        if (yLeftKey != NULL) {
            self.nodes[yLeftKey].parent = x;
        }
        self.nodes[y].parent = _parent;
        if (_parent == NULL) {
            self.root = y;
        } else if (x == self.nodes[_parent].left) {
            self.nodes[_parent].left = y;
        } else {
            self.nodes[_parent].right = y;
        }
        self.nodes[y].left = x;
        self.nodes[x].parent = y;
    }
    function rotateRight(Tree storage self, uint x) private {
        uint y = self.nodes[x].left;
        uint _parent = self.nodes[x].parent;
        // emit Log("rotateRight", "x", x, parent, self.nodes[x].left, self.nodes[x].right, self.nodes[x].red);
        uint yRightKey = self.nodes[y].right;
        self.nodes[x].left = yRightKey;
        if (yRightKey != NULL) {
            self.nodes[yRightKey].parent = x;
        }
        self.nodes[y].parent = _parent;
        if (_parent == NULL) {
            self.root = y;
        } else if (x == self.nodes[_parent].right) {
            self.nodes[_parent].right = y;
        } else {
            self.nodes[_parent].left = y;
        }
        self.nodes[y].right = x;
        self.nodes[x].parent = y;
    }

    function insert(Tree storage self, uint z) internal {
        uint y = NULL;
        uint x = self.root;
        while (x != NULL) {
            y = x;
            if (z < x) {
                x = self.nodes[x].left;
            } else {
                x = self.nodes[x].right;
            }
        }
        self.nodes[z] = Node(y, 0, 0, true);
        if (y == NULL) {
            self.root = z;
        } else if (z < y) {
            self.nodes[y].left = z;
        } else {
            self.nodes[y].right = z;
        }
        // emit Log("insert", "z", z, self.nodes[z].parent, self.nodes[z].left, self.nodes[z].right, self.nodes[z].red);
        insertFixup(self, z);
    }
    function insertFixup(Tree storage self, uint z) private {
        uint y;

        // emit Log("insertFixup", "z", z, self.nodes[z].parent, self.nodes[z].left, self.nodes[z].right, self.nodes[z].red);
        // uint p = self.nodes[z].parent;
        // emit Log("insertFixup", "parent", p, self.nodes[p].parent, self.nodes[p].left, self.nodes[p].right, self.nodes[p].red);
        // uint g = self.nodes[p].parent;
        // emit Log("insertFixup", "grandparent", g, self.nodes[g].parent, self.nodes[g].left, self.nodes[g].right, self.nodes[g].red);

        while (z != self.root && self.nodes[self.nodes[z].parent].red) {
            uint zParentKey = self.nodes[z].parent;
            if (zParentKey == self.nodes[self.nodes[zParentKey].parent].left) {
                // emit Log("insertFixup", "l1", 0, 0, 0, 0, false);
                y = self.nodes[self.nodes[zParentKey].parent].right;
                // emit Log("insertFixup", "l1 y", y, self.nodes[y].parent, self.nodes[y].left, self.nodes[y].right, self.nodes[y].red);
                if (self.nodes[y].red) {
                    // emit Log("insertFixup", "l1a", 0, 0, 0, 0, false);
                    self.nodes[zParentKey].red = false;
                    self.nodes[y].red = false;
                    self.nodes[self.nodes[zParentKey].parent].red = true;
                    z = self.nodes[zParentKey].parent;
                } else {
                    if (z == self.nodes[zParentKey].right) {
                      // emit Log("insertFixup", "l1b", 0, 0, 0, 0, false);
                      z = zParentKey;
                      rotateLeft(self, z);
                    }
                    zParentKey = self.nodes[z].parent;
                    self.nodes[zParentKey].red = false;
                    self.nodes[self.nodes[zParentKey].parent].red = true;
                    rotateRight(self, self.nodes[zParentKey].parent);
                }
            } else {
                // emit Log("insertFixup", "r1", 0, 0, 0, 0, false);
                y = self.nodes[self.nodes[zParentKey].parent].left;
                // emit Log("insertFixup", "r1 y", y, self.nodes[y].parent, self.nodes[y].left, self.nodes[y].right, self.nodes[y].red);
                if (self.nodes[y].red) {
                    // emit Log("insertFixup", "r1a", 0, 0, 0, 0, false);
                    self.nodes[zParentKey].red = false;
                    self.nodes[y].red = false;
                    self.nodes[self.nodes[zParentKey].parent].red = true;
                    z = self.nodes[zParentKey].parent;
                } else {
                    if (z == self.nodes[zParentKey].left) {
                      // emit Log("insertFixup", "r1b", 0, 0, 0, 0, false);
                      z = zParentKey;
                      rotateRight(self, z);
                    }
                    zParentKey = self.nodes[z].parent;
                    self.nodes[zParentKey].red = false;
                    self.nodes[self.nodes[zParentKey].parent].red = true;
                    rotateLeft(self, self.nodes[zParentKey].parent);
                }
            }
        }
        self.nodes[self.root].red = false;
    }

    // replaceParent(self, y, z);
    function replaceParent(Tree storage self, uint a, uint b) private {
        // emit Log("replaceParent before", "self.root", self.root, self.nodes[self.root].parent, self.nodes[self.root].left, self.nodes[self.root].right, self.nodes[self.root].red);
        // emit Log("replaceParent before", "a", a, self.nodes[a].parent, self.nodes[a].left, self.nodes[a].right, self.nodes[a].red);
        // emit Log("replaceParent before", "b", b, self.nodes[b].parent, self.nodes[b].left, self.nodes[b].right, self.nodes[b].red);
        uint bParentKey = self.nodes[b].parent;
        self.nodes[a].parent = bParentKey;
        if (bParentKey == NULL) {
            self.root = a;
        } else {
            // uint bParent = self.nodes[b].parent;
            if (b == self.nodes[bParentKey].left) {
                // emit Log("replaceParent aaa", "a", a, self.nodes[a].parent, self.nodes[a].left, self.nodes[a].right, self.nodes[a].red);
                // emit Log("replaceParent aaa", "b", b, self.nodes[b].parent, self.nodes[b].left, self.nodes[b].right, self.nodes[b].red);
                // emit Log("replaceParent aaa before", "bParent", bParent, self.nodes[bParent].parent, self.nodes[bParent].left, self.nodes[bParent].right, self.nodes[bParent].red);
                self.nodes[bParentKey].left = a;
                // emit Log("replaceParent aaa after", "bParent", bParent, self.nodes[bParent].parent, self.nodes[bParent].left, self.nodes[bParent].right, self.nodes[bParent].red);
            } else {
                // emit Log("replaceParent bbb", "a", a, self.nodes[a].parent, self.nodes[a].left, self.nodes[a].right, self.nodes[a].red);
                // emit Log("replaceParent bbb", "b", b, self.nodes[b].parent, self.nodes[b].left, self.nodes[b].right, self.nodes[b].red);
                // emit Log("replaceParent bbb before", "bParent", bParent, self.nodes[bParent].parent, self.nodes[bParent].left, self.nodes[bParent].right, self.nodes[bParent].red);
                self.nodes[bParentKey].right = a;
                // emit Log("replaceParent bbb after", "bParent", bParent, self.nodes[bParent].parent, self.nodes[bParent].left, self.nodes[bParent].right, self.nodes[bParent].red);
            }
        }
        // emit Log("replaceParent after", "self.root", self.root, self.nodes[self.root].parent, self.nodes[self.root].left, self.nodes[self.root].right, self.nodes[self.root].red);
        // emit Log("replaceParent after", "a", a, self.nodes[a].parent, self.nodes[a].left, self.nodes[a].right, self.nodes[a].red);
        // emit Log("replaceParent after", "b", b, self.nodes[b].parent, self.nodes[b].left, self.nodes[b].right, self.nodes[b].red);
    }
    function remove(Tree storage self, uint z) internal {
        uint x;
        uint y;

        // emit Log("remove one 1", "z", z, self.nodes[z].parent, self.nodes[z].left, self.nodes[z].right, self.nodes[z].red);
        if (self.nodes[z].left == NULL || self.nodes[z].right == NULL) {
            y = z;
            // emit Log("remove one 2", "y", y, self.nodes[y].parent, self.nodes[y].left, self.nodes[y].right, self.nodes[y].red);
        } else {
            y = self.nodes[z].right;
            // emit Log("remove one 3", "y", y, self.nodes[y].parent, self.nodes[y].left, self.nodes[y].right, self.nodes[y].red);
            while (self.nodes[y].left != NULL) {
                y = self.nodes[y].left;
                // emit Log("remove one 4", "y", y, self.nodes[y].parent, self.nodes[y].left, self.nodes[y].right, self.nodes[y].red);
            }
        }
        // emit Log("remove one after", "y", y, self.nodes[y].parent, self.nodes[y].left, self.nodes[y].right, self.nodes[y].red);
        // emit Log("remove one after", "z", z, self.nodes[z].parent, self.nodes[z].left, self.nodes[z].right, self.nodes[z].red);

        if (self.nodes[y].left != NULL) {
            // emit Log("remove two 1", "y", y, self.nodes[y].parent, self.nodes[y].left, self.nodes[y].right, self.nodes[y].red);
            x = self.nodes[y].left;
            // emit Log("remove two 1", "x", x, self.nodes[x].parent, self.nodes[x].left, self.nodes[x].right, self.nodes[x].red);
        } else {
            // emit Log("remove two 2", "y", y, self.nodes[y].parent, self.nodes[y].left, self.nodes[y].right, self.nodes[y].red);
            x = self.nodes[y].right;
            // emit Log("remove two 2", "x", x, self.nodes[x].parent, self.nodes[x].left, self.nodes[x].right, self.nodes[x].red);
        }

        uint yParentKey = self.nodes[y].parent;
        self.nodes[x].parent = yParentKey;
        // emit Log("remove two after", "x", x, self.nodes[x].parent, self.nodes[x].left, self.nodes[x].right, self.nodes[x].red);

        // emit Log("remove three before", "x", x, self.nodes[x].parent, self.nodes[x].left, self.nodes[x].right, self.nodes[x].red);
        // emit Log("remove three before", "y", y, self.nodes[y].parent, self.nodes[y].left, self.nodes[y].right, self.nodes[y].red);
        if (yParentKey != NULL) {
            if (y == self.nodes[yParentKey].left) {
                self.nodes[yParentKey].left = x;
            } else {
                self.nodes[yParentKey].right = x;
            }
        } else {
            self.root = x;
            // emit Log("remove three self.root", "self.root", self.root, self.nodes[self.root].parent, self.nodes[self.root].left, self.nodes[self.root].right, self.nodes[self.root].red);
        }
        // emit Log("remove three after", "self.root", self.root, self.nodes[self.root].parent, self.nodes[self.root].left, self.nodes[self.root].right, self.nodes[self.root].red);

        bool doFixup = !self.nodes[y].red;
        if (y != z) {
            // emit Log("remove before key[z] := key[y]", "self.root", self.root, self.nodes[self.root].parent, self.nodes[self.root].left, self.nodes[self.root].right, self.nodes[self.root].red);
            // emit Log("remove before key[z] := key[y]", "y", y, self.nodes[y].parent, self.nodes[y].left, self.nodes[y].right, self.nodes[y].red);
            // emit Log("remove before key[z] := key[y]", "z", z, self.nodes[z].parent, self.nodes[z].left, self.nodes[z].right, self.nodes[z].red);

            replaceParent(self, y, z);
            // emit Log("remove between key[z] := key[y]", "self.root", self.root, self.nodes[self.root].parent, self.nodes[self.root].left, self.nodes[self.root].right, self.nodes[self.root].red);
            // emit Log("remove between key[z] := key[y]", "y", y, self.nodes[y].parent, self.nodes[y].left, self.nodes[y].right, self.nodes[y].red);
            // emit Log("remove between key[z] := key[y]", "z", z, self.nodes[z].parent, self.nodes[z].left, self.nodes[z].right, self.nodes[z].red);
            self.nodes[y].left = self.nodes[z].left;
            self.nodes[self.nodes[y].left].parent = y;
            self.nodes[y].right = self.nodes[z].right;
            self.nodes[self.nodes[y].right].parent = y;
            self.nodes[y].red = self.nodes[z].red;

            (y, z) = (z, y);

            // emit Log("remove after key[z] := key[y]", "self.root", self.root, self.nodes[self.root].parent, self.nodes[self.root].left, self.nodes[self.root].right, self.nodes[self.root].red);
            // emit Log("remove after key[z] := key[y]", "y", y, self.nodes[y].parent, self.nodes[y].left, self.nodes[y].right, self.nodes[y].red);
            // emit Log("remove after key[z] := key[y]", "z", z, self.nodes[z].parent, self.nodes[z].left, self.nodes[z].right, self.nodes[z].red);
        }
        if (doFixup) {
            removeFixup(self, x);
        }

        // emit Log("remove last", "0", 0, self.nodes[0].parent, self.nodes[0].left, self.nodes[0].right, self.nodes[0].red);
        // emit Log("remove last", "z", z, self.nodes[z].parent, self.nodes[z].left, self.nodes[z].right, self.nodes[z].red);
        // emit Log("remove last", "y", y, self.nodes[y].parent, self.nodes[y].left, self.nodes[y].right, self.nodes[y].red);
        delete self.nodes[0];
        delete self.nodes[y];
    }
    function removeFixup(Tree storage self, uint x) private {
        uint w;
        // emit Log("removeFixup start", "x", x, self.nodes[x].parent, self.nodes[x].left, self.nodes[x].right, self.nodes[x].red);
        while (x != self.root && !self.nodes[x].red) {
            // emit Log("removeFixup in loop", "x", x, self.nodes[x].parent, self.nodes[x].left, self.nodes[x].right, self.nodes[x].red);
            uint xParentKey = self.nodes[x].parent;
            if (x == self.nodes[xParentKey].left) {
                w = self.nodes[xParentKey].right;
                if (self.nodes[w].red) {
                    self.nodes[w].red = false;
                    self.nodes[xParentKey].red = true;
                    rotateLeft(self, xParentKey);
                    w = self.nodes[xParentKey].right;
                }
                if (!self.nodes[self.nodes[w].left].red && !self.nodes[self.nodes[w].right].red) {
                    self.nodes[w].red = true;
                    x = xParentKey;
                } else {
                    if (!self.nodes[self.nodes[w].right].red) {
                        self.nodes[self.nodes[w].left].red = false;
                        self.nodes[w].red = true;
                        rotateRight(self, w);
                        w = self.nodes[xParentKey].right;
                    }
                    self.nodes[w].red = self.nodes[xParentKey].red;
                    self.nodes[xParentKey].red = false;
                    self.nodes[self.nodes[w].right].red = false;
                    rotateLeft(self, xParentKey);
                    x = self.root;
                }
            } else {
                w = self.nodes[xParentKey].left;
                if (self.nodes[w].red) {
                    self.nodes[w].red = false;
                    self.nodes[xParentKey].red = true;
                    rotateRight(self, xParentKey);
                    w = self.nodes[xParentKey].left;
                }
                if (!self.nodes[self.nodes[w].right].red && !self.nodes[self.nodes[w].left].red) {
                    self.nodes[w].red = true;
                    x = xParentKey;
                } else {
                    if (!self.nodes[self.nodes[w].left].red) {
                        self.nodes[self.nodes[w].right].red = false;
                        self.nodes[w].red = true;
                        rotateLeft(self, w);
                        w = self.nodes[xParentKey].left;
                    }
                    self.nodes[w].red = self.nodes[xParentKey].red;
                    self.nodes[xParentKey].red = false;
                    self.nodes[self.nodes[w].left].red = false;
                    rotateRight(self, xParentKey);
                    x = self.root;
                }
            }
        }
        self.nodes[x].red = false;
    }
}
