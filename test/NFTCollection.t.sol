// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import {Test, console} from "../lib/forge-std/src/Test.sol";
import {NFTCollection} from "../src/NFTCollection.sol";

contract NFTCollectionTest is Test {
    NFTCollection public nft;

    // Variables ficticias para el despliegue de prueba
    string constant NAME = "None NFT";
    string constant SYMBOL = "NLFNFT";
    uint256 constant TOTAL_SUPPLY = 2;
    string constant BASE_URI = "ipfs://bafybeiggbczrqjigvsr4v3eaeawyhq2gk2ywftjy3kawh4elecjffdlptu/";

    // Definimos un usuario ficticio usando "fuzzing/prank" de Foundry
    address public user = makeAddr("user");

    event MintNFT(address userAddress_, uint256 tokenID_);

    // Se ejecuta antes de cada test (despliega un contrato fresco)
    function setUp() public {
        nft = new NFTCollection(NAME, SYMBOL, TOTAL_SUPPLY, BASE_URI);
    }

    // 1. Validar que el constructor configure todo bien
    function test_Initialization() public view {
        assertEq(nft.name(), NAME);
        assertEq(nft.symbol(), SYMBOL);
        assertEq(nft.totalSupply(), TOTAL_SUPPLY);
        assertEq(nft.currentTokenId(), 0);
    }

    // 2. Validar que el mint funcione correctamente e incremente el ID
    function test_MintSuccessful() public {
        // Le decimos a Foundry que la siguiente transacción la firma "user"
        vm.prank(user);
        
        // Esperamos que se emita el evento MintNFT antes de la interacción
        vm.expectEmit(true, true, false, true);
        emit MintNFT(user, 0);

        nft.mint();

        // Verificaciones de estado
        assertEq(nft.ownerOf(0), user);
        assertEq(nft.currentTokenId(), 1);
        assertEq(nft.balanceOf(user), 1);
    }

    // 3. Validar que el TokenURI se concatene de forma correcta
    function test_TokenURI() public {
        vm.prank(user);
        nft.mint();

        string memory expectedURI = string.concat(BASE_URI, "0.json");
        assertEq(nft.tokenURI(0), expectedURI);
    }

    // 4. Validar que falle (revert) si intentamos consultar un token que no existe
    function test_RevertWhen_TokenDoesNotExist() public {
        // Estándar OpenZeppelin ERC721 error selector para tokens inexistentes
        // custom error ERC721NonexistentToken(uint256 tokenId)
        bytes4 selector = bytes4(keccak256("ERC721NonexistentToken(uint256)"));
        
        vm.expectRevert(abi.encodeWithSelector(selector, 0));
        nft.tokenURI(0); // El token 0 aún no se ha minado
    }

    // 5. Validar que falle por "Sold Out" si supera el max supply
    function test_RevertWhen_SoldOut() public {
        // El supply máximo configurado es 2 (IDs permitidos: 0 y 1)
        
        vm.prank(user);
        nft.mint(); // Mina el ID 0

        vm.prank(user);
        nft.mint(); // Mina el ID 1

        // El tercer intento debería lanzar el require("Sold Out")
        vm.prank(user);
        vm.expectRevert("Sold Out");
        nft.mint(); 
    }
}