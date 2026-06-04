// SPDX-License-Identifier: MIT

pragma solidity 0.8.35;

import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";

contract NFTCollection is ERC721 {
   
    uint256 public currentTokenId;
    uint256 public totalSupply;
   

   event MintNFT(address userAddress_, uint256 tokenID_);
    constructor(string memory name_, string memory symbol_, uint256 totalSupply_) ERC721 (name_,symbol_){

        totalSupply = totalSupply_;

    }

    function mint () external{

        // Checks
        uint256 tokenIdToMint = currentTokenId;
        require(currentTokenId < totalSupply, "Sold Out");
        
        //Effects
        unchecked {
            currentTokenId = tokenIdToMint + 1;
        }

        //Interactions
        _safeMint(msg.sender, tokenIdToMint);
        
        emit MintNFT(msg.sender, tokenIdToMint);

    }
    

}