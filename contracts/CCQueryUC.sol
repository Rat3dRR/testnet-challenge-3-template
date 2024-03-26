//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.9;

import "./base/UniversalChanIbcApp.sol";
import "@openzeppelin/contracts/utils/Strings.sol";

contract CCQueryMintUC is UniversalChanIbcApp {
    constructor(address _middleware) UniversalChanIbcApp(_middleware) {}

    /**
     * @dev Packet lifecycle callback that implements packet receipt logic and returns and acknowledgement packet.
     *      MUST be overriden by the inheriting contract.
     *
     * @param channelId the ID of the channel (locally) the packet was received on.
     * @param packet the Universal packet encoded by the source and relayed by the relayer.
     */
    function onRecvUniversalPacket(bytes32 channelId, UniversalPacket calldata packet)
        external
        override
        onlyIbcMw
        returns (AckPacket memory ackPacket)
    {
        (address _caller, string memory _query) = abi.decode(packet.appData, (address, string));
        if (keccak256(bytes(_query)) == keccak256(bytes("crossChainQueryMint"))) {
            return AckPacket(true, abi.encode(_caller, "mint"));
        }
    }
}
