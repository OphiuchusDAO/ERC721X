// SPDX-License-Identifier: MIT

pragma solidity >=0.8.7 <0.9.0;

interface IERC721X {
    bytes4 constant InterfaceID = 0xefd00bbc;
    function originChainId() external view returns (uint32);
    function originAddress() external view returns (address);
    function setMinter(address _minter) external;
}
