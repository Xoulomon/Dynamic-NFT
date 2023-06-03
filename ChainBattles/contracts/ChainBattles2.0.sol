// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

contract ChainBattles is ERC721URIStorage{
    using Strings for uint256;
    using Strings for Attribute;
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    struct Attribute {
        uint256 _warriorId;
        uint256 level;
        uint256 speed;
        uint256 strength;
        uint256 life;
    }
    

    mapping (uint256 => Attribute) public tokenIdToAttributes;

    constructor() ERC721("Chain Battles 2.0", "CHBT2"){

    }

    function generateCharacter(uint256 tokenId) public view returns(string memory){

    bytes memory svg = abi.encodePacked(
        '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
        '<style>.base { fill: black; font-family: serif; font-size: 14px; }</style>',
        '<rect width="100%" height="100%" fill="purple" />',
        '<text x="50%" y="30%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior #",getWarriorId(tokenId),'</text>',
        '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getLevel(tokenId),'</text>',
        '<text x="50%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed: ",getSpeed(tokenId),'</text>',
        '<text x="50%" y="60%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strength: ",getStrength(tokenId),'</text>',
        '<text x="50%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Life: ",getLife(tokenId),'</text>',
        '<text x="50%" y="90%" class="base" dominant-baseline="middle" text-anchor="middle">', "Dynamic NFTs by Xoulomon :)",'</text>',
        '</svg>'
    );
    return string(
        abi.encodePacked(
            "data:image/svg+xml;base64,",
            Base64.encode(svg)
        )    
    );
}
    function getWarriorId(uint256 tokenId) private view returns (string memory) {
    Attribute memory attrs = tokenIdToAttributes[tokenId];

    return attrs._warriorId.toString();
}

    function getLevel(uint256 tokenId) private view returns (string memory) {
    Attribute memory attrs = tokenIdToAttributes[tokenId];

    return attrs.level.toString();
}

    function getSpeed(uint256 tokenId) private view returns (string memory) {
       Attribute memory attrs = tokenIdToAttributes[tokenId];

        return attrs.speed.toString();
    }

    function getStrength(uint256 tokenId) private view returns (string memory) {
        Attribute memory attrs = tokenIdToAttributes[tokenId];
        return attrs.strength.toString();
    }

    function getLife(uint256 tokenId) private view returns (string memory) {
        Attribute memory attrs = tokenIdToAttributes[tokenId];
        return attrs.life.toString();
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory){
    bytes memory dataURI = abi.encodePacked(
        '{',
            '"name": "Chain Battles #', tokenId.toString(), '",',
            '"description": "Battles on chain",',
            '"image": "', generateCharacter(tokenId), '"',
        '}'
    );
    return string(
        abi.encodePacked(
            "data:application/json;base64,",
            Base64.encode(dataURI)
        )
    );
}
    function random(uint number) private view returns(uint){
        return uint(keccak256(abi.encodePacked(block.timestamp,block.prevrandao,  
        msg.sender))) % number;
    }

    function newRandom(uint number, uint initialNumber) private pure returns(uint){
        return uint(keccak256(abi.encodePacked(initialNumber++))) % number;
    }

    function mint() public {
    _tokenIds.increment();
    uint256 newItemId = _tokenIds.current();
    _safeMint(msg.sender, newItemId);
    tokenIdToAttributes[newItemId] =Attribute(newItemId,1,random(50),random(100),2);
    _setTokenURI(newItemId, getTokenURI(newItemId));
}

    function train(uint256 tokenId) public {
    require(_exists(tokenId), "Please use an existing token");
    require(ownerOf(tokenId) == msg.sender, "You must own this token to train it");
    Attribute memory currentAttribute = tokenIdToAttributes[tokenId];
    uint256 newLevel = currentAttribute.level + 1;
    uint256 newLife = currentAttribute.life + 2;
    uint256 currentSpeed = currentAttribute.speed;
    uint256 currentStrength = currentAttribute.strength;
    tokenIdToAttributes[tokenId] = Attribute(tokenId,newLevel, newRandom(50, currentSpeed), newRandom(100, currentStrength), newLife);
    _setTokenURI(tokenId, getTokenURI(tokenId));
}

}