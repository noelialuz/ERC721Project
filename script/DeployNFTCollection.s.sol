// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.35;

import {Script} from "../lib/forge-std/src/Script.sol";
import {NFTCollection} from "../src/NFTCollection.sol";

contract DeployNFTCollection is Script {
    
    function run() external  returns(NFTCollection){

        uint256 deployPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployPrivateKey);

        string memory name_ = "None NFT";
        string memory symbol_ = "NLFNFT";
        uint256 totalSupply_ = 2;
        string memory baseURI_ = "ipfs://bafybeiggbczrqjigvsr4v3eaeawyhq2gk2ywftjy3kawh4elecjffdlptu/"; 

        NFTCollection nftCollection = new NFTCollection(name_, symbol_, totalSupply_, baseURI_);

        vm.stopBroadcast(); 
        
        return nftCollection;
    }
}