// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;
// pragma solidity ^0.8.0;
// pragma solidity >=0.8.0 <0.9.0;

contract SimpleStorage {

    uint256 favoriteNumber;

    struct People {
        uint256 favoriteNumber;
        string name;
    }
    // uint256[] public anArray;
    People[] public people;

    mapping(string => uint256) public nameToFavoriteNumber;

    function store(uint256 _favoriteNumber) public virtual {
        favoriteNumber = _favoriteNumber;
    }
    
    function retrieve() public view returns (uint256){
        return favoriteNumber;
    }

    function addPerson(string memory _name, uint256 _favoriteNumber) public {
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }
}



/* MY NOTES
pragma solidity ^0.8.26;

contract SimpleStorage {

    // bool hasFavouriteNumber = true;

    // uint256 favoriteNumber = 5;

    // string favoriteNumberInText = "eight";

    // int256 favoriteInt = -5;

    // address myAddress = 0xA910B94A26102704085e0cEd342fa5ECE03BA758;

    // bytes32 favoriteBytes = "cat";

    // --- This get initial value of 0  ---
    uint256 favoriteNumber;

    struct People {
        uint256 favoriteNumber;
        string name;
    }

    People[] public people;

    function store(uint256 _favoriteNumber) public {
        favoriteNumber = _favoriteNumber;
    }

    // view, pure functions disallow midification of state
    function retrieve() public view returns(uint256){
        return favoriteNumber;
    }

    //0x7EF2e0048f5bAeDe046f6BF797943daF4ED8CB47

    mapping(string => uint256) public nameToFavoriteNumber; 


    function addPerson(string memory _name, uint256 _favoriteNumber) public{
       // People memory newPerson = People({favoriteNumber: _favoriteNumber, name: _name});
       // OR
       // People memory newPerson = People(_favoriteNumber,_name);
       // people.push(newPerson);
       
        people.push(People(_favoriteNumber, _name));
        nameToFavoriteNumber[_name] = _favoriteNumber;
    }

    //calldata, memory, storage

    //memory - temp variable 
    //calldata - temp variable that cannot be modified
    //storage = perm variable that can be modified
}
*/