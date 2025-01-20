// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Script.sol";
import "../src/contracts/AfriacademyRegistry.sol";
import "../src/contracts/AfriacademyCertificate.sol";

contract DeployAfriacademy is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // Deploy Registry
        AfriacademyRegistry registry = new AfriacademyRegistry();

        // Deploy Certificate with Registry address
        AfriacademyCertificate certificate = new AfriacademyCertificate(
            "Afriacademy Certificate",
            "AFRI",
            address(registry)
        );

        vm.stopBroadcast();
    }
}
