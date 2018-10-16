// ETH/USD 30 Jan 2018 05:05 AEDT => 1198.26 from CMC
var ethPriceUSD = 199.17;
var defaultGasPrice = web3.toWei(2, "gwei");

// -----------------------------------------------------------------------------
// Accounts
// -----------------------------------------------------------------------------
var accounts = [];
var accountNames = {};

addAccount(eth.accounts[0], "Miner");
addAccount(eth.accounts[1], "Deployer");
addAccount(eth.accounts[2], "Wallet");
addAccount(eth.accounts[3], "User1");
addAccount(eth.accounts[4], "User2");
addAccount(eth.accounts[5], "User3");

var miner = eth.accounts[0];
var deployer = eth.accounts[1];
var wallet = eth.accounts[2];
var user1 = eth.accounts[3];
var user2 = eth.accounts[4];
var user3 = eth.accounts[5];

console.log("DATA: var miner=\"" + eth.accounts[0] + "\";");
console.log("DATA: var deployer=\"" + eth.accounts[1] + "\";");
console.log("DATA: var wallet=\"" + eth.accounts[2] + "\";");
console.log("DATA: var user1=\"" + eth.accounts[3] + "\";");
console.log("DATA: var user2=\"" + eth.accounts[4] + "\";");
console.log("DATA: var user3=\"" + eth.accounts[5] + "\";");

var baseBlock = eth.blockNumber;

function unlockAccounts(password) {
  for (var i = 0; i < eth.accounts.length && i < accounts.length; i++) {
    personal.unlockAccount(eth.accounts[i], password, 100000);
    if (i > 0 && eth.getBalance(eth.accounts[i]) == 0) {
      personal.sendTransaction({from: eth.accounts[0], to: eth.accounts[i], value: web3.toWei(1000000, "ether")});
    }
  }
  while (txpool.status.pending > 0) {
  }
  baseBlock = eth.blockNumber;
}

function addAccount(account, accountName) {
  accounts.push(account);
  accountNames[account] = accountName;
}


// -----------------------------------------------------------------------------
// Token Contract
// -----------------------------------------------------------------------------
var tokenContractAddress = null;
var tokenContractAbi = null;

function addTokenContractAddressAndAbi(address, tokenAbi) {
  tokenContractAddress = address;
  tokenContractAbi = tokenAbi;
}


// -----------------------------------------------------------------------------
// Account ETH and token balances
// -----------------------------------------------------------------------------
function printBalances() {
  var token = tokenContractAddress == null || tokenContractAbi == null ? null : web3.eth.contract(tokenContractAbi).at(tokenContractAddress);
  var decimals = token == null ? 18 : token.decimals();
  var i = 0;
  var totalTokenBalance = new BigNumber(0);
  console.log("RESULT:  # Account                                             EtherBalanceChange                          Token Name");
  console.log("RESULT: -- ------------------------------------------ --------------------------- ------------------------------ ---------------------------");
  accounts.forEach(function(e) {
    var etherBalanceBaseBlock = eth.getBalance(e, baseBlock);
    var etherBalance = web3.fromWei(eth.getBalance(e).minus(etherBalanceBaseBlock), "ether");
    var tokenBalance = token == null ? new BigNumber(0) : token.balanceOf(e).shift(-decimals);
    totalTokenBalance = totalTokenBalance.add(tokenBalance);
    console.log("RESULT: " + pad2(i) + " " + e  + " " + pad(etherBalance) + " " + padToken(tokenBalance, decimals) + " " + accountNames[e]);
    i++;
  });
  console.log("RESULT: -- ------------------------------------------ --------------------------- ------------------------------ ---------------------------");
  console.log("RESULT:                                                                           " + padToken(totalTokenBalance, decimals) + " Total Token Balances");
  console.log("RESULT: -- ------------------------------------------ --------------------------- ------------------------------ ---------------------------");
  console.log("RESULT: ");
}

function pad2(s) {
  var o = s.toFixed(0);
  while (o.length < 2) {
    o = " " + o;
  }
  return o;
}

function pad(s) {
  var o = s.toFixed(18);
  while (o.length < 27) {
    o = " " + o;
  }
  return o;
}

function padToken(s, decimals) {
  var o = s.toFixed(decimals);
  var l = parseInt(decimals)+12;
  while (o.length < l) {
    o = " " + o;
  }
  return o;
}


// -----------------------------------------------------------------------------
// Transaction status
// -----------------------------------------------------------------------------
function printTxData(name, txId) {
  var tx = eth.getTransaction(txId);
  var txReceipt = eth.getTransactionReceipt(txId);
  var gasPrice = tx.gasPrice;
  var gasCostETH = tx.gasPrice.mul(txReceipt.gasUsed).div(1e18);
  var gasCostUSD = gasCostETH.mul(ethPriceUSD);
  var block = eth.getBlock(txReceipt.blockNumber);
  console.log("RESULT: " + name + " status=" + txReceipt.status + (txReceipt.status == 0 ? " Failure" : " Success") + " gas=" + tx.gas +
    " gasUsed=" + txReceipt.gasUsed + " costETH=" + gasCostETH + " costUSD=" + gasCostUSD +
    " @ ETH/USD=" + ethPriceUSD + " gasPrice=" + web3.fromWei(gasPrice, "gwei") + " gwei block=" +
    txReceipt.blockNumber + " txIx=" + tx.transactionIndex + " txId=" + txId +
    " @ " + block.timestamp + " " + new Date(block.timestamp * 1000).toUTCString());
}

function assert(condition, message) {
  if (condition) {
    console.log("RESULT: PASS " + message);
  } else {
    console.log("RESULT: FAIL " + message);
  }
  return condition;
}

function assertIntEquals(result, expected, message) {
  if (parseInt(result) == parseInt(expected)) {
    console.log("RESULT: PASS " + message);
    return true;
  } else {
    console.log("RESULT: FAIL " + message);
    return false;
  }
}

function assertEtherBalance(account, expectedBalance) {
  var etherBalance = web3.fromWei(eth.getBalance(account), "ether");
  if (etherBalance == expectedBalance) {
    console.log("RESULT: OK " + account + " has expected balance " + expectedBalance);
  } else {
    console.log("RESULT: FAILURE " + account + " has balance " + etherBalance + " <> expected " + expectedBalance);
  }
}

function failIfTxStatusError(tx, msg) {
  var status = eth.getTransactionReceipt(tx).status;
  if (status == 0) {
    console.log("RESULT: FAIL " + msg);
    return 0;
  } else {
    console.log("RESULT: PASS " + msg);
    return 1;
  }
}

function passIfTxStatusError(tx, msg) {
  var status = eth.getTransactionReceipt(tx).status;
  if (status == 1) {
    console.log("RESULT: FAIL " + msg);
    return 0;
  } else {
    console.log("RESULT: PASS " + msg);
    return 1;
  }
}

function gasEqualsGasUsed(tx) {
  var gas = eth.getTransaction(tx).gas;
  var gasUsed = eth.getTransactionReceipt(tx).gasUsed;
  return (gas == gasUsed);
}

function failIfGasEqualsGasUsed(tx, msg) {
  var gas = eth.getTransaction(tx).gas;
  var gasUsed = eth.getTransactionReceipt(tx).gasUsed;
  if (gas == gasUsed) {
    console.log("RESULT: FAIL " + msg);
    return 0;
  } else {
    console.log("RESULT: PASS " + msg);
    return 1;
  }
}

function passIfGasEqualsGasUsed(tx, msg) {
  var gas = eth.getTransaction(tx).gas;
  var gasUsed = eth.getTransactionReceipt(tx).gasUsed;
  if (gas == gasUsed) {
    console.log("RESULT: PASS " + msg);
    return 1;
  } else {
    console.log("RESULT: FAIL " + msg);
    return 0;
  }
}

function failIfGasEqualsGasUsedOrContractAddressNull(contractAddress, tx, msg) {
  if (contractAddress == null) {
    console.log("RESULT: FAIL " + msg);
    return 0;
  } else {
    var gas = eth.getTransaction(tx).gas;
    var gasUsed = eth.getTransactionReceipt(tx).gasUsed;
    if (gas == gasUsed) {
      console.log("RESULT: FAIL " + msg);
      return 0;
    } else {
      console.log("RESULT: PASS " + msg);
      return 1;
    }
  }
}


//-----------------------------------------------------------------------------
//Wait until some unixTime + additional seconds
//-----------------------------------------------------------------------------
function waitUntil(message, unixTime, addSeconds) {
  var t = parseInt(unixTime) + parseInt(addSeconds) + parseInt(1);
  var time = new Date(t * 1000);
  console.log("RESULT: Waiting until '" + message + "' at " + unixTime + "+" + addSeconds + "s=" + time + " now=" + new Date());
  while ((new Date()).getTime() <= time.getTime()) {
  }
  console.log("RESULT: Waited until '" + message + "' at at " + unixTime + "+" + addSeconds + "s=" + time + " now=" + new Date());
  console.log("RESULT: ");
}


//-----------------------------------------------------------------------------
// Wait until some block
//-----------------------------------------------------------------------------
function waitUntilBlock(message, block, addBlocks) {
  var b = parseInt(block) + parseInt(addBlocks);
  console.log("RESULT: Waiting until '" + message + "' #" + block + "+" + addBlocks + "=#" + b + " currentBlock=" + eth.blockNumber);
  while (eth.blockNumber <= b) {
  }
  console.log("RESULT: Waited until '" + message + "' #" + block + "+" + addBlocks + "=#" + b + " currentBlock=" + eth.blockNumber);
  console.log("RESULT: ");
}


//-----------------------------------------------------------------------------
// Randomly shuffle an array
// https://stackoverflow.com/questions/2450954/how-to-randomize-shuffle-a-javascript-array
//-----------------------------------------------------------------------------
function shuffle(array) {
  var currentIndex = array.length, temporaryValue, randomIndex;
  // While there remain elements to shuffle...
  while (0 !== currentIndex) {
    // Pick a remaining element...
    randomIndex = Math.floor(Math.random() * currentIndex);
    currentIndex -= 1;
    // And swap it with the current element.
    temporaryValue = array[currentIndex];
    array[currentIndex] = array[randomIndex];
    array[randomIndex] = temporaryValue;
  }
  return array;
}


function printAll(tree, node, spacing) {
  var padding = "";
  for (var i = 0; i < spacing * 2; i++) {
    padding = padding + "  ";
  }
  var nodeData = tree.getNode(node);
  var leftNode = nodeData[2];
  var rightNode = nodeData[3];
  if (leftNode != 0) {
    printAll(tree, leftNode, parseInt(spacing) + 1);
  }
  if (nodeData[0] == 0) {
    console.log("RESULT: " + padding + "(empty)");
  } else {
    console.log("RESULT: " + padding + "[k" + nodeData[0] + " p" + nodeData[1] + " l" + nodeData[2] + " r" + nodeData[3]  + " " + (nodeData[4] ? "red" : "black") + "]");
  }
  if (rightNode != 0) {
    printAll(tree, rightNode, parseInt(spacing) + 1);
  }
}


function treeAsList(tree) {
  var result = [];
  treeAsListWalker(tree, tree.root(), result);
  return result.sort();
}
function treeAsListWalker(tree, node, result) {
  var nodeData = tree.getNode(node);
  var leftNode = nodeData[2];
  var rightNode = nodeData[3];
  if (leftNode != 0) {
    treeAsListWalker(tree, leftNode, result);
  }
  if (nodeData[0] != 0) {
    result.push(parseInt(nodeData[0]));
  }
  if (rightNode != 0) {
    treeAsListWalker(tree, rightNode, result);
  }
}


function listMinusItem(list, item) {
  var result = [];
  list.forEach(function(e) {
    if (e != item) {
      result.push(parseInt(e));
    }
  });
  return result.sort();
}


// -----------------------------------------------------------------------------
// TestRedBlackTree Contract
// -----------------------------------------------------------------------------
var testRedBlackTreeContractAddress = null;
var testRedBlackTreeContractAbi = null;

function addTestRedBlackTreeContractAddressAndAbi(address, testRedBlackTreeAbi) {
  testRedBlackTreeContractAddress = address;
  testRedBlackTreeContractAbi = testRedBlackTreeAbi;
}

var testRedBlackTreeFromBlock = 0;
function printTestRedBlackTreeContractDetails() {
  // console.log("RESULT: testRedBlackTreeContractAddress=" + testRedBlackTreeContractAddress);
  if (testRedBlackTreeContractAddress != null && testRedBlackTreeContractAbi != null) {
    var contract = eth.contract(testRedBlackTreeContractAbi).at(testRedBlackTreeContractAddress);
    console.log("RESULT: --------------------------------------------------------------------------------");
    console.log("RESULT: testRedBlackTree.root=" + contract.root());
    console.log("RESULT: testRedBlackTree.first=" + contract.first());
    console.log("RESULT: testRedBlackTree.last=" + contract.last());

    var latestBlock = eth.blockNumber;
    var i;

    // var logEvents = contract.Log({}, { fromBlock: testRedBlackTreeFromBlock, toBlock: latestBlock });
    // i = 0;
    // logEvents.watch(function (error, result) {
    //   console.log("RESULT: Log " + i++ + " #" + result.blockNumber + " \"" + result.args.where +
    //     "\", \"" + result.args.action + "\", " +
    //     " key=" + result.args.key + " p=" + result.args.parentKey + " l=" + result.args.leftKey +
    //     " r=" + result.args.rightKey + " " + (result.args.red ? "red" : "black"));
    // });
    // logEvents.stopWatching();

    testRedBlackTreeFromBlock = latestBlock + 1;
  }
  console.log("RESULT: --------------------------------------------------------------------------------");
  printAll(contract, contract.root(), 0);
  console.log("RESULT: --------------------------------------------------------------------------------");
  console.log("RESULT: ");
}
