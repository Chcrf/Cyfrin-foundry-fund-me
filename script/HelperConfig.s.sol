// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    // NetworkConfig public activeNetworkConfig;

    // struct NetworkConfig {
    //     address priceFeed;
    // }
    address public activeNetwork;
    address priceFeed;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    constructor() {
        if (block.chainid == 11155111) {
            activeNetwork = getSepoliaEthConfig();
        } else {
            activeNetwork = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public returns (address) {
        // NetworkConfig memory sepoliaConfig = NetworkConfig({
        //     priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // });
        priceFeed = 0x694AA1769357215DE4FAC081bf1f309aDC325306;
        return priceFeed;
    }

    function getOrCreateAnvilEthConfig() public returns (address) {
        if (activeNetwork != address(0)) {
            return activeNetwork;
        }
        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITIAL_PRICE);
        vm.stopBroadcast();

        // NetworkConfig memory anvilConfig = NetworkConfig({priceFeed: address(mockPriceFeed)});
        priceFeed = address(mockPriceFeed);
        return priceFeed;
    }
}
