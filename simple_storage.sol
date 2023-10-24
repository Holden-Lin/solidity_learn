// SPDX-License-Identifier: MIT
pragma solidity >=0.6.0 <0.9.0;

contract SimpleStorage {

    // defautly initialized to 0
    uint256 favoriteNumber;

    // a struct is a composite data type that groups variables under a single name
    struct People{
        uint256 favoriteNumber;
        string name;
    }

    // defines a public state variable named people, which is an array of People structs
    People[] public people;
    // Maps are created with the syntax mapping(keyType => valueType)
    mapping(string => uint256) public nametofavoritenumber;
  

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }
    
    // must explicitly specify the return type after the returns keyword.
    // view function: Can read state variables but cannot modify them.
    function retrieve() public view returns (uint256) {
        return favoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        // The push function is used to append a new element to the end of the people array
        people.push(People(_favoriteNumber, _name));
        nametofavoritenumber[_name] = _favoriteNumber;
    }

  }