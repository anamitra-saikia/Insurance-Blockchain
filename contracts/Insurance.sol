// SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0 ;

interface PaymentInterface{
    function pay(uint _amount , uint _paymentID) external  ;
}

contract insuranceA{

    bool premiumDue ;
    bool claimed ;
    bool init ;
    uint64 premiumAmount ;
    address public policyholder ;
    address public admin ;
    address paymentprocessor ;
    string infoipfs ;

    modifier initOnly(){
        require(!init , "Already Initialized");
        _;
        init = true ;
    }

    modifier onlyAdmin(){
        require(msg.sender == 0x2104ec6fEaD75dDA495cB7DDc44272Bd8528b2B3 , "Access Denied");
        _;
    }

    modifier claimedstatus(){
        require(!claimed , "Already Claimed") ;
        _;
    }

    event Status(
        uint date ,
        address PolicyHolder ,
        address policy ,
        string message 
    ) ;

    event Payment(
        uint date ,
        address PolicyHolder ,
        address policy ,
        string task
    ) ;
    
    //Initialize function : 
    function initialize(address _holder , string memory _ipfs, uint64 _premium, address _paymentprocessor) public initOnly{
        policyholder = _holder ;
        infoipfs = _ipfs ;
        premiumAmount = _premium ;
        paymentprocessor = _paymentprocessor ;
        admin = msg.sender ;
        emit Status(block.timestamp, policyholder, address(this) , "Initialized") ;
    }

    //set basic policy info by manager
    function setInfo(uint64 _premium , bool _due) external onlyAdmin claimedstatus{
        premiumAmount = _premium ;
        premiumDue = _due ;
        emit Status(block.timestamp, policyholder, address(this) , "Set by the manager") ;
    }

    //Update Profile in case of error or modification
    function updateProfile(address _addr , string calldata _ipfs) external onlyAdmin claimedstatus{
        init = false ;
        initialize(_addr , _ipfs, premiumAmount, paymentprocessor) ;
        emit Status(block.timestamp, policyholder, address(this) , "Profile Updated") ;
    }

    //Pay Premium
    function payPremium(uint _paymentID) external {
        require(msg.sender == policyholder && !claimed && premiumDue, "Access Denied") ;
        PaymentInterface(paymentprocessor).pay(premiumAmount, _paymentID) ;
        premiumDue = false ;
        emit Payment(block.timestamp, policyholder, address(this) , "Premium Paid") ;
    } 

    //Restricted Function
    function setClaim(bool _status) external onlyAdmin{
        claimed = _status ;
        emit Status(block.timestamp, policyholder, address(this) , "Claim Status") ;
    } 
}




contract insuranceB{

    bool premiumDue ;
    bool claimed ;
    bool init ;
    uint64 premiumAmount ;
    address public policyholder ;
    address public admin ;
    address paymentprocessor ;
    string infoipfs ;

    modifier initOnly(){
        require(!init , "Insurance Already Initialized");
        _;
        init = true ;
    }

    modifier onlyAdmin(){
        require(msg.sender == 0x2104ec6fEaD75dDA495cB7DDc44272Bd8528b2B3 , "Access Denied : Not Admin");
        _;
    }

    modifier claimedstatus(){
        require(!claimed , "Insurance Already Claimed") ;
        _;
    }

    event Status(
        uint date ,
        address PolicyHolder ,
        address policy ,
        string message 
    ) ;

    event Payment(
        uint date ,
        address PolicyHolder ,
        address policy ,
        string task
    ) ;
    
    //Initialize function : 
    function initialize(address _holder , string memory _ipfs, uint64 _premium, address _paymentprocessor) public initOnly{
        policyholder = _holder ;
        infoipfs = _ipfs ;
        premiumAmount = _premium ;
        paymentprocessor = _paymentprocessor ;
        admin = msg.sender ;
        emit Status(block.timestamp, policyholder, address(this) , "Initialized") ;
    }

    //set basic policy info by manager
    function setInfo(uint64 _premium , bool _due) external onlyAdmin claimedstatus{
        premiumAmount = _premium ;
        premiumDue = _due ;
        emit Status(block.timestamp, policyholder, address(this) , "Set by the manager") ;
    }

    //Update Profile in case of error or modification
    function updateProfile(address _addr , string calldata _ipfs) external onlyAdmin claimedstatus{
        init = false ;
        initialize(_addr , _ipfs, premiumAmount, paymentprocessor) ;
        emit Status(block.timestamp, policyholder, address(this) , "Profile Updated") ;
    }

    //Pay Premium
    function payPremium(uint _paymentID) external {
        require(msg.sender == policyholder && !claimed && premiumDue, "Access Denied") ;
        PaymentInterface(paymentprocessor).pay(premiumAmount, _paymentID) ;
        premiumDue = false ;
        emit Payment(block.timestamp, policyholder, address(this) , "Premium Paid") ;
    } 

    
    //Restricted Function
    function setClaim(bool _status) external onlyAdmin{
        claimed = _status ;
        emit Status(block.timestamp, policyholder, address(this) , "Claim Status") ;
    } 
}