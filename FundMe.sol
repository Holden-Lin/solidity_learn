// SPDX-License-Identifier: MIT
pragma solidity ^0.8.7;
// As of Solidity 0.8.x, overflow and underflow checks are built directly into the language

// THIS IS A CONTRACT THAT CAN COLLECT FUNDS FOR MYSELF

// refer to https://docs.chain.link/data-feeds/using-data-feeds#solidity
// using chainlink as an oracle to get out-of-blockchain price data
// to see what the chainlink smartcontract contains, refer to https://github.com/smartcontractkit/chainlink/blob/develop/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol
// if we look at the code, you will find it is an interface object
// an interface will be complied down to ABI that specifies how to interact with a contract

// now the contract is imported from npm with below syntax
import "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

contract FundMe{
    // array of addresses who deposited
    address[] public funders;
    //address of the owner (who deployed the contract)
    address public owner;

    //mapping to store which address depositeded how much ETH
    mapping(address => uint256) public addressToAmountFunded;

    // contructor runs when a contract deploys
    // the address of the one deploying the contract, will be the msg.sender of the constructor
    // In Solidity 0.7.0 and later versions, the visibility (public/private/internal/external) for constructors is ignored because constructors are not callable externally once the contract is deployed. The constructor only runs once, at the time of contract deployment.
    constructor() {
        owner = msg.sender;
    }

    function getPrice() public view returns(uint256){
        // get contract address from here https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1#sepolia-testnet
        // now I am using ETH-USD
        // note that the contract is in Sepolia testnet (so in remix we need to deploy our contract in Sepolia to interact with it)
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 answer, , , ) = priceFeed.latestRoundData();
        // decimal 8
        return uint256(answer);

    }

    //function to get the version of the chainlink pricefeed
    function getVersion() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(
            0x694AA1769357215DE4FAC081bf1f309aDC325306
        );
        
        return priceFeed.version();
    }

    // a function to receive funding
    // the payable modifier allows a function to receive Ether when it's called
    function fund() public payable {
        
        uint256 minimumUSD = 5 * 10 ** 8;
        uint256 ethPrice = getPrice();
        uint256 minimumETH = minimumUSD / ethPrice;

        require(
            msg.value >= minimumETH,
            // return the error description when is not as required
            "You need to spend more than $5!"
        );

        addressToAmountFunded[msg.sender] += msg.value;
        // note that wei is used as default unit
        funders.push(msg.sender);
    }

    // modifier is a special construct gets run when a function that uses it is called
    // so the motivation of using modifier is to save time
    modifier onlyOwner() {
        require( msg.sender == owner);
        _;
    }

    function withdraw() public onlyOwner payable{
        
        // msg.sender.transfer(address(this).balance);
        //  "send" and "transfer" are only available for objects of type "address payable"
        address payable recipient = payable(msg.sender);
        recipient.transfer(address(this).balance);

        // delete addresss and value mapping after withdrawal
        for (uint256 i=0; i < funders.length; i++) 
        {
            address funder = funders[i];
            addressToAmountFunded[funder] = 0;
        }

        // create a new funder array after deleting
        // it is a good practice when you want to explicitly set the size of the new array to zero
        funders = new address[](0);

    }

    function getContractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
