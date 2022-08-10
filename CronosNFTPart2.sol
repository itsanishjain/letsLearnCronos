// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.7.0 <0.9.0;
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC721/ERC721.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Strings.sol";

contract CronosNFTPart2 is ERC721, Ownable {
    using Strings for uint256;

    uint256 public NFTtokenId;
    uint256 public maxSupply = 10000;
    uint256 public price = 1 ether;

    bool public reveal;

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
        if (!reveal) return baseURI;
        return
            bytes(baseURI).length > 0
                ? string(abi.encodePacked(baseURI, tokenId.toString()))
                : "";
    }

    function mint() public payable {
        require(NFTtokenId < maxSupply, "max supplied exceed");
        require(msg.value >= price, "insufficient fund");
        _mint(msg.sender, NFTtokenId);
        ++NFTtokenId;
    }

    function withdraw() public onlyOwner {
        (bool sent, ) = payable(owner()).call{value: address(this).balance}("");
        require(sent, "Tx Failed");
    }

    function setPrice(uint256 newPrice) external onlyOwner {
        price = newPrice;
    }

    function setTokenBaseURI(string memory newTokenBaseURI) external onlyOwner {
        tokenBaseURI = newTokenBaseURI;
    }

    function setReveal(bool newReveal) external onlyOwner {
        reveal = newReveal;
    }
}
