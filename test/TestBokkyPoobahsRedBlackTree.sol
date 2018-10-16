pragma solidity ^0.4.25;

import "BokkyPooBahsRedBlackTreeLibrary.sol";

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
