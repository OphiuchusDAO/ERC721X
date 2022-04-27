// SPDX-License-Identifier: MIT

pragma solidity >=0.8.7 <0.9.0;

import "forge-std/Test.sol";
import "../src/ERC721X.sol";
import "solmate/tokens/ERC721.sol";

contract ERC721XTest is Test, ERC721TokenReceiver {

    ERC721X nftx;
    address public alice = address(0xaa);
    address public bob = address(0xbb);
    address public charlie = address(0xcc);
    address remoteContract = address(0x1111);
    uint16 remoteChainId = uint16(1);

    function setUp() public {
        nftx = new ERC721X("TEST", "TST", remoteContract, remoteChainId);
        nftx.mint(alice, 0, "testURI");
    }

    function testMint() public {
        assertEq(alice, nftx.ownerOf(0));
        assertEq(remoteContract, nftx.originAddress());
        assertEq(remoteChainId, nftx.originChainId());
    }

    function testBurn() public {
        nftx.burn(0);
        vm.expectRevert("NOT_MINTED"); // next call
        nftx.ownerOf(0); // should revert because tokenId no longer exists
    }

    function testOnlyMinterCanBurn() public {
        vm.prank(bob);
        vm.expectRevert("UNAUTH"); // next call
        nftx.burn(0); // should revert because bob can't burn alice's tokenId
    }

    function testOnlyMinterCanMint() public {
        vm.prank(bob);
        vm.expectRevert("UNAUTH"); // next call
        nftx.mint(bob, 1, "superRareURI"); // should revert because bob can't mint
    }


}
