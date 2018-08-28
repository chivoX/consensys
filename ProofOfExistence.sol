contract ProofOfExistenceStore {
    
    struct Proof {
        bytes fileName;
        bytes dataHash;
        bytes dateTime;
        address signee;
    }
    
    Proof[] public proofs;
    
    mapping (uint => address) private entries;
    mapping (address => uint) private ownerProofsCount;
    
    function createProof (string _dataHash, string _fileName, string _dateTime) public {
        bytes memory _dataHashBytes = bytes(_dataHash);
        bytes memory _fileNameBytes = bytes(_fileName);
        bytes memory _dateTimeBytes = bytes(_dateTime);
        
        uint id = proofs.push(Proof(_fileNameBytes, _dataHashBytes, _dateTimeBytes, msg.sender)) - 1;
        entries[id] = msg.sender;
        ownerProofsCount[msg.sender]++;
    }
    
    function verifyProof(uint _id, string _dataHash) public view returns (bool) {
        bytes memory _dataHashBytes = bytes(_dataHash);
        Proof memory p = proofs[_id];
        return keccak256(p.dataHash) == keccak256(_dataHashBytes);
    }
    
    function getProofsByOwner () external view returns(uint[]) {
        uint[] memory result = new uint[](ownerProofsCount[msg.sender]);
        
        uint counter = 0;
        
        for (uint i = 0; i <= proofs.length; i++) {
            if (entries[i] == msg.sender) {
                result[counter] = i;
                counter++;
            }
        }
        
        return result;
    }
    
    function showProof (uint _id) external view returns ( string _dataHash, string _fileName, string _dateTime) {
        Proof memory p = proofs[_id];
        return (string(p.dataHash), string(p.fileName), string(p.dateTime));
    }
    
}
