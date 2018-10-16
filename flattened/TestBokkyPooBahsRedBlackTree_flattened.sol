pragma solidity ^0.4.25;


// ----------------------------------------------------------------------------
// BokkyPooBah's RedBlackTree Library v0.90
//
// A Solidity Red-Black Tree library to store and maintain a sorted data
// structure in a Red-Black binary search tree, with O(log n) insert, remove
// and search time (and gas, approximately)
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

    function first(Tree storage self) internal view returns (uint _key) {
        _key = self.root;
        while (_key != NULL && self.nodes[_key].left != NULL) {
            _key = self.nodes[_key].left;
        }
    }
    function last(Tree storage self) internal view returns (uint _key) {
        _key = self.root;
        while (_key != NULL && self.nodes[_key].right != NULL) {
            _key = self.nodes[_key].right;
        }
    }
    function next(Tree storage self, uint key) internal view returns (uint _key) {
        require(key != NULL);
        if (self.nodes[key].right != NULL) {
            _key = treeMinimum(self, key);
        } else {
            _key = self.nodes[key].parent;
            while (_key != NULL && _key == self.nodes[_key].right) {
                key = _key;
                _key = self.nodes[key].parent;
            }
        }
    }
    function prev(Tree storage self, uint key) internal view returns (uint _key) {
        require(key != NULL);
        if (self.nodes[key].left != NULL) {
            _key = treeMaximum(self, key);
        } else {
            _key = self.nodes[key].parent;
            while (_key != NULL && _key == self.nodes[_key].left) {
                key = _key;
                _key = self.nodes[key].parent;
            }
        }
    }
    function exists(Tree storage self, uint key) internal view returns (bool _exists) {
        require(key != NULL);
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
        require(key != NULL);
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
        require(key != NULL);
        _parent = self.nodes[key].parent;
    }
    function parentNode(Tree storage self, uint key) internal view returns (Node _parentNode) {
        require(key != NULL);
        _parentNode = self.nodes[self.nodes[key].parent];
    }
    function grandparent(Tree storage self, uint key) internal view returns (uint _grandparent) {
        require(key != NULL);
        uint _parent = self.nodes[key].parent;
        if (_parent != NULL) {
            _grandparent = self.nodes[_parent].parent;
        }
    }
    function grandparentNode(Tree storage self, uint key) internal view returns (Node _grandparentNode) {
        require(key != NULL);
        uint _parent = self.nodes[key].parent;
        if (_parent != NULL) {
            _grandparentNode = self.nodes[self.nodes[_parent].parent];
        }
    }
    function sibling(Tree storage self, uint key) internal view returns (uint _sibling) {
        require(key != NULL);
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
        require(key != NULL);
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
        require(key != NULL);
        uint _grandParent = grandparent(self, key);
        if (_grandParent != NULL) {
            uint _parent = self.nodes[key].parent;
            _uncle = sibling(self, _parent);
        }
    }
    function uncleNode(Tree storage self, uint key) internal view returns (Node _uncleNode) {
        require(key != NULL);
        uint _grandParent = grandparent(self, key);
        if (_grandParent != NULL) {
            uint _parent = self.nodes[key].parent;
            _uncleNode = siblingNode(self, _parent);
        }
    }

    function insert(Tree storage self, uint z) internal {
        require(z != NULL);
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
        self.nodes[z] = Node(y, NULL, NULL, true);
        if (y == NULL) {
            self.root = z;
        } else if (z < y) {
            self.nodes[y].left = z;
        } else {
            self.nodes[y].right = z;
        }
        insertFixup(self, z);
    }
    function remove(Tree storage self, uint z) internal {
        require(z != NULL);
        uint x;
        uint y;

        if (self.nodes[z].left == NULL || self.nodes[z].right == NULL) {
            y = z;
        } else {
            y = self.nodes[z].right;
            while (self.nodes[y].left != NULL) {
                y = self.nodes[y].left;
            }
        }
        if (self.nodes[y].left != NULL) {
            x = self.nodes[y].left;
        } else {
            x = self.nodes[y].right;
        }
        uint yParent = self.nodes[y].parent;
        self.nodes[x].parent = yParent;
        if (yParent != NULL) {
            if (y == self.nodes[yParent].left) {
                self.nodes[yParent].left = x;
            } else {
                self.nodes[yParent].right = x;
            }
        } else {
            self.root = x;
        }
        bool doFixup = !self.nodes[y].red;
        if (y != z) {
            replaceParent(self, y, z);
            self.nodes[y].left = self.nodes[z].left;
            self.nodes[self.nodes[y].left].parent = y;
            self.nodes[y].right = self.nodes[z].right;
            self.nodes[self.nodes[y].right].parent = y;
            self.nodes[y].red = self.nodes[z].red;
            (y, z) = (z, y);
        }
        if (doFixup) {
            removeFixup(self, x);
            // TODO Check if required delete self.nodes[0];
        }
        delete self.nodes[y];
    }

    function treeMinimum(Tree storage self, uint key) private view returns (uint) {
        while (self.nodes[key].left != NULL) {
            key = self.nodes[key].left;
        }
        return key;
    }
    function treeMaximum(Tree storage self, uint key) private view returns (uint) {
        while (self.nodes[key].right != NULL) {
            key = self.nodes[key].right;
        }
        return key;
    }

    function rotateLeft(Tree storage self, uint x) private {
        uint y = self.nodes[x].right;
        uint _parent = self.nodes[x].parent;
        uint yLeft = self.nodes[y].left;
        self.nodes[x].right = yLeft;
        if (yLeft != NULL) {
            self.nodes[yLeft].parent = x;
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
        uint yRight = self.nodes[y].right;
        self.nodes[x].left = yRight;
        if (yRight != NULL) {
            self.nodes[yRight].parent = x;
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

    function insertFixup(Tree storage self, uint z) private {
        uint y;

        while (z != self.root && self.nodes[self.nodes[z].parent].red) {
            uint zParent = self.nodes[z].parent;
            if (zParent == self.nodes[self.nodes[zParent].parent].left) {
                y = self.nodes[self.nodes[zParent].parent].right;
                if (self.nodes[y].red) {
                    self.nodes[zParent].red = false;
                    self.nodes[y].red = false;
                    self.nodes[self.nodes[zParent].parent].red = true;
                    z = self.nodes[zParent].parent;
                } else {
                    if (z == self.nodes[zParent].right) {
                      z = zParent;
                      rotateLeft(self, z);
                    }
                    zParent = self.nodes[z].parent;
                    self.nodes[zParent].red = false;
                    self.nodes[self.nodes[zParent].parent].red = true;
                    rotateRight(self, self.nodes[zParent].parent);
                }
            } else {
                y = self.nodes[self.nodes[zParent].parent].left;
                if (self.nodes[y].red) {
                    self.nodes[zParent].red = false;
                    self.nodes[y].red = false;
                    self.nodes[self.nodes[zParent].parent].red = true;
                    z = self.nodes[zParent].parent;
                } else {
                    if (z == self.nodes[zParent].left) {
                      z = zParent;
                      rotateRight(self, z);
                    }
                    zParent = self.nodes[z].parent;
                    self.nodes[zParent].red = false;
                    self.nodes[self.nodes[zParent].parent].red = true;
                    rotateLeft(self, self.nodes[zParent].parent);
                }
            }
        }
        self.nodes[self.root].red = false;
    }

    function replaceParent(Tree storage self, uint a, uint b) private {
        uint bParent = self.nodes[b].parent;
        self.nodes[a].parent = bParent;
        if (bParent == NULL) {
            self.root = a;
        } else {
            if (b == self.nodes[bParent].left) {
                self.nodes[bParent].left = a;
            } else {
                self.nodes[bParent].right = a;
            }
        }
    }
    function removeFixup(Tree storage self, uint x) private {
        uint w;
        while (x != self.root && !self.nodes[x].red) {
            uint xParent = self.nodes[x].parent;
            if (x == self.nodes[xParent].left) {
                w = self.nodes[xParent].right;
                if (self.nodes[w].red) {
                    self.nodes[w].red = false;
                    self.nodes[xParent].red = true;
                    rotateLeft(self, xParent);
                    w = self.nodes[xParent].right;
                }
                if (!self.nodes[self.nodes[w].left].red && !self.nodes[self.nodes[w].right].red) {
                    self.nodes[w].red = true;
                    x = xParent;
                } else {
                    if (!self.nodes[self.nodes[w].right].red) {
                        self.nodes[self.nodes[w].left].red = false;
                        self.nodes[w].red = true;
                        rotateRight(self, w);
                        w = self.nodes[xParent].right;
                    }
                    self.nodes[w].red = self.nodes[xParent].red;
                    self.nodes[xParent].red = false;
                    self.nodes[self.nodes[w].right].red = false;
                    rotateLeft(self, xParent);
                    x = self.root;
                }
            } else {
                w = self.nodes[xParent].left;
                if (self.nodes[w].red) {
                    self.nodes[w].red = false;
                    self.nodes[xParent].red = true;
                    rotateRight(self, xParent);
                    w = self.nodes[xParent].left;
                }
                if (!self.nodes[self.nodes[w].right].red && !self.nodes[self.nodes[w].left].red) {
                    self.nodes[w].red = true;
                    x = xParent;
                } else {
                    if (!self.nodes[self.nodes[w].left].red) {
                        self.nodes[self.nodes[w].right].red = false;
                        self.nodes[w].red = true;
                        rotateLeft(self, w);
                        w = self.nodes[xParent].left;
                    }
                    self.nodes[w].red = self.nodes[xParent].red;
                    self.nodes[xParent].red = false;
                    self.nodes[self.nodes[w].left].red = false;
                    rotateRight(self, xParent);
                    x = self.root;
                }
            }
        }
        self.nodes[x].red = false;
    }
}

contract TestBokkyPooBahsRedBlackTree {
    using BokkyPooBahsRedBlackTreeLibrary for BokkyPooBahsRedBlackTreeLibrary.Tree;

    BokkyPooBahsRedBlackTreeLibrary.Tree tree;
    mapping(uint => uint) values;

    constructor() public {
    }
    function root() public view returns (uint _key) {
        _key = tree.root;
    }
    function first() public view returns (uint _key) {
        _key = tree.first();
    }
    function last() public view returns (uint _key) {
        _key = tree.last();
    }
    function next(uint key) public view returns (uint _key) {
        _key = tree.next(key);
    }
    function prev(uint key) public view returns (uint _key) {
        _key = tree.prev(key);
    }
    function exists(uint key) public view returns (bool _exists) {
        _exists = tree.exists(key);
    }
    function getNode(uint _key) public view returns (uint key, uint parent, uint left, uint right, bool red, uint value) {
        if (tree.exists(_key)) {
            BokkyPooBahsRedBlackTreeLibrary.Node memory node = tree.getNode(_key);
            (key, parent, left, right, red) = (_key, node.parent, node.left, node.right, node.red);
            value = values[_key];
        }
    }
    function insert(uint _key, uint _value) public {
        tree.insert(_key);
        values[_key] = _value;
    }
    function remove(uint _key) public {
        tree.remove(_key);
        delete values[_key];
    }
}
