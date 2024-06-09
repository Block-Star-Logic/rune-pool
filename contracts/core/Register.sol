// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.8.2 <0.9.0;

import "../interfaces/IRVersion.sol";
import "../interfaces/IRegister.sol";

contract Register is IRegister, IRVersion {

    modifier adminOnly () {
        require(msg.sender == addressByName[RUNE_ADMIN], "admin only");
        _;
    }

    string constant name = "RESERVED_RUNE_REGISTER";
    uint256 constant version = 1; 

    string constant RUNE_ADMIN = "RESERVED_RUNE_ADMIN";
  

    string [] names; 
    mapping(string=>address) addressByName; 
    mapping(string=>bool) knownName;
    mapping(address=>string) nameByAddress; 

    constructor(address _admin) {
        addAddressInternal(RUNE_ADMIN, _admin);
    }

    function getName() pure external returns (string memory _name) {
        return name; 
    }

    function getVersion() pure external returns (uint256 _version) {
        return version; 
    }

    function getName(address _address) view external returns (string memory _name) {
        return nameByAddress[_address];
    }

    function getAddresses() view external returns (string [] memory _names, address [] memory _addresses) {
        _addresses = new address[](names.length);
        for(uint256 x = 0; x < names.length; x++){
            _addresses[x] = addressByName[names[x]];
        }
        return (names, _addresses);
    }

    function getAddress(string memory _name) view external returns (address _address){
        return addressByName[_name];
    }

    function addGVersionAddress(address _address) external adminOnly returns (bool _added) {
        IRVersion v = IRVersion(_address);
        return addAddressInternal(v.getName(), _address); 
    }   

    function addAddress(string memory _name, address _address) external adminOnly returns (bool _added) {
        return addAddressInternal(_name, _address); 
    } 

    //================================= INTERNAL ==================================================================


    function addAddressInternal(string memory _name, address _address) internal returns (bool _added) {
        if(!knownName[_name]){
            names.push(_name);
            knownName[_name] = true; 
        }
        addressByName[_name] = _address; 
        nameByAddress[_address] = _name;
        return true; 
    }

}