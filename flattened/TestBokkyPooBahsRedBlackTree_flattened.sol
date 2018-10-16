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
        uint parentKey;
        uint leftKey;
        uint rightKey;
        bool red;
    }

    struct Tree {
        uint root;
        mapping(uint => Node) nodes;
    }

    uint private constant NULL = 0;

    event Log(string where, string action, uint key, uint parentKey, uint leftKey, uint rightKey, bool red);

    function getFirstKey(Tree storage self) internal view returns (uint _key) {
        _key = self.root;
        while (_key != 0 && self.nodes[_key].leftKey != 0) {
            _key = self.nodes[_key].leftKey;
        }
    }
    function getLastKey(Tree storage self) internal view returns (uint _key) {
        _key = self.root;
        while (_key != 0 && self.nodes[_key].rightKey != 0) {
            _key = self.nodes[_key].rightKey;
        }
    }
    function keyExists(Tree storage self, uint key) internal view returns (bool exists) {
        uint _key = self.root;
        while (_key != NULL) {
            if (key == _key) {
                exists = true;
            }
            if (key < _key) {
                _key = self.nodes[_key].leftKey;
            } else {
                _key = self.nodes[_key].rightKey;
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
                _key = self.nodes[_key].leftKey;
            } else {
                _key = self.nodes[_key].rightKey;
            }
        }
    }
    function parentKey(Tree storage self, uint key) internal view returns (uint _parentKey) {
        _parentKey = self.nodes[key].parentKey;
    }
    function parentNode(Tree storage self, uint key) internal view returns (Node _parent) {
        _parent = self.nodes[self.nodes[key].parentKey];
    }
    function grandparentKey(Tree storage self, uint key) internal view returns (uint _grandparentKey) {
        uint _parentKey = self.nodes[key].parentKey;
        if (_parentKey != NULL) {
            _grandparentKey = self.nodes[_parentKey].parentKey;
        }
    }
    function grandparentNode(Tree storage self, uint key) internal view returns (Node _grandparent) {
        uint _parentKey = self.nodes[key].parentKey;
        if (_parentKey != NULL) {
            _grandparent = self.nodes[self.nodes[_parentKey].parentKey];
        }
    }
    function siblingKey(Tree storage self, uint key) internal view returns (uint _siblingKey) {
        uint _parentKey = self.nodes[key].parentKey;
        if (_parentKey != NULL) {
            if (key == self.nodes[_parentKey].leftKey) {
                _siblingKey = self.nodes[_parentKey].rightKey;
            } else {
                _siblingKey = self.nodes[_parentKey].leftKey;
            }
        }
    }
    function siblingNode(Tree storage self, uint key) internal view returns (Node _sibling) {
        uint _parentKey = self.nodes[key].parentKey;
        if (_parentKey != NULL) {
            if (key == self.nodes[_parentKey].leftKey) {
                _sibling = self.nodes[self.nodes[_parentKey].rightKey];
            } else {
                _sibling = self.nodes[self.nodes[_parentKey].leftKey];
            }
        }
    }
    function uncleKey(Tree storage self, uint key) internal view returns (uint _uncleKey) {
        uint _grandParentKey = grandparentKey(self, key);
        if (_grandParentKey != NULL) {
            uint _parentKey = self.nodes[key].parentKey;
            _uncleKey = siblingKey(self, _parentKey);
        }
    }
    function uncle(Tree storage self, uint key) internal view returns (Node _uncle) {
        uint _grandParentKey = grandparentKey(self, key);
        if (_grandParentKey != NULL) {
            uint _parentKey = self.nodes[key].parentKey;
            _uncle = siblingNode(self, _parentKey);
        }
    }

    function rotateLeft(Tree storage self, uint x) private {
        uint y = self.nodes[x].rightKey;
        uint parent = self.nodes[x].parentKey;
        // emit Log("rotateLeft", "x", x, parent, self.nodes[x].leftKey, self.nodes[x].rightKey, self.nodes[x].red);
        self.nodes[x].rightKey = self.nodes[y].leftKey;
        if (self.nodes[y].leftKey != NULL) {
            self.nodes[self.nodes[y].leftKey].parentKey = x;
        }
        self.nodes[y].parentKey = parent;
        if (parent == NULL) {
            self.root = y;
        } else if (x == self.nodes[parent].leftKey) {
            self.nodes[parent].leftKey = y;
        } else {
            self.nodes[parent].rightKey = y;
        }
        self.nodes[y].leftKey = x;
        self.nodes[x].parentKey = y;
    }
    function rotateRight(Tree storage self, uint x) private {
        uint y = self.nodes[x].leftKey;
        uint parent = self.nodes[x].parentKey;
        // emit Log("rotateRight", "x", x, parent, self.nodes[x].leftKey, self.nodes[x].rightKey, self.nodes[x].red);
        self.nodes[x].leftKey = self.nodes[y].rightKey;
        if (self.nodes[y].rightKey != NULL) {
            self.nodes[self.nodes[y].rightKey].parentKey = x;
        }
        self.nodes[y].parentKey = parent;
        if (parent == NULL) {
            self.root = y;
        } else if (x == self.nodes[parent].rightKey) {
            self.nodes[parent].rightKey = y;
        } else {
            self.nodes[parent].leftKey = y;
        }
        self.nodes[y].rightKey = x;
        self.nodes[x].parentKey = y;
    }

    function insert(Tree storage self, uint z) internal {
        uint y = NULL;
        uint x = self.root;
        while (x != NULL) {
            y = x;
            if (z < x) {
                x = self.nodes[x].leftKey;
            } else {
                x = self.nodes[x].rightKey;
            }
        }
        self.nodes[z] = Node(y, 0, 0, true);
        if (y == NULL) {
            self.root = z;
        } else if (z < y) {
            self.nodes[y].leftKey = z;
        } else {
            self.nodes[y].rightKey = z;
        }
        // emit Log("insert", "z", z, self.nodes[z].parentKey, self.nodes[z].leftKey, self.nodes[z].rightKey, self.nodes[z].red);
        insertFixup(self, z);
    }

    function insertFixup(Tree storage self, uint z) private {
        uint y;

        // emit Log("insertFixup", "z", z, self.nodes[z].parentKey, self.nodes[z].leftKey, self.nodes[z].rightKey, self.nodes[z].red);
        // uint p = self.nodes[z].parentKey;
        // emit Log("insertFixup", "parent", p, self.nodes[p].parentKey, self.nodes[p].leftKey, self.nodes[p].rightKey, self.nodes[p].red);
        // uint g = self.nodes[p].parentKey;
        // emit Log("insertFixup", "grandparent", g, self.nodes[g].parentKey, self.nodes[g].leftKey, self.nodes[g].rightKey, self.nodes[g].red);

        while (z != self.root && self.nodes[self.nodes[z].parentKey].red) {
            if (self.nodes[z].parentKey == self.nodes[self.nodes[self.nodes[z].parentKey].parentKey].leftKey) {
                // emit Log("insertFixup", "l1", 0, 0, 0, 0, false);
                y = self.nodes[self.nodes[self.nodes[z].parentKey].parentKey].rightKey;
                // emit Log("insertFixup", "l1 y", y, self.nodes[y].parentKey, self.nodes[y].leftKey, self.nodes[y].rightKey, self.nodes[y].red);
                if (self.nodes[y].red) {
                    // emit Log("insertFixup", "l1a", 0, 0, 0, 0, false);
                    self.nodes[self.nodes[z].parentKey].red = false;
                    self.nodes[y].red = false;
                    self.nodes[self.nodes[self.nodes[z].parentKey].parentKey].red = true;
                    z = self.nodes[self.nodes[z].parentKey].parentKey;
                } else {
                    if (z == self.nodes[self.nodes[z].parentKey].rightKey) {
                      // emit Log("insertFixup", "l1b", 0, 0, 0, 0, false);
                      z = self.nodes[z].parentKey;
                      rotateLeft(self, z);
                    }
                    self.nodes[self.nodes[z].parentKey].red = false;
                    self.nodes[self.nodes[self.nodes[z].parentKey].parentKey].red = true;
                    rotateRight(self, self.nodes[self.nodes[z].parentKey].parentKey);
                }
            } else {
                // emit Log("insertFixup", "r1", 0, 0, 0, 0, false);
                y = self.nodes[self.nodes[self.nodes[z].parentKey].parentKey].leftKey;
                // emit Log("insertFixup", "r1 y", y, self.nodes[y].parentKey, self.nodes[y].leftKey, self.nodes[y].rightKey, self.nodes[y].red);
                if (self.nodes[y].red) {
                    // emit Log("insertFixup", "r1a", 0, 0, 0, 0, false);
                    self.nodes[self.nodes[z].parentKey].red = false;
                    self.nodes[y].red = false;
                    self.nodes[self.nodes[self.nodes[z].parentKey].parentKey].red = true;
                    z = self.nodes[self.nodes[z].parentKey].parentKey;
                } else {
                    if (z == self.nodes[self.nodes[z].parentKey].leftKey) {
                      // emit Log("insertFixup", "r1b", 0, 0, 0, 0, false);
                      z = self.nodes[z].parentKey;
                      rotateRight(self, z);
                    }
                    self.nodes[self.nodes[z].parentKey].red = false;
                    self.nodes[self.nodes[self.nodes[z].parentKey].parentKey].red = true;
                    rotateLeft(self, self.nodes[self.nodes[z].parentKey].parentKey);
                }
            }
        }
        self.nodes[self.root].red = false;
    }

    // replaceParent(self, y, z);
    function replaceParent(Tree storage self, uint a, uint b) private {
        // emit Log("replaceParent before", "self.root", self.root, self.nodes[self.root].parentKey, self.nodes[self.root].leftKey, self.nodes[self.root].rightKey, self.nodes[self.root].red);
        // emit Log("replaceParent before", "a", a, self.nodes[a].parentKey, self.nodes[a].leftKey, self.nodes[a].rightKey, self.nodes[a].red);
        // emit Log("replaceParent before", "b", b, self.nodes[b].parentKey, self.nodes[b].leftKey, self.nodes[b].rightKey, self.nodes[b].red);
        self.nodes[a].parentKey = self.nodes[b].parentKey;
        if (self.nodes[b].parentKey == NULL) {
            self.root = a;
        } else {
            // uint bParent = self.nodes[b].parentKey;
            if (b == self.nodes[self.nodes[b].parentKey].leftKey) {
                // emit Log("replaceParent aaa", "a", a, self.nodes[a].parentKey, self.nodes[a].leftKey, self.nodes[a].rightKey, self.nodes[a].red);
                // emit Log("replaceParent aaa", "b", b, self.nodes[b].parentKey, self.nodes[b].leftKey, self.nodes[b].rightKey, self.nodes[b].red);
                // emit Log("replaceParent aaa before", "bParent", bParent, self.nodes[bParent].parentKey, self.nodes[bParent].leftKey, self.nodes[bParent].rightKey, self.nodes[bParent].red);
                self.nodes[self.nodes[b].parentKey].leftKey = a;
                // emit Log("replaceParent aaa after", "bParent", bParent, self.nodes[bParent].parentKey, self.nodes[bParent].leftKey, self.nodes[bParent].rightKey, self.nodes[bParent].red);
            } else {
                // emit Log("replaceParent bbb", "a", a, self.nodes[a].parentKey, self.nodes[a].leftKey, self.nodes[a].rightKey, self.nodes[a].red);
                // emit Log("replaceParent bbb", "b", b, self.nodes[b].parentKey, self.nodes[b].leftKey, self.nodes[b].rightKey, self.nodes[b].red);
                // emit Log("replaceParent bbb before", "bParent", bParent, self.nodes[bParent].parentKey, self.nodes[bParent].leftKey, self.nodes[bParent].rightKey, self.nodes[bParent].red);
                self.nodes[self.nodes[b].parentKey].rightKey = a;
                // emit Log("replaceParent bbb after", "bParent", bParent, self.nodes[bParent].parentKey, self.nodes[bParent].leftKey, self.nodes[bParent].rightKey, self.nodes[bParent].red);
            }
        }
        // emit Log("replaceParent after", "self.root", self.root, self.nodes[self.root].parentKey, self.nodes[self.root].leftKey, self.nodes[self.root].rightKey, self.nodes[self.root].red);
        // emit Log("replaceParent after", "a", a, self.nodes[a].parentKey, self.nodes[a].leftKey, self.nodes[a].rightKey, self.nodes[a].red);
        // emit Log("replaceParent after", "b", b, self.nodes[b].parentKey, self.nodes[b].leftKey, self.nodes[b].rightKey, self.nodes[b].red);
    }

    function remove(Tree storage self, uint z) internal {
        uint x;
        uint y;

        // emit Log("remove one 1", "z", z, self.nodes[z].parentKey, self.nodes[z].leftKey, self.nodes[z].rightKey, self.nodes[z].red);
        if (self.nodes[z].leftKey == NULL || self.nodes[z].rightKey == NULL) {
            y = z;
            // emit Log("remove one 2", "y", y, self.nodes[y].parentKey, self.nodes[y].leftKey, self.nodes[y].rightKey, self.nodes[y].red);
        } else {
            y = self.nodes[z].rightKey;
            // emit Log("remove one 3", "y", y, self.nodes[y].parentKey, self.nodes[y].leftKey, self.nodes[y].rightKey, self.nodes[y].red);
            while (self.nodes[y].leftKey != NULL) {
                y = self.nodes[y].leftKey;
                // emit Log("remove one 4", "y", y, self.nodes[y].parentKey, self.nodes[y].leftKey, self.nodes[y].rightKey, self.nodes[y].red);
            }
        }
        // emit Log("remove one after", "y", y, self.nodes[y].parentKey, self.nodes[y].leftKey, self.nodes[y].rightKey, self.nodes[y].red);
        // emit Log("remove one after", "z", z, self.nodes[z].parentKey, self.nodes[z].leftKey, self.nodes[z].rightKey, self.nodes[z].red);

        if (self.nodes[y].leftKey != NULL) {
            // emit Log("remove two 1", "y", y, self.nodes[y].parentKey, self.nodes[y].leftKey, self.nodes[y].rightKey, self.nodes[y].red);
            x = self.nodes[y].leftKey;
            // emit Log("remove two 1", "x", x, self.nodes[x].parentKey, self.nodes[x].leftKey, self.nodes[x].rightKey, self.nodes[x].red);
        } else {
            // emit Log("remove two 2", "y", y, self.nodes[y].parentKey, self.nodes[y].leftKey, self.nodes[y].rightKey, self.nodes[y].red);
            x = self.nodes[y].rightKey;
            // emit Log("remove two 2", "x", x, self.nodes[x].parentKey, self.nodes[x].leftKey, self.nodes[x].rightKey, self.nodes[x].red);
        }

        self.nodes[x].parentKey = self.nodes[y].parentKey;
        // emit Log("remove two after", "x", x, self.nodes[x].parentKey, self.nodes[x].leftKey, self.nodes[x].rightKey, self.nodes[x].red);

        // emit Log("remove three before", "x", x, self.nodes[x].parentKey, self.nodes[x].leftKey, self.nodes[x].rightKey, self.nodes[x].red);
        // emit Log("remove three before", "y", y, self.nodes[y].parentKey, self.nodes[y].leftKey, self.nodes[y].rightKey, self.nodes[y].red);
        if (self.nodes[y].parentKey != NULL) {
            if (y == self.nodes[self.nodes[y].parentKey].leftKey) {
                self.nodes[self.nodes[y].parentKey].leftKey = x;
            } else {
                self.nodes[self.nodes[y].parentKey].rightKey = x;
            }
        } else {
            self.root = x;
            // emit Log("remove three self.root", "self.root", self.root, self.nodes[self.root].parentKey, self.nodes[self.root].leftKey, self.nodes[self.root].rightKey, self.nodes[self.root].red);
        }
        // emit Log("remove three after", "self.root", self.root, self.nodes[self.root].parentKey, self.nodes[self.root].leftKey, self.nodes[self.root].rightKey, self.nodes[self.root].red);

        bool doFixup = !self.nodes[y].red;
        if (y != z) {
            // emit Log("remove before key[z] := key[y]", "self.root", self.root, self.nodes[self.root].parentKey, self.nodes[self.root].leftKey, self.nodes[self.root].rightKey, self.nodes[self.root].red);
            // emit Log("remove before key[z] := key[y]", "y", y, self.nodes[y].parentKey, self.nodes[y].leftKey, self.nodes[y].rightKey, self.nodes[y].red);
            // emit Log("remove before key[z] := key[y]", "z", z, self.nodes[z].parentKey, self.nodes[z].leftKey, self.nodes[z].rightKey, self.nodes[z].red);

            replaceParent(self, y, z);
            // emit Log("remove between key[z] := key[y]", "self.root", self.root, self.nodes[self.root].parentKey, self.nodes[self.root].leftKey, self.nodes[self.root].rightKey, self.nodes[self.root].red);
            // emit Log("remove between key[z] := key[y]", "y", y, self.nodes[y].parentKey, self.nodes[y].leftKey, self.nodes[y].rightKey, self.nodes[y].red);
            // emit Log("remove between key[z] := key[y]", "z", z, self.nodes[z].parentKey, self.nodes[z].leftKey, self.nodes[z].rightKey, self.nodes[z].red);
            self.nodes[y].leftKey = self.nodes[z].leftKey;
            self.nodes[self.nodes[y].leftKey].parentKey = y;
            self.nodes[y].rightKey = self.nodes[z].rightKey;
            self.nodes[self.nodes[y].rightKey].parentKey = y;
            self.nodes[y].red = self.nodes[z].red;

            (y, z) = (z, y);

            // emit Log("remove after key[z] := key[y]", "self.root", self.root, self.nodes[self.root].parentKey, self.nodes[self.root].leftKey, self.nodes[self.root].rightKey, self.nodes[self.root].red);
            // emit Log("remove after key[z] := key[y]", "y", y, self.nodes[y].parentKey, self.nodes[y].leftKey, self.nodes[y].rightKey, self.nodes[y].red);
            // emit Log("remove after key[z] := key[y]", "z", z, self.nodes[z].parentKey, self.nodes[z].leftKey, self.nodes[z].rightKey, self.nodes[z].red);
        }
        if (doFixup) {
            deleteFixup(self, x);
        }

        // emit Log("remove last", "0", 0, self.nodes[0].parentKey, self.nodes[0].leftKey, self.nodes[0].rightKey, self.nodes[0].red);
        // emit Log("remove last", "z", z, self.nodes[z].parentKey, self.nodes[z].leftKey, self.nodes[z].rightKey, self.nodes[z].red);
        // emit Log("remove last", "y", y, self.nodes[y].parentKey, self.nodes[y].leftKey, self.nodes[y].rightKey, self.nodes[y].red);
        delete self.nodes[0];
        delete self.nodes[y];
    }

    function deleteFixup(Tree storage self, uint x) private {
        uint w;
        // emit Log("deleteFixup start", "x", x, self.nodes[x].parentKey, self.nodes[x].leftKey, self.nodes[x].rightKey, self.nodes[x].red);
        while (x != self.root && !self.nodes[x].red) {
            // emit Log("deleteFixup in loop", "x", x, self.nodes[x].parentKey, self.nodes[x].leftKey, self.nodes[x].rightKey, self.nodes[x].red);
            if (x == self.nodes[self.nodes[x].parentKey].leftKey) {
                w = self.nodes[self.nodes[x].parentKey].rightKey;
                if (self.nodes[w].red) {
                    self.nodes[w].red = false;
                    self.nodes[self.nodes[x].parentKey].red = true;
                    rotateLeft(self, self.nodes[x].parentKey);
                    w = self.nodes[self.nodes[x].parentKey].rightKey;
                }
                if (!self.nodes[self.nodes[w].leftKey].red && !self.nodes[self.nodes[w].rightKey].red) {
                    self.nodes[w].red = true;
                    x = self.nodes[x].parentKey;
                } else {
                    if (!self.nodes[self.nodes[w].rightKey].red) {
                        self.nodes[self.nodes[w].leftKey].red = false;
                        self.nodes[w].red = true;
                        rotateRight(self, w);
                        w = self.nodes[self.nodes[x].parentKey].rightKey;
                    }
                    self.nodes[w].red = self.nodes[self.nodes[x].parentKey].red;
                    self.nodes[self.nodes[x].parentKey].red = false;
                    self.nodes[self.nodes[w].rightKey].red = false;
                    rotateLeft(self, self.nodes[x].parentKey);
                    x = self.root;
                }
            } else {
                w = self.nodes[self.nodes[x].parentKey].leftKey;
                if (self.nodes[w].red) {
                    self.nodes[w].red = false;
                    self.nodes[self.nodes[x].parentKey].red = true;
                    rotateRight(self, self.nodes[x].parentKey);
                    w = self.nodes[self.nodes[x].parentKey].leftKey;
                }
                if (!self.nodes[self.nodes[w].rightKey].red && !self.nodes[self.nodes[w].leftKey].red) {
                    self.nodes[w].red = true;
                    x = self.nodes[x].parentKey;
                } else {
                    if (!self.nodes[self.nodes[w].leftKey].red) {
                        self.nodes[self.nodes[w].rightKey].red = false;
                        self.nodes[w].red = true;
                        rotateLeft(self, w);
                        w = self.nodes[self.nodes[x].parentKey].leftKey;
                    }
                    self.nodes[w].red = self.nodes[self.nodes[x].parentKey].red;
                    self.nodes[self.nodes[x].parentKey].red = false;
                    self.nodes[self.nodes[w].leftKey].red = false;
                    rotateRight(self, self.nodes[x].parentKey);
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

    // Copied here from the library so the event is generated in the ABI
    event Log(string where, string action, uint key, uint parentKey, uint leftKey, uint rightKey, bool red);

    constructor() public {
    }
    function root() public view returns (uint _key) {
        _key = tree.root;
    }
    function getFirstKey() public view returns (uint _key) {
        _key = tree.getFirstKey();
    }
    function getLastKey() public view returns (uint _key) {
        _key = tree.getLastKey();
    }
    function getNode(uint _key) public view returns (uint key, uint parent, uint left, uint right, bool red, uint value) {
        require(_key != 0);
        if (tree.keyExists(_key)) {
            BokkyPooBahsRedBlackTreeLibrary.Node memory node = tree.getNode(_key);
            (key, parent, left, right, red) = (_key, node.parentKey, node.leftKey, node.rightKey, node.red);
            value = values[_key];
        }
    }
    function insert(uint _key, uint _value) public {
        require(_key != 0);
        tree.insert(_key);
        values[_key] = _value;
    }
    function remove(uint _key) public {
        require(_key != 0);
        tree.remove(_key);
        delete values[_key];
    }
}
