// SPDX-License-Identifier: MIT

pragma solidity >=0.8.13 <0.9.0;
import "@fhenixprotocol/contracts/FHE.sol";
import {Permissioned, Permission} from "@fhenixprotocol/contracts/access/Permissioned.sol";

contract Storage {
// mapping of user to struct
// post storage struct to include likes tips creator address
// user credibility
mapping(eaddress => uint256) credibility;
// user
mapping (uint256 => post) myPost;


    struct post{
        string content;
        eu256 tips;
        uint256 likes;
        eaddress creator;
    }


// create post
function createPost() external{
    
} 
// like post
}