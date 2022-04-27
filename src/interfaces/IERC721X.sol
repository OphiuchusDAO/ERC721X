// SPDX-License-Identifier: MIT

pragma solidity >=0.8.7 <0.9.0;

interface IERC721X {
    function mint(address _to, uint256 _id, string memory _tokenURI) external;
    function originAddress() external view returns (address);
    function originChainId() external view returns (uint16);
}
