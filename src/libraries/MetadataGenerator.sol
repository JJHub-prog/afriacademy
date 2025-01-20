// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/utils/Strings.sol";

/**
 * @title CertificateMetadata
 * @dev Handles IPFS metadata formatting and validation for certificates
 */
contract CertificateMetadata {
    using Strings for uint256;
    
    struct Metadata {
        string name;
        string description;
        string image;
        string externalUrl;
        address student;
        uint256 courseId;
        uint256 score;
        uint256 issueDate;
        string courseName;
    }
    
    event MetadataUpdated(string indexed ipfsHash, uint256 indexed tokenId);
    
    // IPFS content identifier prefix
    string private constant IPFS_PREFIX = "ipfs://";
    
    error InvalidIPFSHash();
    error InvalidMetadataFormat();
    
    /**
     * @dev Validates IPFS hash format
     * @param ipfsHash The IPFS hash to validate
     */
    function validateIPFSHash(string calldata ipfsHash) public pure {
        bytes memory hashBytes = bytes(ipfsHash);
        // Basic validation of IPFS hash format (starts with "ipfs://" and has minimum length)
        if (hashBytes.length < 7 || 
            hashBytes[0] != 'i' ||
            hashBytes[1] != 'p' ||
            hashBytes[2] != 'f' ||
            hashBytes[3] != 's' ||
            hashBytes[4] != ':' ||
            hashBytes[5] != '/' ||
            hashBytes[6] != '/') {
            revert InvalidIPFSHash();
        }
    }
    
    /**
     * @dev Generates metadata JSON string
     * @param metadata The metadata struct containing certificate information
     * @return string The formatted JSON metadata string
     */
    function generateMetadataJSON(Metadata calldata metadata) public pure returns (string memory) {
        return string(abi.encodePacked(
            '{',
            '"name": "', metadata.name, '",',
            '"description": "', metadata.description, '",',
            '"image": "', metadata.image, '",',
            '"external_url": "', metadata.externalUrl, '",',
            '"attributes": [',
            '{"trait_type": "Student Address", "value": "', Strings.toHexString(metadata.student), '"},',
            '{"trait_type": "Course ID", "value": "', metadata.courseId.toString(), '"},',
            '{"trait_type": "Score", "value": "', metadata.score.toString(), '"},',
            '{"trait_type": "Issue Date", "value": "', metadata.issueDate.toString(), '"},',
            '{"trait_type": "Course Name", "value": "', metadata.courseName, '"}',
            ']}'
        ));
    }
    
    /**
     * @dev Creates a complete IPFS URI with metadata
     * @param ipfsHash The IPFS hash where metadata will be stored
     * @return string The complete IPFS URI
     */
    function createIPFSUri(string calldata ipfsHash) public pure returns (string memory) {
        validateIPFSHash(ipfsHash);
        return string(abi.encodePacked(IPFS_PREFIX, ipfsHash));
    }
}