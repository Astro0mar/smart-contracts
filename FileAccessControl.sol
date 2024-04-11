// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.24;

contract FileAccessControl {
    enum AccessLevel {
        None,
        Read,
        Write,
        Admin
    }
    address public owner;
    struct File {
        uint fileID;
        string name;
        uint size;
        AccessLevel accessrequired;
    }

    // why i did array instead of mapping in this case ?
    File[] public files;

    mapping(address => mapping(uint => bool)) public filesAccess;

    event FileAdded(uint fileID, string name, AccessLevel accessrequired);
    event AccessGranted(address user, uint fileID);
    event AccessRevoked(address user, uint fileID);

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(
            owner = msg.sender,
            "only the contract owner can call this function"
        );
        _;
    }

    function addFile(
        uint _fileID,
        string memory _name,
        AccessLevel _accessreq
    ) public onlyOwner {
        files.push(
            File({fileID: _fileID, name: _name, accessrequired: _accessreq})
        );

        emit FileAdded(_fileID, _name, _accessreq);
    }

    function grantAccess(address _user, uint _fileID) public onlyOwner {
        require(_fileID < files.length, "invalid file id");

        filesAccess[_user][_fileID] = true;

        emit AccessGranted(_user, _fileID);
    }

    function revokeAccess(address _user, uint _fileID) public onlyOwner {
        require(_fileID < files.length, "invalid file id");

        filesAccess[_user][_fileID] = false;

        emit AccessRevoked(_user, _fileID);
    }

    function hasAccess(address _user, uint _fileID) public view returns (bool) {
        require(_fileID < files.length, "invalid file id");

        return filesAccess[_user][_fileID];
    }
}
