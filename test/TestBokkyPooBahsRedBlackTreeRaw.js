var testRawOutput={
  "contracts" : 
  {
    "BokkyPooBahsRedBlackTreeLibrary.sol:BokkyPooBahsRedBlackTreeLibrary" : 
    {
      "abi" : "[{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"name\":\"where\",\"type\":\"string\"},{\"indexed\":false,\"name\":\"action\",\"type\":\"string\"},{\"indexed\":false,\"name\":\"key\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"parent\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"left\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"right\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"red\",\"type\":\"bool\"}],\"name\":\"Log\",\"type\":\"event\"}]",
      "bin" : "604c602c600b82828239805160001a60731460008114601c57601e565bfe5b5030600052607381538281f3fe73000000000000000000000000000000000000000030146080604052600080fdfea165627a7a72305820a0e3bec200290dfdd49c7577092653b6aa651fa1c7eb419fd2d67872dba835a30029"
    },
    "TestBokkyPooBahsRedBlackTreeRaw.sol:TestBokkyPooBahsRedBlackTreeRaw" : 
    {
      "abi" : "[{\"constant\":true,\"inputs\":[{\"name\":\"key\",\"type\":\"uint256\"}],\"name\":\"prev\",\"outputs\":[{\"name\":\"_key\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"first\",\"outputs\":[{\"name\":\"_key\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"last\",\"outputs\":[{\"name\":\"_key\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_key\",\"type\":\"uint256\"}],\"name\":\"remove\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"key\",\"type\":\"uint256\"}],\"name\":\"parent\",\"outputs\":[{\"name\":\"_parent\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"_key\",\"type\":\"uint256\"}],\"name\":\"getNode\",\"outputs\":[{\"name\":\"key\",\"type\":\"uint256\"},{\"name\":\"parent\",\"type\":\"uint256\"},{\"name\":\"left\",\"type\":\"uint256\"},{\"name\":\"right\",\"type\":\"uint256\"},{\"name\":\"red\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"key\",\"type\":\"uint256\"}],\"name\":\"exists\",\"outputs\":[{\"name\":\"_exists\",\"type\":\"bool\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"key\",\"type\":\"uint256\"}],\"name\":\"sibling\",\"outputs\":[{\"name\":\"_parent\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"key\",\"type\":\"uint256\"}],\"name\":\"uncle\",\"outputs\":[{\"name\":\"_parent\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":false,\"inputs\":[{\"name\":\"_key\",\"type\":\"uint256\"}],\"name\":\"insert\",\"outputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"key\",\"type\":\"uint256\"}],\"name\":\"grandparent\",\"outputs\":[{\"name\":\"_grandparent\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[],\"name\":\"root\",\"outputs\":[{\"name\":\"_key\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"constant\":true,\"inputs\":[{\"name\":\"key\",\"type\":\"uint256\"}],\"name\":\"next\",\"outputs\":[{\"name\":\"_key\",\"type\":\"uint256\"}],\"payable\":false,\"stateMutability\":\"view\",\"type\":\"function\"},{\"inputs\":[],\"payable\":false,\"stateMutability\":\"nonpayable\",\"type\":\"constructor\"},{\"anonymous\":false,\"inputs\":[{\"indexed\":false,\"name\":\"where\",\"type\":\"string\"},{\"indexed\":false,\"name\":\"action\",\"type\":\"string\"},{\"indexed\":false,\"name\":\"key\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"parent\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"left\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"right\",\"type\":\"uint256\"},{\"indexed\":false,\"name\":\"red\",\"type\":\"bool\"}],\"name\":\"Log\",\"type\":\"event\"}]",
      "bin" : "608060405234801561001057600080fd5b5061139f806100206000396000f3fe608060405234801561001057600080fd5b50600436106100ec576000357c0100000000000000000000000000000000000000000000000000000000900480634f558e79116100a957806390b5561d1161008357806390b5561d14610221578063c0a4d38f1461023e578063ebf0c7171461025b578063edd004e514610263576100ec565b80634f558e79146101b657806365e92143146101e757806383af31b914610204576100ec565b806335671214146100f15780633df4ddf41461012057806347799da8146101285780634cc82215146101305780634eaa9d221461014f5780634f0f4aa91461016c575b600080fd5b61010e6004803603602081101561010757600080fd5b5035610280565b60408051918252519081900360200190f35b61010e610298565b61010e6102a9565b61014d6004803603602081101561014657600080fd5b50356102b5565b005b61010e6004803603602081101561016557600080fd5b50356102c9565b6101896004803603602081101561018257600080fd5b50356102db565b60408051958652602086019490945284840192909252606084015215156080830152519081900360a00190f35b6101d3600480360360208110156101cc57600080fd5b5035610303565b604080519115158252519081900360200190f35b61010e600480360360208110156101fd57600080fd5b5035610315565b61010e6004803603602081101561021a57600080fd5b5035610327565b61014d6004803603602081101561023757600080fd5b5035610339565b61010e6004803603602081101561025457600080fd5b503561034a565b61010e61035c565b61010e6004803603602081101561027957600080fd5b5035610362565b6000610292818363ffffffff61037416565b92915050565b60006102a46000610413565b905090565b60006102a46000610453565b6102c660008263ffffffff61048e16565b50565b6000610292818363ffffffff6106e516565b6000808080806102f1818763ffffffff61070916565b939a9299509097509550909350915050565b6000610292818363ffffffff61075b16565b6000610292818363ffffffff61078f16565b6000610292818363ffffffff61081216565b6102c660008263ffffffff61085716565b6000610292818363ffffffff61097516565b60005490565b6000610292818363ffffffff6109b216565b600081151561038257600080fd5b6000828152600180850160205260409091200154156103c15760008281526001808501602052604090912001546103ba908490610a4a565b9050610292565b5060008181526001830160205260409020545b80158015906103f55750600081815260018085016020526040909120015482145b156102925760008181526001840160205260409020549091506103d4565b8054801561044e575b60008181526001808401602052604090912001541561044e57600090815260018083016020526040909120015461041c565b919050565b8054801561044e575b60008181526001830160205260409020600201541561044e57600090815260018201602052604090206002015461045c565b80151561049a57600080fd5b60008083600001548314806104ca5750835483148015906104ca5750600083815260018501602052604090205415155b15156104d557600080fd5b6000838152600180860160205260409091200154158061050657506000838152600185016020526040902060020154155b1561051257508161055a565b5060008281526001840160205260409020600201545b60008181526001808601602052604090912001541561055a576000908152600180850160205260409091200154610528565b60008181526001808601602052604090912001541561058e57600081815260018086016020526040909120015491506105a5565b600081815260018501602052604090206002015491505b600081815260018501602052604080822054848352912081905580156106175760008181526001808701602052604090912001548214156105fb5760008181526001808701602052604090912001839055610612565b600081815260018601602052604090206002018390555b61061b565b8285555b600082815260018601602052604090206003015460ff16158483146106a557610645868487610a87565b60008581526001878101602052604080832080830154878552828520938401819055845281842087905560028082015490840181905584529083208690556003908101549286905201805460ff191660ff90921615159190911790559193915b80156106b5576106b58685610b00565b5050600090815260019384016020526040812081815593840181905560028401555050600301805460ff19169055565b60008115156106f357600080fd5b5060009081526001909101602052604090205490565b600080600080600061071b878761075b565b151561072657600080fd5b505050600083815260019485016020526040902080549481015460028201546003909201549496909491935060ff9091169150565b600081156107865782548214806103ba57505060008181526001830160205260409020541515610292565b50600092915050565b600081151561079d57600080fd5b600082815260018401602052604090205480156108065760008181526001808601602052604090912001548314156107ea5760008181526001850160205260409020600201549150610801565b600081815260018086016020526040909120015491505b61080b565b600091505b5092915050565b600081151561082057600080fd5b600061082c8484610975565b9050801561080657600083815260018501602052604090205461084f858261078f565b92505061080b565b80151561086357600080fd5b61086d828261075b565b1561087757600080fd5b81546000905b80156108c157809150808310156108a75760009081526001808501602052604090912001546108bc565b60009081526001840160205260409020600201545b61087d565b60408051608081018252838152600060208083018281528385018381526001606086018181528a86528b82019094529590932093518455519383019390935551600282015590516003909101805460ff191691151591909117905581151561092b57828455610965565b8183101561094e5760008281526001808601602052604090912001839055610965565b600082815260018501602052604090206002018390555b61096f8484610f1f565b50505050565b600081151561098357600080fd5b60008281526001840160205260409020548015610806576000818152600185016020526040902054915061080b565b60008115156109c057600080fd5b6000828152600184016020526040902060020154156109f85760008281526001840160205260409020600201546103ba90849061118a565b5060008181526001830160205260409020545b8015801590610a2c5750600081815260018401602052604090206002015482145b15610292576000818152600184016020526040902054909150610a0b565b60005b600082815260018401602052604090206002015415610a815760009182526001830160205260409091206002015490610a4d565b50919050565b6000818152600184016020526040808220548483529120819055801515610ab05782845561096f565b6000818152600180860160205260409091200154821415610ae6576000818152600180860160205260409091200183905561096f565b600090815260019390930160205250604090912060020155565b60005b82548214801590610b285750600082815260018401602052604090206003015460ff16155b15610f00576000828152600180850160205260408083205480845292200154831415610d275760008181526001850160205260408082206002015480835291206003015490925060ff1615610bcc576000828152600180860160205260408083206003908101805460ff19908116909155858552919093209092018054909216179055610bb584826111c2565b600081815260018501602052604090206002015491505b60008281526001808601602052604080832090910154825290206003015460ff16158015610c175750600082815260018501602052604080822060020154825290206003015460ff16155b15610c4457600082815260018581016020526040909120600301805460ff19169091179055915081610d22565b600082815260018501602052604080822060020154825290206003015460ff161515610cc3576000828152600180860160205260408083208083015484529083206003908101805460ff1990811690915593869052018054909216179055610cac848361129c565b600081815260018501602052604090206002015491505b600081815260018501602052604080822060039081018054868552838520808401805460ff909316151560ff199384161790558254821690925560029091015484529190922090910180549091169055610d1d84826111c2565b835492505b610efa565b6000818152600180860160205260408083209091015480835291206003015490925060ff1615610da6576000828152600180860160205260408083206003908101805460ff19908116909155858552919093209092018054909216179055610d8f848261129c565b600081815260018086016020526040909120015491505b600082815260018501602052604080822060020154825290206003015460ff16158015610df1575060008281526001808601602052604080832090910154825290206003015460ff16155b15610e1e57600082815260018581016020526040909120600301805460ff19169091179055915081610efa565b60008281526001808601602052604080832090910154825290206003015460ff161515610e9f57600082815260018086016020526040808320600281015484529083206003908101805460ff1990811690915593869052018054909216179055610e8884836111c2565b600081815260018086016020526040909120015491505b60008181526001808601602052604080832060039081018054878652838620808401805460ff909316151560ff19938416179055825482169092559301548452922090910180549091169055610ef5848261129c565b835492505b50610b03565b506000908152600190910160205260409020600301805460ff19169055565b60005b82548214801590610f4c5750600082815260018401602052604080822054825290206003015460ff165b1561116857600082815260018085016020526040808320548084528184205484529220015481141561106f5760008181526001850160205260408082205482528082206002015480835291206003015490925060ff1615610ff5576000818152600180860160205260408083206003808201805460ff1990811690915587865283862082018054821690558254865292852001805490921690921790559082905254925061106a565b600081815260018501602052604090206002015483141561101d5780925061101d84846111c2565b50600082815260018085016020526040808320548084528184206003808201805460ff1990811690915582548752938620018054909316909317909155918290525461106a90859061129c565b611162565b6000818152600180860160205260408083205483528083209091015480835291206003015490925060ff16156110ed576000818152600180860160205260408083206003808201805460ff19908116909155878652838620820180548216905582548652928520018054909216909217905590829052549250611162565b600081815260018086016020526040909120015483141561111557809250611115848461129c565b50600082815260018085016020526040808320548084528184206003808201805460ff199081169091558254875293862001805490931690931790915591829052546111629085906111c2565b50610f22565b505080546000908152600190910160205260409020600301805460ff19169055565b60005b600082815260018085016020526040909120015415610a8157600091825260018084016020526040909220909101549061118d565b60008181526001808401602052604080832060028101805491548286529285209093015493859052918390559091801561120a57600081815260018601602052604090208490555b6000838152600186016020526040902082905581151561122c57828555611279565b60008281526001808701602052604090912001548414156112625760008281526001808701602052604090912001839055611279565b600082815260018601602052604090206002018390555b505060008181526001938401602052604080822090940183905591825291902055565b600081815260018084016020526040808320918201805492548385529184206002015493859052839055909180156112e257600081815260018601602052604090208490555b6000838152600186016020526040902082905581151561130457828555611351565b600082815260018601602052604090206002015484141561133a5760008281526001860160205260409020600201839055611351565b600082815260018087016020526040909120018390555b505060008181526001909301602052604080842060020183905591835291205556fea165627a7a723058207c21d2227693249c4c8d8016d3dcf51aff0ea45d74a61af9b798d023323afa380029"
    }
  },
  "version" : "0.5.4+commit.9549d8ff.Darwin.appleclang"
};
