//SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol";
import"https://github.com/aave/aave-v3-core/blob/master/contracts/interfaces/IPoolAddressesProvider.sol";
import "https://github.com/aave/aave-v3-core/blob/master/contracts/interfaces/IPool.sol";


interface WethContract {
    function deposit() external payable;

    function transfer(address, uint256) external;

    function approve(address sender, uint256 value) external returns (bool);

    function withdraw(uint256 amount) external payable;

    function balanceOf(address sender) external view returns (uint balanace);
}



contract WrappedEthConverter {

    uint256 wEthFunds;
    uint256 ethFunds;
    address public owner;
   
    
    address weth_address = 0x608D14ED73aE54F353d662555f2c445c40bC10c7;
    address aweth_address = 0xb7eca5eAA51c678B97AE671df511bDdE2CE99896;

    address weth_addressRinkeby=0xc778417E063141139Fce010982780140Aa0cD5Ab;
    
    address poolAddress;
    IERC20 weth = IERC20(weth_address);
    IERC20 aweth = IERC20(aweth_address);
    IERC20 wrappedEtherToken = IERC20(weth_addressRinkeby);

    IPool lendingPool;
    IPoolAddressesProvider provider;

    WethContract wrappedEthContract; 

    event ETHDeposit(address sender, uint value);
    event ERC20Deposit(address sender);

      modifier onlyOwner(){
    require(owner==msg.sender);
    _;
    }

    constructor () {
        owner = payable(msg.sender);
        ethFunds = 0;
        provider = IPoolAddressesProvider(address(0xA55125A90d75a95EC00130E8E8C197dB5641Eb19));
        poolAddress = provider.getPool();
        lendingPool = IPool(poolAddress);
        wrappedEthContract = WethContract(address(0xc778417E063141139Fce010982780140Aa0cD5Ab));
    }

  

    function seePoolAddress () public view returns (address){
        return poolAddress;
    }

    function setBalance() public {
       
        ethFunds  = (address(this)).balance;

        // weth_balance= weth.balanceOf(address(this));
        // aweth_balance = aweth.balanceOf(address(this));

        
        wEthFunds = wrappedEtherToken.balanceOf(address(this));
    }


    receive() external payable {
    }

    fallback() external payable {
    }

     function seeEthFunds() public view returns(uint256){
         return ethFunds;
     }

     function seeWEthFunds() public view returns (uint256){
         return wEthFunds;
     }

     function convertToWrappedEth()public {
        bool txStatus = wrappedEthContract.approve(address(this),ethFunds); 
        require(txStatus, 'transaction needs to be approved');
        wrappedEthContract.deposit{value:ethFunds}();        
     }

     function getWEthToWallet() public{
        wrappedEthContract.approve(msg.sender,wEthFunds); 
        wrappedEthContract.transfer(msg.sender,wEthFunds);
        // wrappedEth.withdraw(depositedFunds);
     }

     function convertToEther()public{
         wrappedEthContract.approve(address(this),wEthFunds);
         uint amountIn = wrappedEthContract.balanceOf(address(this));
         wrappedEthContract.withdraw(amountIn);
     }


  
}



