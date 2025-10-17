// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {DeployTodoList} from "../script/DeployTodoList.s.sol";
import {TodoList} from "../src/TodoList.sol";

contract TestTodoList is Test {
    TodoList todoList;
    address constant sender = address(0x1);

    function setUp() public {
        DeployTodoList deployTodoList = new DeployTodoList();
        todoList = deployTodoList.run();
    }

    function testAddTodo() public {
        TodoList.Todo memory myTodo = TodoList.Todo({taskName: "Hello", complete: false});
        vm.startPrank(sender);
        todoList.addTodo("Hello");
        TodoList.Todo memory firstTodo = todoList.getTodoByID(0);
        vm.stopPrank();
        assertEq(keccak256(abi.encode(firstTodo)), keccak256(abi.encode(myTodo)));
    }
}
