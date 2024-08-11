// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {FundMe} from "../../src/FundMe.sol";
import {DeployFundMe} from "../../script/DeployFundMe.s.sol";

contract FundMeTest is Test {
    uint256 constant STARTING_BALANCE = 10 ether;
    uint256 constant SEND_VALUE = 0.1 ether;
    uint256 constant MIN_USD_ETH = 5e18;
    address USER = makeAddr("mock");

    FundMe private fundMe;

    function setUp() external {
        DeployFundMe deployFundMe = new DeployFundMe();
        fundMe = deployFundMe.run();
        vm.deal(USER, STARTING_BALANCE);
    }

    modifier funded() {
        vm.prank(USER);
        fundMe.fund{value: SEND_VALUE}();
        _;
    }

    modifier testIsOwner() {
        assertEq(fundMe.getOwner(), msg.sender);
        _;
    }

    function testMinimumUsd() public view {
        assertEq(fundMe.MINIMUM_USD(), MIN_USD_ETH);
    }

    function testGetVersion() public view {
        uint256 v = fundMe.getVersion();
        assertEq(v, 4);
    }

    function testSendEnoughEth() public {
        fundMe.fund{value: 6e18 wei}();
        assertEq(address(fundMe).balance, 6 ether);
    }

    function testFundFailsWithoutEnoughEth() public {
        vm.expectRevert();
        fundMe.fund();
    }

    function testFundSendUpdatesFundedList() public funded {
        uint256 amountFunded = fundMe.getAddressToAmountFunded(USER);
        assertEq(amountFunded, SEND_VALUE);
    }

    function testOnlyOwnerCanWithdraw() public funded {
        vm.prank(USER);
        vm.expectRevert();
        fundMe.withdraw();
    }

    function testWithdrawWithASingleFunder() public testIsOwner funded {
        uint256 ownerCurrentBalance = fundMe.getOwner().balance;
        uint256 fundMeCurrentBalance = address(fundMe).balance;

        uint256 expectedOwnerAmountAfterWithdraw = ownerCurrentBalance +
            fundMeCurrentBalance;

        vm.prank(fundMe.getOwner());
        fundMe.withdraw();

        uint256 ownerWithdrawBalance = fundMe.getOwner().balance;
        uint256 fundMeWithdrawBalance = address(fundMe).balance;

        assertEq(ownerWithdrawBalance, expectedOwnerAmountAfterWithdraw);
        assertEq(fundMeWithdrawBalance, 0);
    }

    function testWithdrawWithMultiplyFunders() public {
        uint160 numberOfFunders = 10;
        // uint160 startIndex = 1;

        for (uint160 index = 1; index < numberOfFunders; index++) {
            hoax(address(index), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 ownerCurrentBalance = fundMe.getOwner().balance;
        uint256 fundMeCurrentBalance = address(fundMe).balance;

        uint256 expectedOwnerAmountAfterWithdraw = ownerCurrentBalance +
            fundMeCurrentBalance;

        vm.prank(fundMe.getOwner());

        fundMe.withdraw();

        uint256 ownerWithdrawBalance = fundMe.getOwner().balance;
        uint256 fundMeWithdrawBalance = address(fundMe).balance;

        assertEq(ownerWithdrawBalance, expectedOwnerAmountAfterWithdraw);
        assertEq(fundMeWithdrawBalance, 0);
    }

    function testCheaperWithdrawWithASingleFunder() public testIsOwner funded {
        uint256 ownerCurrentBalance = fundMe.getOwner().balance;
        uint256 fundMeCurrentBalance = address(fundMe).balance;

        uint256 expectedOwnerAmountAfterWithdraw = ownerCurrentBalance +
            fundMeCurrentBalance;

        vm.prank(fundMe.getOwner());
        fundMe.cheaperWithdraw();

        uint256 ownerWithdrawBalance = fundMe.getOwner().balance;
        uint256 fundMeWithdrawBalance = address(fundMe).balance;

        assertEq(ownerWithdrawBalance, expectedOwnerAmountAfterWithdraw);
        assertEq(fundMeWithdrawBalance, 0);
    }

    function testCheaperWithdrawWithMultiplyFunders() public {
        uint160 numberOfFunders = 10;
        for (uint160 index = 1; index < numberOfFunders; index++) {
            hoax(address(index), SEND_VALUE);
            fundMe.fund{value: SEND_VALUE}();
        }

        uint256 ownerCurrentBalance = fundMe.getOwner().balance;
        uint256 fundMeCurrentBalance = address(fundMe).balance;

        uint256 expectedOwnerAmountAfterWithdraw = ownerCurrentBalance +
            fundMeCurrentBalance;

        vm.prank(fundMe.getOwner());

        fundMe.cheaperWithdraw();

        uint256 ownerWithdrawBalance = fundMe.getOwner().balance;
        uint256 fundMeWithdrawBalance = address(fundMe).balance;

        assertEq(ownerWithdrawBalance, expectedOwnerAmountAfterWithdraw);
        assertEq(fundMeWithdrawBalance, 0);
    }
}
