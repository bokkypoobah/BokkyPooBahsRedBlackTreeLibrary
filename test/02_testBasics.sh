#!/bin/bash
# ----------------------------------------------------------------------------------------------
# Testing the smart contract
#
# Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
# ----------------------------------------------------------------------------------------------

MODE=${1:-full}

source settings
echo "---------- Settings ----------" | tee $TEST2OUTPUT
cat ./settings | tee -a $TEST2OUTPUT
echo "" | tee -a $TEST2OUTPUT

CURRENTTIME=`date +%s`
CURRENTTIMES=`date -r $CURRENTTIME -u`
START_DATE=`echo "$CURRENTTIME+60*2+30" | bc`
START_DATE_S=`date -r $START_DATE -u`
END_DATE=`echo "$CURRENTTIME+60*4" | bc`
END_DATE_S=`date -r $END_DATE -u`

printf "CURRENTTIME = '$CURRENTTIME' '$CURRENTTIMES'\n" | tee -a $TEST2OUTPUT
printf "START_DATE  = '$START_DATE' '$START_DATE_S'\n" | tee -a $TEST2OUTPUT
printf "END_DATE    = '$END_DATE' '$END_DATE_S'\n" | tee -a $TEST2OUTPUT

# Make copy of SOL file and modify start and end times ---
# `cp modifiedContracts/*.sol .`
`cp $SOURCEDIR/* .`

# --- Modify parameters ---
#`perl -pi -e "s/START_DATE \= 1512921600;.*$/START_DATE \= $START_DATE; \/\/ $START_DATE_S/" $CROWDSALESOL`
#`perl -pi -e "s/endDate \= 1513872000;.*$/endDate \= $END_DATE; \/\/ $END_DATE_S/" $CROWDSALESOL`

#DIFFS1=`diff $SOURCEDIR/$LIBSOL $LIBSOL`
#echo "--- Differences $SOURCEDIR/$LIBSOL $LIBSOL ---" | tee -a $TEST2OUTPUT
#echo "$DIFFS1" | tee -a $TEST2OUTPUT

#DIFFS1=`diff $SOURCEDIR/$TESTSOL $TESTSOL`
#echo "--- Differences $SOURCEDIR/$TESTSOL $TESTSOL ---" | tee -a $TEST2OUTPUT
#echo "$DIFFS1" | tee -a $TEST2OUTPUT

solc_0.4.25 --version | tee -a $TEST2OUTPUT

# echo "var libOutput=`solc_0.4.25 --optimize --pretty-json --combined-json abi,bin,interface $LIBSOL`;" > $LIBJS
echo "var testOutput=`solc_0.4.25 --optimize --pretty-json --combined-json abi,bin,interface $TESTSOL`;" > $TESTJS

../scripts/solidityFlattener.pl --contractsdir=../contracts --mainsol=$TESTSOL --outputsol=$TESTFLATTENED --verbose | tee -a $TEST2OUTPUT

if [ "$MODE" = "compile" ]; then
  echo "Compiling only"
  exit 1;
fi

geth --verbosity 3 attach $GETHATTACHPOINT << EOF | tee -a $TEST2OUTPUT
loadScript("$TESTJS");
loadScript("functions.js");

var testAbi = JSON.parse(testOutput.contracts["$TESTSOL:TestBokkyPooBahsRedBlackTree"].abi);
var testBin = "0x" + testOutput.contracts["$TESTSOL:TestBokkyPooBahsRedBlackTree"].bin;

// console.log("DATA: testAbi=" + JSON.stringify(testAbi));
// console.log("DATA: testBin=" + JSON.stringify(testBin));


unlockAccounts("$PASSWORD");
printBalances();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var deployTestMessage = "Deploy Test";
// -----------------------------------------------------------------------------
console.log("RESULT: ----- " + deployTestMessage + " -----");
var testContract = web3.eth.contract(testAbi);
// console.log(JSON.stringify(testContract));
var testTx = null;
var testAddress = null;
var test = testContract.new({from: deployer, data: testBin, gas: 6000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        testTx = contract.transactionHash;
      } else {
        testAddress = contract.address;
        addAccount(testAddress, "Test");
        console.log("DATA: var testAddress=\"" + testAddress + "\";");
        console.log("DATA: var testAbi=" + JSON.stringify(testAbi) + ";");
        console.log("DATA: var test=eth.contract(testAbi).at(testAddress);");
        addTestRedBlackTreeContractAddressAndAbi(testAddress, testAbi);
        console.log("DATA: testAddress=" + testAddress);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(testTx, deployTestMessage);
printTxData("testTx", testTx);
printTestRedBlackTreeContractDetails();
console.log("RESULT: ");


var failureDetected = false;
var expected;
var result;
var section;
var message;
var NULLNODERESULT = "[\"0\",\"0\",\"0\",\"0\",false,\"0\"]";

if ("$MODE" == "full") {
  section = "[Empty List]";
  console.log("RESULT: ---------- Test Basics - " + section + " ----------");
  if (!assert(test.root() == "0", section + " test.root() should return 0")) {
    failureDetected = true;
  }
  if (!assert(test.first() == "0", section + " test.first() should return 0")) {
    failureDetected = true;
  }
  if (!assert(test.last() == "0", section + " test.last() should return 0")) {
    failureDetected = true;
  }
  if (!assert(test.next(123) == "0", section + " test.next(123) should return 0")) {
    failureDetected = true;
  }
  if (!assert(test.prev(123) == "0", section + " test.prev(123) should return 0")) {
    failureDetected = true;
  }
  if (!assert(test.exists(123) == false, section + " test.exists(123) should return false")) {
    failureDetected = true;
  }

  var nodeResult = test.getNode(123);
  if (!assert(JSON.stringify(nodeResult) == NULLNODERESULT, section + " test.getNode(123) should return " + NULLNODERESULT)) {
    failureDetected = true;
  }

  if (!assert(test.parent(123) == "0", section + " test.parent(123) should return 0")) {
    failureDetected = true;
  }
  var nodeResult = test.parentNode(123);
  if (!assert(JSON.stringify(nodeResult) == NULLNODERESULT, section + " test.parentNode(123) should return " + NULLNODERESULT)) {
    failureDetected = true;
  }

  if (!assert(test.grandparent(123) == "0", section + " test.grandparent(123) should return 0")) {
    failureDetected = true;
  }
  var nodeResult = test.grandparentNode(123);
  if (!assert(JSON.stringify(nodeResult) == NULLNODERESULT, section + " test.grandparentNode(123) should return " + NULLNODERESULT)) {
    failureDetected = true;
  }

  if (!assert(test.sibling(123) == "0", section + " test.sibling(123) should return 0")) {
    failureDetected = true;
  }
  var nodeResult = test.siblingNode(123);
  if (!assert(JSON.stringify(nodeResult) == NULLNODERESULT, section + " test.siblingNode(123) should return " + NULLNODERESULT)) {
    failureDetected = true;
  }

  if (!assert(test.uncle(123) == "0", section + " test.uncle(123) should return 0")) {
    failureDetected = true;
  }
  var nodeResult = test.uncleNode(123);
  if (!assert(JSON.stringify(nodeResult) == NULLNODERESULT, section + " test.uncleNode(123) should return " + NULLNODERESULT)) {
    failureDetected = true;
  }
  // TODO: Test next, prev



  // timestamp = testDateTime.timestampFromDateTime(2100, 5, 24, 1, 2, 3);
  // if (!assert(!testDateTime.isLeapYear(timestamp), testDateTime.timestampToDateTime(timestamp) + " is a not leap year")) {
  //   failureDetected = true;
  // }
  // timestamp = testDateTime.timestampFromDateTime(2104, 5, 24, 1, 2, 3);
  // if (!assert(testDateTime.isLeapYear(timestamp), testDateTime.timestampToDateTime(timestamp) + " is a leap year")) {
  //   failureDetected = true;
  // }
  console.log("RESULT: ");
}

// -----------------------------------------------------------------------------
var insert1_Message = "Insert Record #1";
// -----------------------------------------------------------------------------
console.log("RESULT: ----- " + insert1_Message + " -----");
// var items = [1, 6, 8, 11, 13, 15, 17, 22, 25, 27];
var NUMBEROFITEMS = 100;
var BATCHSIZE = NUMBEROFITEMS / 4;
var items = [];
for (var i = 1; i <= NUMBEROFITEMS; i++) {
    items.push(i);
}
// items = shuffle(items);
// items=[11,35,22,70,57,54,49,58,33,74,46,41,68,16,10,34,31,96,43,30,98,79,55,47,77,7,72,86,89,64,83,14,38,81,100,78,12,36,62,99,84,92,60,32,53,24,97,4,87,26,93,25,56,63,5,67,51,76,59,66,69,65,48,39,18,3,45,50,8,71,95,19,28,52,82,1,20,6,75,27,9,88,23,17,42,85,44,13,80,37,94,40,2,21,15,90,61,91,73,29];
items=[11,35,22,70,57,54,49,58,33,74,46,41,68,16,10,34,31,96,43,30,98,79,55,47,77,7,72,86,89,64];
// items = [15,14,20,3,7,10,11,16,18,2,4,5,8,19,1,9,12,6,17,13];
// items = [4, 3, 1, 2, 6, 7, 5, 8, 9];
// items = [4, 3, 1, 2, 6];
// items = [4, 3, 1];
var expected = items;
console.log("RESULT: insert=" + JSON.stringify(items));
var tx = [];
for (var i = 0; i < items.length; i++) {
  var item = items[i];
  var itemValue = parseInt(item) + 10000;
  tx.push(test.insert(item, itemValue, {from: deployer, gas: 1000000, gasPrice: defaultGasPrice}));
}
while (txpool.status.pending > 0) {
}
printTestRedBlackTreeContractDetails();
// printBalances();

for (var i = 0; i < items.length; i++) {
  var item = items[i];
  failIfTxStatusError(tx[i], setup_Message + " - test.insert(" + item + ")");
}
var totalGasUsed = new BigNumber(0);
for (var i = 0; i < items.length; i++) {
  var item = items[i];
  var itemValue = parseInt(item) + 10000;
  printTxData("setup_1Tx[" + i + "]", tx[i]);
  totalGasUsed = totalGasUsed.add(eth.getTransactionReceipt(tx[i]).gasUsed);
}
var averageGasUsed = totalGasUsed.div(items.length);
console.log("RESULT: totalGasUsedInsert=" + totalGasUsed);
console.log("RESULT: averageGasUsedInsert=" + averageGasUsed);
console.log("RESULT: ");

printTestRedBlackTreeContractDetails();
console.log("RESULT: ");
}


if (!failureDetected) {
  console.log("RESULT: ---------- PASS - no failures detected ----------");
} else {
  console.log("RESULT: ---------- FAIL - some failures detected ----------");
}


exit;

// -----------------------------------------------------------------------------
var test2A_Message = "Test 2A - Empty List";
// -----------------------------------------------------------------------------
console.log("RESULT: ----- " + test2A_Message + " -----");




// -----------------------------------------------------------------------------
var setup_Message = "Setup";
// -----------------------------------------------------------------------------
console.log("RESULT: ----- " + setup_Message + " -----");
// var items = [1, 6, 8, 11, 13, 15, 17, 22, 25, 27];
var NUMBEROFITEMS = 100;
var BATCHSIZE = NUMBEROFITEMS / 4;
var items = [];
for (var i = 1; i <= NUMBEROFITEMS; i++) {
    items.push(i);
}
// items = shuffle(items);
items=[11,35,22,70,57,54,49,58,33,74,46,41,68,16,10,34,31,96,43,30,98,79,55,47,77,7,72,86,89,64,83,14,38,81,100,78,12,36,62,99,84,92,60,32,53,24,97,4,87,26,93,25,56,63,5,67,51,76,59,66,69,65,48,39,18,3,45,50,8,71,95,19,28,52,82,1,20,6,75,27,9,88,23,17,42,85,44,13,80,37,94,40,2,21,15,90,61,91,73,29];
// items = [15,14,20,3,7,10,11,16,18,2,4,5,8,19,1,9,12,6,17,13];
// items = [4, 3, 1, 2, 6, 7, 5, 8, 9];
// items = [4, 3, 1, 2, 6];
// items = [4, 3, 1];
var expected = items;
console.log("RESULT: insert=" + JSON.stringify(items));
var tx = [];
for (var i = 0; i < items.length; i++) {
  var item = items[i];
  var itemValue = parseInt(item) + 10000;
  tx.push(test.insert(item, itemValue, {from: deployer, gas: 1000000, gasPrice: defaultGasPrice}));
}
while (txpool.status.pending > 0) {
}
printTestRedBlackTreeContractDetails();
// printBalances();

for (var i = 0; i < items.length; i++) {
  var item = items[i];
  failIfTxStatusError(tx[i], setup_Message + " - test.insert(" + item + ")");
}
var totalGasUsed = new BigNumber(0);
for (var i = 0; i < items.length; i++) {
  var item = items[i];
  var itemValue = parseInt(item) + 10000;
  printTxData("setup_1Tx[" + i + "]", tx[i]);
  totalGasUsed = totalGasUsed.add(eth.getTransactionReceipt(tx[i]).gasUsed);
}
var averageGasUsed = totalGasUsed.div(items.length);
console.log("RESULT: totalGasUsedInsert=" + totalGasUsed);
console.log("RESULT: averageGasUsedInsert=" + averageGasUsed);
console.log("RESULT: ");

printTestRedBlackTreeContractDetails();
console.log("RESULT: ");


items = shuffle(items);
items=[97,1,26,99,32,56,21,83,42,88,49,8,69,9,78,18,20,17,39,87,25,7,5,91,73,15,52,80,96,61,16,29,55,76,48,37,44,14,98,31,34,85,28,4,72,27,13,43,62,38,40,92,24,60,41,50,22,45,57,70,2,82,75,81,35,74,58,59,10,36,100,68,23,67,11,86,77,90,12,93,54,47,79,63,51,6,33,84,94,19,65,46,30,3,71,95,89,64,53,66];
// items = [15,14,20,3,7,10,11,16,18,2,4,5,8,19,1,9,12,6,17,13];
// items = [4, 3, 1, 2, 6, 7, 5, 8, 9];
// items = [4, 3, 1, 2, 6];
// items = [4, 3, 1];
// items = [4, 3];
console.log("RESULT: remove=" + JSON.stringify(items));
var tx = [];
for (var i = 0; i < items.length; i++) {
  var item = items[i];
  console.log("RESULT: removing " + item);
  tx.push(test.remove(item, {from: deployer, gas: 1000000, gasPrice: defaultGasPrice}));
  expected = listMinusItem(expected, item);
  if ((i + 1) % BATCHSIZE == 0) {
    while (txpool.status.pending > 0) {
    }
    console.log("RESULT: expected=" + JSON.stringify(expected));
    var result = treeAsList(test);
    console.log("RESULT: result=" + JSON.stringify(result));
    if (JSON.stringify(expected) == JSON.stringify(result)) {
      console.log("RESULT: comparison OK");
    } else {
      console.log("RESULT: comparison ERROR !!!!!!!!!!!!!!");
    }
    printTestRedBlackTreeContractDetails();
  }
}

for (var i = 0; i < items.length; i++) {
  var item = items[i];
  failIfTxStatusError(tx[i], setup_Message + " - test.remove(" + item + ")");
}
var totalGasUsed = new BigNumber(0);
for (var i = 0; i < items.length; i++) {
  var item = items[i];
  var itemValue = parseInt(item) + 10000;
  printTxData("setup_1Tx[" + i + "]", tx[i]);
  totalGasUsed = totalGasUsed.add(eth.getTransactionReceipt(tx[i]).gasUsed);
}
var averageGasUsed = totalGasUsed.div(items.length);
console.log("RESULT: totalGasUsedRemove=" + totalGasUsed);
console.log("RESULT: averageGasUsedRemove=" + averageGasUsed);
console.log("RESULT: ");

exit;


if (false) {
for (var i = 0; i < items.length; i++) {
  var item = items[i];
  // var itemValue = parseInt(item) + 10000;
  // var find1_id = testRbt.find(itemValue);
  // console.log("RESULT: find1_id(" + itemValue + ")=" + find1_id);
  var find1_item = testRbt.getItem(item);
  console.log("RESULT: find1_item(" + item + ")=" + JSON.stringify(find1_item));
}
console.log("RESULT: ");
}

if (false) {
items.push(123);
items.push(123000);
for (var i = 0; i < items.length; i++) {
  var item = items[i];
  var itemValue = parseInt(item) + 10000;
  var find1_id = testRbt.find(itemValue);
  console.log("RESULT: find1_id(" + itemValue + ")=" + find1_id);
  var find1_item = testRbt.getItem(find1_id);
  console.log("RESULT: find1_item=" + JSON.stringify(find1_item));
}
}
// var find1_id = testRbt.find(10008);
// console.log("RESULT: find1_id(10008)=" + find1_id);
// var find1_item = testRbt.getItem(find1_id);
// console.log("RESULT: find1_item=" + JSON.stringify(find1_item));

printTestRedBlackTreeContractDetails();

var items = [];
for (var i = 3; i <= 4; i++) {
    items.push(i);
}
// items = shuffle(items);
console.log("RESULT: remove=" + JSON.stringify(items));
var tx = [];
for (var i = 0; i < items.length; i++) {
  var item = items[i];
  var itemValue = parseInt(item) + 10000;
  tx.push(testRbt.remove(item, {from: deployer, gas: 500000, gasPrice: defaultGasPrice}));
  while (txpool.status.pending > 0) {
  }
  printTestRedBlackTreeContractDetails();
}
printBalances();

for (var i = 0; i < items.length; i++) {
  var item = items[i];
  var itemValue = parseInt(item) + 10000;
  failIfTxStatusError(tx[i], setup_Message + " - testRbt.remove(" + item + ", " + itemValue + ")");
}
var totalGasUsed = new BigNumber(0);
for (var i = 0; i < items.length; i++) {
  var item = items[i];
  var itemValue = parseInt(item) + 10000;
  printTxData("setup_1Tx[" + i + "]", tx[i]);
  totalGasUsed = totalGasUsed.add(eth.getTransactionReceipt(tx[i]).gasUsed);
}
var averageGasUsed = totalGasUsed.div(items.length);
console.log("RESULT: totalGasUsedRemove=" + totalGasUsed);
console.log("RESULT: averageGasUsedRemove=" + averageGasUsed);

console.log("RESULT: ");

printTestRedBlackTreeContractDetails();


EOF
grep "DATA: " $TEST2OUTPUT | sed "s/DATA: //" > $DEPLOYMENTDATA
cat $DEPLOYMENTDATA
grep "RESULT: " $TEST2OUTPUT | sed "s/RESULT: //" > $TEST2RESULTS
cat $TEST2RESULTS
grep average $TEST2RESULTS
