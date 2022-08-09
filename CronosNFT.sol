// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";

contract CronosNFT is ERC721 {
    uint256 public NFTtokenId;
    uint256 public maxSupply = 10000;
    uint256 public price = 1 ether;

    address owner = 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2;

    string tokenBaseURI = "ipfs://conentID/";

    constructor() ERC721("CronosNFT", "CN") {}

    function _baseURI() internal view virtual override returns (string memory) {
        return tokenBaseURI;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        _requireMinted(tokenId);

        string memory baseURI = _baseURI();
        return baseURI;
        // return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    function mint() public payable {
        require(NFTtokenId < maxSupply, "max supplied exceed");
        require(msg.value >= price, "insufficient fund");
        _mint(msg.sender, NFTtokenId);
        ++NFTtokenId;
    }

    function withdraw() public {
        (bool sent, ) = payable(owner).call{value: address(this).balance}("");
        require(sent, "Tx Failed");
    }
}
