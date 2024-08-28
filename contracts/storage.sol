// SPDX-License-Identifier: MIT

pragma solidity >=0.8.13 <0.9.0;
import "@fhenixprotocol/contracts/FHE.sol";
import {Permissioned, Permission} from "@fhenixprotocol/contracts/access/Permissioned.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Storage {
  // mapping of user to struct
  // post storage struct to include likes tips creator address
  uint256 postId;

  // Array to store all IDs
  uint256[] public ids;
  // user credibility

  uint256 totalCredibility;
  mapping(eaddress => uint256) credibility;

  //  total user tip in the contact
  mapping(address => uint256) private totalTips;
  // user
  mapping(uint256 => Post) myPost;

  struct Post {
    string content;
    euint256 tips;
    uint256 likes;
    eaddress creator;
    uint256 report;
    bool flagged;
  }

  // create post
  function createPost(string memory _content, eaddress _creator) external {
    uint256 id = postId++;
    Post memory post = myPost[id];
    post.content = _content;
    post.creator = _creator;

    // emit event
  }

  // tip post
  function tip(uint256 postId_, euint256 tipAmount_, address token_) external {
    Post memory post = myPost[postId_];
    address creator = FHE.decrypt(post.creator);
    euint256 totalAmount = post.tips + tipAmount_;
    post.tips = totalAmount;
    uint256 transferAmount = FHE.decrypt(tipAmount_);
    totalTips[creator] += tipAmount_;
    IERC20(token_).transfer(address(this), tipAmount_);
    // IERC20(token_).transferFrom(msg.sender,address(this), tipAmount_);
    // Emmit event
  }

  // like post
  function likePost(uint256 postId_) external {
    Post memory post = myPost[postId_];
    post.likes += 1;
  }

  // flag Post
  //   to flag post you must have 15% credibility

  function flagPost(uint256 postId_) external {
    eaddress flagger = FHE.encryptedValue(msg.sender);
    uint256 percent = ((15 / 100) * totalCredibility) * 100;
    require(credibility[flagger] * 100 >= percent, "NOT_CREDIBLE");
    Post memory post = myPost[postId_];
    post.report += 1;
  }

  // withdrawTip
  function withdrawTip(uint256 amount_, address token_) external {
    uint256 balances = totalTips[msg.sender];
    require(amount_ <= balances, "Insufficient Tip");
    require(
      IECR20(token_).balanceOf(address(this)) > amount_,
      "TRY AGAIN LATER"
    );
    IERC20(token).transferFrom(address(this), msg.sender, amount_);
  }

  //   myTotalTip

  // read single post
  function readSinglePost(
    Permission calldata perm,
    uint256 postId_
  ) external view onlySender(perm) returns (Post memory) {
    Post memory post = myPost[postId_];
    return post;
  }
  // read all post


  // if post is flagged hash the content
}
