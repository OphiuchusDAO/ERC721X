# ERC721X - Cross-Chain Bridged NFT standard

A modified ERC721 contract for use as a bridged NFT.

Ownership of an ERC721X token represents ownership, realized or not, of an ERC721 token on another chain.
ERC721X contracts maintain state relevant to their native chain.

This repository includes the `IERC721X` interface as well as an implementation in `src/ERC721X.sol`.

## IERC721X

The interface defines two functions necessary for maintaining bare minimum state which tracks an asset's native representation.

``` solidity
// SPDX-License-Identifier: MIT

pragma solidity >=0.8.7 <0.9.0;

interface IERC721X {
    function originChainId() external view returns (uint16);
    function originAddress() external view returns (address);
}
```

`originChainId` MUST return the Chain Id `chainId` corresponding to this asset's native representation (i.e. "Home chain")

`originAddress()` MUST return an address `addr` such that:

- `addr` is a deployed ERC721 contract on the chain represented by `chainId` returned by `originChainId`
- `IERC721(addr).tokenURI(id)`, if a valid function (i.e. the "Home NFT" supports the ERC721Metadata extension), will return the same tokenURI on the "Home Chain" as on the current "Local Chain" (where the token has been bridged *to*)


## ERC721X

This is an implementation of the above interface for use in cross-chain NFT applications. It depends on a trusted `minter`, which is expected to be a smart contract which is part of a larger bridging architecture. The minter has the right to mint and burn `tokenId`s, and is expected to do so as management of cross-chain NFT assets.

The contract has a special `mint` function which accepts the entire `tokenURI` that should be returned for this `tokenId`.

``` solidity
...

    function mint(address _to, uint256 _id, string memory _tokenURI) public {
        require(minter == msg.sender, "UNAUTH");
        _safeMint(_to, _id);
        _tokenURIs[_id] = _tokenURI;
    }
...
```

