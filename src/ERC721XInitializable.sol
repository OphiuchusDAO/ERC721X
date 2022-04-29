// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity >=0.8.7 <0.9.0;

import "solmate/tokens/ERC721.sol";
import "./interfaces/IERC721X.sol";

contract ERC721XInitializable is ERC721, IERC721X {

    address public immutable minter;
    address public immutable originAddress;
    uint32 public immutable originChainId;
    mapping(uint256 => string) public _tokenURIs;

    function initialize(string memory _name, string memory _symbol, address _originAddress, uint32 _originChainId) ERC721(_name, _symbol) public {
        require(minter == address(0), "ALREADY_INIT");
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
}
