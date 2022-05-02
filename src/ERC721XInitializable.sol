// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity >=0.8.7 <0.9.0;

import "openzeppelin-contracts-upgradeable/contracts/token/ERC721/ERC721Upgradeable.sol";
import "openzeppelin-contracts-upgradeable/contracts/utils/introspection/ERC165StorageUpgradeable.sol";
import "./interfaces/IERC721X.sol";

contract ERC721XInitializable is ERC165StorageUpgradeable, ERC721Upgradeable, IERC721X {

    address public minter;
    address public originAddress;
    uint32 public originChainId;
    bytes4 constant interfaceId = IERC721X.originChainId.selector ^ IERC721X.originAddress.selector;
    mapping(uint256 => string) public _tokenURIs;

    function initialize(string memory _name, string memory _symbol, address _originAddress, uint32 _originChainId) public initializer {
        require(minter == address(0), "ALREADY_INIT");
        __ERC721_init(_name, _symbol);
        _registerInterface(interfaceId);
        minter = msg.sender;
        originAddress = _originAddress;
        originChainId = _originChainId;
    }

    function tokenURI(uint256 id) public view override returns (string memory) {
       return _tokenURIs[id];
    }

    function mint(address _to, uint256 _id, string memory _tokenURI) public {
        require(minter == msg.sender, "UNAUTH");
        _safeMint(_to, _id);
        _tokenURIs[_id] = _tokenURI;
    }

    function burn(uint256 _id) public {
        require(minter == msg.sender, "UNAUTH");
        _burn(_id);
    }

    function supportsInterface(bytes4 _interfaceId) public view virtual override(ERC165StorageUpgradeable, ERC721Upgradeable) returns (bool) {
        return (ERC721Upgradeable.supportsInterface(_interfaceId) || ERC165StorageUpgradeable.supportsInterface(_interfaceId) );
    }
}
