#!/bin/bash
# ----------------------------------------------------------------------------------------------
# Testing the smart contract
#
# Enjoy. (c) BokkyPooBah / Bok Consulting Pty Ltd 2017. The MIT Licence.
# ----------------------------------------------------------------------------------------------

MODE=${1:-full}

source settings
echo "---------- Settings ----------" | tee $TEST1OUTPUT
cat ./settings | tee -a $TEST1OUTPUT
echo "" | tee -a $TEST1OUTPUT

CURRENTTIME=`date +%s`
CURRENTTIMES=`date -r $CURRENTTIME -u`
START_DATE=`echo "$CURRENTTIME+60*2+30" | bc`
START_DATE_S=`date -r $START_DATE -u`
END_DATE=`echo "$CURRENTTIME+60*4" | bc`
END_DATE_S=`date -r $END_DATE -u`

printf "CURRENTTIME = '$CURRENTTIME' '$CURRENTTIMES'\n" | tee -a $TEST1OUTPUT
printf "START_DATE  = '$START_DATE' '$START_DATE_S'\n" | tee -a $TEST1OUTPUT
printf "END_DATE    = '$END_DATE' '$END_DATE_S'\n" | tee -a $TEST1OUTPUT

# Make copy of SOL file and modify start and end times ---
# `cp modifiedContracts/*.sol .`
`cp $SOURCEDIR/* .`

# --- Modify parameters ---
#`perl -pi -e "s/START_DATE \= 1512921600;.*$/START_DATE \= $START_DATE; \/\/ $START_DATE_S/" $CROWDSALESOL`
#`perl -pi -e "s/endDate \= 1513872000;.*$/endDate \= $END_DATE; \/\/ $END_DATE_S/" $CROWDSALESOL`

#DIFFS1=`diff $SOURCEDIR/$LIBSOL $LIBSOL`
#echo "--- Differences $SOURCEDIR/$LIBSOL $LIBSOL ---" | tee -a $TEST1OUTPUT
#echo "$DIFFS1" | tee -a $TEST1OUTPUT

#DIFFS1=`diff $SOURCEDIR/$TESTSOL $TESTSOL`
#echo "--- Differences $SOURCEDIR/$TESTSOL $TESTSOL ---" | tee -a $TEST1OUTPUT
#echo "$DIFFS1" | tee -a $TEST1OUTPUT

solc_0.6.0 --version | tee -a $TEST1OUTPUT

echo "var testRawOutput=`solc_0.6.0 --optimize --pretty-json --combined-json abi,bin,interface $TESTRAWSOL`;" > $TESTRAWJS
# echo "var testRawOutput=`solc_0.5.4 --optimize --pretty-json --combined-json abi,bin,interface $LIBSOL`;" > $LIBJS

../scripts/solidityFlattener.pl --contractsdir=../contracts --mainsol=$TESTRAWSOL --outputsol=$TESTRAWFLATTENED --verbose | tee -a $TEST1OUTPUT

if [ "$MODE" = "compile" ]; then
  echo "Compiling only"
  exit 1;
fi

geth --verbosity 3 attach $GETHATTACHPOINT << EOF | tee -a $TEST1OUTPUT
loadScript("$TESTRAWJS");
loadScript("functions.js");

var testRawAbi = JSON.parse(testRawOutput.contracts["$TESTRAWSOL:TestBokkyPooBahsRedBlackTreeRaw"].abi);
var testRawBin = "0x" + testRawOutput.contracts["$TESTRAWSOL:TestBokkyPooBahsRedBlackTreeRaw"].bin;

// console.log("DATA: testRawAbi=" + JSON.stringify(testRawAbi));
// console.log("DATA: testRawBin=" + JSON.stringify(testRawBin));


unlockAccounts("$PASSWORD");
printBalances();
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var deployTestMessage = "Deploy Test";
// -----------------------------------------------------------------------------
console.log("RESULT: ----- " + deployTestMessage + " -----");
var testRawContract = web3.eth.contract(testRawAbi);
// console.log(JSON.stringify(testRawContract));
var testRawTx = null;
var testRawAddress = null;
var testRaw = testRawContract.new({from: deployer, data: testRawBin, gas: 6000000, gasPrice: defaultGasPrice},
  function(e, contract) {
    if (!e) {
      if (!contract.address) {
        testRawTx = contract.transactionHash;
      } else {
        testRawAddress = contract.address;
        addAccount(testRawAddress, "TestRaw");
        console.log("DATA: var testRawAddress=\"" + testRawAddress + "\";");
        console.log("DATA: var testRawAbi=" + JSON.stringify(testRawAbi) + ";");
        console.log("DATA: var testRaw=eth.contract(testRawAbi).at(testRawAddress);");
        addTestRedBlackTreeContractAddressAndAbi(testRawAddress, testRawAbi);
        console.log("DATA: testRawAddress=" + testRawAddress);
      }
    }
  }
);
while (txpool.status.pending > 0) {
}
printBalances();
failIfTxStatusError(testRawTx, deployTestMessage);
printTxData("testRawTx", testRawTx);
printTestRedBlackTreeContractDetails();
console.log("RESULT: ");

var failureDetected = false;
var expected;
var result;
var section;
var message;
var NULLNODERESULT = "[\"0\",\"0\",\"0\",\"0\",false]";

if ("$MODE" == "full") {
  section = "[Empty List]";
  console.log("RESULT: ---------- Test Basics - " + section + " ----------");
  if (!assert(testRaw.root.call() == "0", section + " testRaw.root() should return 0")) {
    failureDetected = true;
  }
  if (!assert(testRaw.first.call() == "0", section + " testRaw.first() should return 0")) {
    failureDetected = true;
  }
  if (!assert(testRaw.last.call() == "0", section + " testRaw.last() should return 0")) {
    failureDetected = true;
  }
  if (!assert(testRaw.next.call(0) == "0", section + " testRaw.next(0) should return 0")) {
    failureDetected = true;
  }
  if (!assert(testRaw.next.call(123) == "0", section + " testRaw.next(123) should return 0")) {
    failureDetected = true;
  }
  if (!assert(testRaw.prev.call(0) == "0", section + " testRaw.prev(0) should return 0")) {
    failureDetected = true;
  }
  if (!assert(testRaw.prev.call(123) == "0", section + " testRaw.prev(123) should return 0")) {
    failureDetected = true;
  }
  if (!assert(testRaw.exists.call(123) == false, section + " testRaw.exists(123) should return false")) {
    failureDetected = true;
  }

  var nodeResult = testRaw.getNode.call(123);
  // console.log("RESULT: nodeResult=" + nodeResult);
  if (!assert(JSON.stringify(nodeResult) == NULLNODERESULT, section + " testRaw.getNode(123) should return " + NULLNODERESULT)) {
    failureDetected = true;
  }

  console.log("RESULT: ");
}


// -----------------------------------------------------------------------------
var setupData1_Message = "Setup Data";
// -----------------------------------------------------------------------------
console.log("RESULT: ----- " + setupData1_Message + " -----");
// var NUMBEROFITEMS = 32;
var NUMBEROFITEMS = 32;
var BATCHSIZE = NUMBEROFITEMS / 4;
var insertItems = [];
var removeItems = [];
for (var i = 1; i <= NUMBEROFITEMS; i++) {
    insertItems.push(i);
    removeItems.push(i);
}
// insertItems = shuffle(insertItems);
insertItems=[18,28,17,32,7,5,21,14,10,3,23,16,24,4,29,8,26,12,2,22,11,1,31,19,30,9,13,15,6,20,25,27];
// TEST next, prev insertItems=[20,22,4,8,12,10,14];
// insertItems=[20,22,4,8,12,10,14];
// removeItems = shuffle(removeItems);
removeItems=[4,14,25,32,2,30,16,31,6,26,18,22,28,23,12,15,19,27,7,13,29,11,3,5,17,1,24,20,9,8,21,10];
// console.log("RESULT: insertItems=" + JSON.stringify(insertItems));
// console.log("RESULT: removeItems=" + JSON.stringify(removeItems));
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var insertData1_Message = "Insert Data #1";
// -----------------------------------------------------------------------------
console.log("RESULT: ----- " + insertData1_Message + " -----");
console.log("RESULT: insertItems(First Item)=" + JSON.stringify(insertItems));
var tx = [];
for (var i = 0; i < 1; i++) {
  var item = insertItems[i];
  var itemValue = parseInt(item) + 10000;
  tx.push(testRaw.insert(item, {from: deployer, gas: 1000000, gasPrice: defaultGasPrice}));
}
while (txpool.status.pending > 0) {
}
printTestRedBlackTreeContractDetails();
// printBalances();

for (var i = 0; i < tx.length; i++) {
  var item = insertItems[i];
  failIfTxStatusError(tx[i], insertData1_Message + " - testRaw.insert(" + item + ")");
}
var minGasUsedInsert = new BigNumber(0);
var maxGasUsedInsert = new BigNumber(0);
var totalGasUsedInsert = new BigNumber(0);
for (var i = 0; i < tx.length; i++) {
  var item = insertItems[i];
  var itemValue = parseInt(item) + 10000;
  printTxData("setup_1Tx[" + i + "]", tx[i]);
  var gasUsed = eth.getTransactionReceipt(tx[i]).gasUsed;
  if (i == 0) {
    minGasUsedInsert = gasUsed;
    maxGasUsedInsert = gasUsed;
  } else {
    if (gasUsed < minGasUsedInsert) {
      minGasUsedInsert = gasUsed;
    }
    if (gasUsed > maxGasUsedInsert) {
      maxGasUsedInsert = gasUsed;
    }
  }
  totalGasUsedInsert = totalGasUsedInsert.add(eth.getTransactionReceipt(tx[i]).gasUsed);
}
// var averageGasUsedInsert = totalGasUsedInsert.div(tx.length);
// console.log("RESULT: totalGasUsedInsert=" + totalGasUsedInsert);
// console.log("RESULT: minGasUsedInsert=" + minGasUsedInsert);
// console.log("RESULT: averageGasUsedInsert=" + averageGasUsedInsert);
// console.log("RESULT: maxGasUsedInsert=" + maxGasUsedInsert);
console.log("RESULT: ");

printTestRedBlackTreeContractDetails();
console.log("RESULT: ");


if ("$MODE" == "full") {
  section = "[Single Item]";
  console.log("RESULT: ---------- Test Basics - " + section + " ----------");
  if (!assert(testRaw.root.call() == "18", section + " testRaw.root() should return 18")) {
    failureDetected = true;
  }
  if (!assert(testRaw.first.call() == "18", section + " testRaw.first() should return 18")) {
    failureDetected = true;
  }
  if (!assert(testRaw.last.call() == "18", section + " testRaw.last() should return 18")) {
    failureDetected = true;
  }
  if (!assert(testRaw.next.call(0) == "0", section + " testRaw.next(0) should return 0")) {
    failureDetected = true;
  }
  if (!assert(testRaw.next.call(18) == "0", section + " testRaw.next(18) should return 0")) {
    failureDetected = true;
  }
  if (!assert(testRaw.prev.call(0) == "0", section + " testRaw.prev(0) should return 0")) {
    failureDetected = true;
  }
  if (!assert(testRaw.prev.call(18) == "0", section + " testRaw.prev(18) should return 0")) {
    failureDetected = true;
  }
  if (!assert(testRaw.exists.call(18) == true, section + " testRaw.exists(18) should return true")) {
    failureDetected = true;
  }

  var NODE18ONLYRESULT = "[\"18\",\"0\",\"0\",\"0\",false]";
  var nodeResult = testRaw.getNode.call(18);
  if (!assert(JSON.stringify(nodeResult) == NODE18ONLYRESULT, section + " testRaw.getNode(18) should return " + NODE18ONLYRESULT)) {
    failureDetected = true;
  }
  console.log("RESULT: ");
}


// -----------------------------------------------------------------------------
var insertData2_Message = "Insert Data #2";
// -----------------------------------------------------------------------------
console.log("RESULT: ----- " + insertData2_Message + " -----");
console.log("RESULT: insertItems(Second Item)=" + JSON.stringify(insertItems));
for (var i = 1; i < 2; i++) {
  var item = insertItems[i];
  var itemValue = parseInt(item) + 10000;
  tx.push(testRaw.insert(item, {from: deployer, gas: 1000000, gasPrice: defaultGasPrice}));
}
while (txpool.status.pending > 0) {
}
printTestRedBlackTreeContractDetails();
// printBalances();

for (var i = 1; i < tx.length; i++) {
  var item = insertItems[i];
  failIfTxStatusError(tx[i], insertData2_Message + " - testRaw.insert(" + item + ")");
}
for (var i = 1; i < tx.length; i++) {
  var item = insertItems[i];
  var itemValue = parseInt(item) + 10000;
  printTxData("setup_1Tx[" + i + "]", tx[i]);
  var gasUsed = eth.getTransactionReceipt(tx[i]).gasUsed;
  if (i == 0) {
    minGasUsedInsert = gasUsed;
    maxGasUsedInsert = gasUsed;
  } else {
    if (gasUsed < minGasUsedInsert) {
      minGasUsedInsert = gasUsed;
    }
    if (gasUsed > maxGasUsedInsert) {
      maxGasUsedInsert = gasUsed;
    }
  }
  totalGasUsedInsert = totalGasUsedInsert.add(eth.getTransactionReceipt(tx[i]).gasUsed);
}
// var averageGasUsedInsert = totalGasUsedInsert.div(tx.length);
// console.log("RESULT: totalGasUsedInsert=" + totalGasUsedInsert);
// console.log("RESULT: minGasUsedInsert=" + minGasUsedInsert);
// console.log("RESULT: averageGasUsedInsert=" + averageGasUsedInsert);
// console.log("RESULT: maxGasUsedInsert=" + maxGasUsedInsert);
console.log("RESULT: ");

printTestRedBlackTreeContractDetails();
console.log("RESULT: ");


if ("$MODE" == "full") {
  section = "[Two Items]";
  console.log("RESULT: ---------- Test Basics - " + section + " ----------");
  if (!assert(testRaw.root.call() == "18", section + " testRaw.root() should return 18")) {
    failureDetected = true;
  }
  if (!assert(testRaw.first.call() == "18", section + " testRaw.first() should return 18")) {
    failureDetected = true;
  }
  if (!assert(testRaw.last.call() == "28", section + " testRaw.last() should return 28")) {
    failureDetected = true;
  }
  if (!assert(testRaw.next.call(12) == "0", section + " testRaw.next(12) should return 0")) {
    failureDetected = true;
  }
  if (!assert(testRaw.next.call(18) == "28", section + " testRaw.next(18) should return 28")) {
    failureDetected = true;
  }
  if (!assert(testRaw.next.call(28) == "0", section + " testRaw.next(28) should return 0")) {
    failureDetected = true;
  }
  if (!assert(testRaw.prev.call(18) == "0", section + " testRaw.prev(18) should return 0")) {
    failureDetected = true;
  }
  if (!assert(testRaw.prev.call(28) == "18", section + " testRaw.prev(28) should return 18")) {
    failureDetected = true;
  }
  if (!assert(testRaw.exists.call(18) == true, section + " testRaw.exists(18) should return true")) {
    failureDetected = true;
  }

  var NODE1828RESULT = "[\"18\",\"0\",\"0\",\"28\",false]";
  var nodeResult = testRaw.getNode.call(18);
  if (!assert(JSON.stringify(nodeResult) == NODE1828RESULT, section + " testRaw.getNode(18) should return " + NODE1828RESULT)) {
    failureDetected = true;
  }
  console.log("RESULT: ");
}


// -----------------------------------------------------------------------------
var insertData3_Message = "Insert Data #3";
// -----------------------------------------------------------------------------
console.log("RESULT: ----- " + insertData3_Message + " -----");
console.log("RESULT: insertItems(Third Item)=" + JSON.stringify(insertItems));
for (var i = 2; i < 3; i++) {
  var item = insertItems[i];
  var itemValue = parseInt(item) + 10000;
  tx.push(testRaw.insert(item, {from: deployer, gas: 1000000, gasPrice: defaultGasPrice}));
}
while (txpool.status.pending > 0) {
}
printTestRedBlackTreeContractDetails();
// printBalances();

for (var i = 2; i < tx.length; i++) {
  var item = insertItems[i];
  failIfTxStatusError(tx[i], insertData3_Message + " - testRaw.insert(" + item + ")");
}
for (var i = 2; i < tx.length; i++) {
  var item = insertItems[i];
  var itemValue = parseInt(item) + 10000;
  printTxData("setup_1Tx[" + i + "]", tx[i]);
  var gasUsed = eth.getTransactionReceipt(tx[i]).gasUsed;
  if (i == 0) {
    minGasUsedInsert = gasUsed;
    maxGasUsedInsert = gasUsed;
  } else {
    if (gasUsed < minGasUsedInsert) {
      minGasUsedInsert = gasUsed;
    }
    if (gasUsed > maxGasUsedInsert) {
      maxGasUsedInsert = gasUsed;
    }
  }
  totalGasUsedInsert = totalGasUsedInsert.add(eth.getTransactionReceipt(tx[i]).gasUsed);
}
// var averageGasUsedInsert = totalGasUsedInsert.div(tx.length);
// console.log("RESULT: totalGasUsedInsert=" + totalGasUsedInsert);
// console.log("RESULT: minGasUsedInsert=" + minGasUsedInsert);
// console.log("RESULT: averageGasUsedInsert=" + averageGasUsedInsert);
// console.log("RESULT: maxGasUsedInsert=" + maxGasUsedInsert);
console.log("RESULT: ");

printTestRedBlackTreeContractDetails();
console.log("RESULT: ");


if ("$MODE" == "full") {
  section = "[Three Items]";
  console.log("RESULT: ---------- Test Basics - " + section + " ----------");
  if (!assert(testRaw.root.call() == "18", section + " testRaw.root() should return 18")) {
    failureDetected = true;
  }
  if (!assert(testRaw.first.call() == "17", section + " testRaw.first() should return 17")) {
    failureDetected = true;
  }
  if (!assert(testRaw.last.call() == "28", section + " testRaw.last() should return 28")) {
    failureDetected = true;
  }
  if (!assert(testRaw.next.call(12) == "0", section + " testRaw.next(12) should return 0")) {
    failureDetected = true;
  }
  if (!assert(testRaw.next.call(17) == "18", section + " testRaw.next(17) should return 18")) {
    failureDetected = true;
  }
  if (!assert(testRaw.next.call(18) == "28", section + " testRaw.next(18) should return 28")) {
    failureDetected = true;
  }
  if (!assert(testRaw.prev.call(18) == "17", section + " testRaw.prev(18) should return 17")) {
    failureDetected = true;
  }
  if (!assert(testRaw.prev.call(28) == "18", section + " testRaw.prev(28) should return 18")) {
    failureDetected = true;
  }
  if (!assert(testRaw.exists.call(18) == true, section + " testRaw.exists(18) should return true")) {
    failureDetected = true;
  }

  var NODE181728RESULT = "[\"18\",\"0\",\"17\",\"28\",false]";
  var nodeResult = testRaw.getNode.call(18);
  if (!assert(JSON.stringify(nodeResult) == NODE181728RESULT, section + " testRaw.getNode(18) should return " + NODE181728RESULT)) {
    failureDetected = true;
  }
  console.log("RESULT: ");
}


// -----------------------------------------------------------------------------
var insertData4_Message = "Insert Data #4";
// -----------------------------------------------------------------------------
console.log("RESULT: ----- " + insertData4_Message + " -----");
console.log("RESULT: insertItems(Remaining 29 Items)=" + JSON.stringify(insertItems));
for (var i = 3; i < insertItems.length; i++) {
  var item = insertItems[i];
  var itemValue = parseInt(item) + 10000;
  tx.push(testRaw.insert(item, {from: deployer, gas: 1000000, gasPrice: defaultGasPrice}));
}
while (txpool.status.pending > 0) {
}
printTestRedBlackTreeContractDetails();
// printBalances();

for (var i = 3; i < tx.length; i++) {
  var item = insertItems[i];
  failIfTxStatusError(tx[i], insertData4_Message + " - testRaw.insert(" + item + ")");
}
for (var i = 3; i < tx.length; i++) {
  var item = insertItems[i];
  var itemValue = parseInt(item) + 10000;
  printTxData("setup_1Tx[" + i + "]", tx[i]);
  var gasUsed = eth.getTransactionReceipt(tx[i]).gasUsed;
  if (i == 0) {
    minGasUsedInsert = gasUsed;
    maxGasUsedInsert = gasUsed;
  } else {
    if (gasUsed < minGasUsedInsert) {
      minGasUsedInsert = gasUsed;
    }
    if (gasUsed > maxGasUsedInsert) {
      maxGasUsedInsert = gasUsed;
    }
  }
  totalGasUsedInsert = totalGasUsedInsert.add(eth.getTransactionReceipt(tx[i]).gasUsed);
}
var averageGasUsedInsert = totalGasUsedInsert.div(tx.length);
// console.log("RESULT: totalGasUsedInsert=" + totalGasUsedInsert);
console.log("RESULT: minGasUsedInsert=" + minGasUsedInsert);
console.log("RESULT: averageGasUsedInsert=" + averageGasUsedInsert);
console.log("RESULT: maxGasUsedInsert=" + maxGasUsedInsert);
console.log("RESULT: ");

printTestRedBlackTreeContractDetails();
console.log("RESULT: ");


if ("$MODE" == "full") {
  section = "[All 32 Items]";
  console.log("RESULT: ---------- Test Basics - " + section + " ----------");
  if (!assert(testRaw.root.call() == "18", section + " testRaw.root() should return 18")) {
    failureDetected = true;
  }
  if (!assert(testRaw.first.call() == "1", section + " testRaw.first() should return 1")) {
    failureDetected = true;
  }
  if (!assert(testRaw.last.call() == "32", section + " testRaw.last() should return 32")) {
    failureDetected = true;
  }
  if (!assert(testRaw.next.call(8) == "9", section + " testRaw.next(8) should return 9")) {
    failureDetected = true;
  }
  if (!assert(testRaw.next.call(10) == "11", section + " testRaw.next(10) should return 11")) {
    failureDetected = true;
  }
  if (!assert(testRaw.next.call(14) == "15", section + " testRaw.next(14) should return 15")) {
    failureDetected = true;
  }
  if (!assert(testRaw.next.call(17) == "18", section + " testRaw.next(17) should return 18")) {
    failureDetected = true;
  }
  if (!assert(testRaw.next.call(18) == "19", section + " testRaw.next(18) should return 19")) {
    failureDetected = true;
  }
  if (!assert(testRaw.next.call(20) == "21", section + " testRaw.next(20) should return 21")) {
    failureDetected = true;
  }

  if (!assert(testRaw.prev.call(18) == "17", section + " testRaw.prev(18) should return 17")) {
    failureDetected = true;
  }
  if (!assert(testRaw.exists.call(18) == true, section + " testRaw.exists(18) should return true")) {
    failureDetected = true;
  }

  var NODE18728RESULT = "[\"18\",\"0\",\"7\",\"28\",false]";
  var nodeResult = testRaw.getNode.call(18);
  if (!assert(JSON.stringify(nodeResult) == NODE18728RESULT, section + " testRaw.getNode(18) should return " + NODE18728RESULT)) {
    failureDetected = true;
  }
  console.log("RESULT: ");
}


// -----------------------------------------------------------------------------
var insertData5_Message = "Insert Data #5 - Cannot Insert Duplicate";
// -----------------------------------------------------------------------------
console.log("RESULT: ----- " + insertData5_Message + " -----");
console.log("RESULT: insertData5_Message=" + JSON.stringify(insertItems));
var insertData5_tx = testRaw.insert(14, {from: deployer, gas: 1000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printTestRedBlackTreeContractDetails();
// printBalances();
passIfTxStatusError(insertData5_tx, insertData5_Message + " - testRaw.insert(14)");
printTxData("insertData5_tx", insertData5_tx);
console.log("RESULT: ");


// -----------------------------------------------------------------------------
var removeData1_Message = "Remove Data #1 - Cannot Remove Non-Existent Key";
// -----------------------------------------------------------------------------
console.log("RESULT: ----- " + removeData1_Message + " -----");
var removeData1_tx = testRaw.remove(114, {from: deployer, gas: 1000000, gasPrice: defaultGasPrice});
while (txpool.status.pending > 0) {
}
printTestRedBlackTreeContractDetails();
// printBalances();
passIfTxStatusError(removeData1_tx, removeData1_Message + " - testRaw.remove(114)");
printTxData("removeData1_tx", removeData1_tx);
console.log("RESULT: ");


// printTestRedBlackTreeContractDetails();
// console.log("RESULT: ");


// -----------------------------------------------------------------------------
var removeData2_Message = "Remove Data #2";
// -----------------------------------------------------------------------------
console.log("RESULT: ----- " + removeData2_Message + " -----");
// items = shuffle(items);
expected = removeItems;
console.log("RESULT: removeItems=" + JSON.stringify(removeItems));
var tx = [];
for (var i = 0; i < removeItems.length; i++) {
  var item = removeItems[i];
  console.log("RESULT: removing " + item);
  tx.push(testRaw.remove(item, {from: deployer, gas: 1000000, gasPrice: defaultGasPrice}));
  expected = listMinusItem(expected, item);
  if ((i + 1) % BATCHSIZE == 0) {
    while (txpool.status.pending > 0) {
    }
    console.log("RESULT: expected=" + JSON.stringify(expected));
    var result = treeAsList(testRaw);
    console.log("RESULT: result=" + JSON.stringify(result));
    if (JSON.stringify(expected) == JSON.stringify(result)) {
      console.log("RESULT: comparison OK");
    } else {
      console.log("RESULT: comparison ERROR !!!!!!!!!!!!!!");
      failureDetected = true;
    }
    printTestRedBlackTreeContractDetails();
  }
}

for (var i = 0; i < removeItems.length; i++) {
  var item = removeItems[i];
  failIfTxStatusError(tx[i], removeData2_Message + " - testRaw.remove(" + item + ")");
}
var minGasUsedRemove = new BigNumber(0);
var maxGasUsedRemove = new BigNumber(0);
var totalGasUsedRemove = new BigNumber(0);
for (var i = 0; i < removeItems.length; i++) {
  var item = removeItems[i];
  var itemValue = parseInt(item) + 10000;
  printTxData("tx[" + i + "]", tx[i]);
  var gasUsed = eth.getTransactionReceipt(tx[i]).gasUsed;
  if (i == 0) {
    minGasUsedRemove = gasUsed;
    maxGasUsedRemove = gasUsed;
  } else {
    if (gasUsed < minGasUsedRemove) {
      minGasUsedRemove = gasUsed;
    }
    if (gasUsed > maxGasUsedRemove) {
      maxGasUsedRemove = gasUsed;
    }
  }
  totalGasUsedRemove = totalGasUsedRemove.add(gasUsed);
}
var averageGasUsedRemove = totalGasUsedRemove.div(removeItems.length);
// console.log("RESULT: totalGasUsedRemove=" + totalGasUsedRemove);
console.log("RESULT: minGasUsedRemove=" + minGasUsedRemove);
console.log("RESULT: averageGasUsedRemove=" + averageGasUsedRemove);
console.log("RESULT: maxGasUsedRemove=" + maxGasUsedRemove);
console.log("RESULT: ");


if (!failureDetected) {
  console.log("RESULT: ---------- PASS - no failures detected ----------");
} else {
  console.log("RESULT: ---------- FAIL - some failures detected ----------");
}

EOF
grep "DATA: " $TEST1OUTPUT | sed "s/DATA: //" > $DEPLOYMENTDATA
cat $DEPLOYMENTDATA
grep "RESULT: " $TEST1OUTPUT | sed "s/RESULT: //" > $TEST1RESULTS
cat $TEST1RESULTS
grep GasUsed $TEST1RESULTS
