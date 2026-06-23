// SPDX-License-Identifier: MIT

pragma solidity 0.8.35;

import "../lib/openzeppelin-contracts/contracts/token/ERC721/ERC721.sol";
import {Strings} from "../lib/openzeppelin-contracts/contracts/utils/Strings.sol";

contract NFTCollection is ERC721 {
   
   using Strings for uint256;

    uint256 public currentTokenId;
    uint256 public totalSupply;
    string public baseUri;
   

   event MintNFT(address userAddress_, uint256 tokenID_);
    constructor(string memory name_, string memory symbol_, uint256 totalSupply_, string memory baseUri_) ERC721 (name_,symbol_){

        totalSupply = totalSupply_;
        baseUri = baseUri_;

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
    function _baseURI() internal override view virtual returns (string memory) {
        return baseUri;
    }

       function tokenURI(uint256 tokenId) public view override virtual returns (string memory) {
        _requireOwned(tokenId);

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string.concat(baseURI, tokenId.toString(), ".json") : "";
    }

}