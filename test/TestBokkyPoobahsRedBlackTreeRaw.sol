pragma solidity ^0.4.25;

import "BokkyPooBahsRedBlackTreeLibrary.sol";

// ----------------------------------------------------------------------------
// BokkyPooBah's RedBlackTree Library v0.90 - Contract for testing
//
// A Solidity Red-Black Tree library to store and maintain a sorted data
// structure in a Red-Black binary search tree, with O(log n) insert, remove
// and search time (and gas, approximately)
//
// https://github.com/bokkypoobah/BokkyPooBahsRedBlackTreeLibrary
//
//
// Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2018. The MIT Licence.
// ----------------------------------------------------------------------------

contract TestBokkyPooBahsRedBlackTreeRaw {
    using BokkyPooBahsRedBlackTreeLibrary for BokkyPooBahsRedBlackTreeLibrary.Tree;

    BokkyPooBahsRedBlackTreeLibrary.Tree tree;

    event Log(string where, string action, uint key, uint parent, uint left, uint right, bool red);

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
    function getNode(uint _key) public view returns (uint key, uint parent, uint left, uint right, bool red) {
        (key, parent, left, right, red) = tree.getNode(_key);
    }
    function parent(uint key) public view returns (uint _parent) {
        _parent = tree.parent(key);
    }
    // function parentNode(uint _key) public view returns (uint key, uint _parent, uint left, uint right, bool red) {
    //     BokkyPooBahsRedBlackTreeLibrary.Node memory node = tree.parentNode(_key);
    //     (key, _parent, left, right, red) = (_key, node.parent, node.left, node.right, node.red);
    // }
    function grandparent(uint key) public view returns (uint _parent) {
        _parent = tree.grandparent(key);
    }
    // function grandparentNode(uint _key) public view returns (uint key, uint _parent, uint left, uint right, bool red) {
    //     BokkyPooBahsRedBlackTreeLibrary.Node memory node = tree.grandparentNode(_key);
    //     (key, _parent, left, right, red) = (_key, node.parent, node.left, node.right, node.red);
    // }
    function sibling(uint key) public view returns (uint _parent) {
        _parent = tree.sibling(key);
    }
    // function siblingNode(uint _key) public view returns (uint key, uint _parent, uint left, uint right, bool red) {
    //     BokkyPooBahsRedBlackTreeLibrary.Node memory node = tree.siblingNode(_key);
    //     (key, _parent, left, right, red) = (_key, node.parent, node.left, node.right, node.red);
    // }
    function uncle(uint key) public view returns (uint _parent) {
        _parent = tree.uncle(key);
    }
    // function uncleNode(uint _key) public view returns (uint key, uint _parent, uint left, uint right, bool red) {
    //     BokkyPooBahsRedBlackTreeLibrary.Node memory node = tree.uncleNode(_key);
    //     (key, _parent, left, right, red) = (_key, node.parent, node.left, node.right, node.red);
    // }

    function insert(uint _key) public {
        tree.insert(_key);
    }
    function remove(uint _key) public {
        tree.remove(_key);
    }
}
