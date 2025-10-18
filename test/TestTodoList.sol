// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.30;

import {Test} from "forge-std/Test.sol";
import {DeployTodoList} from "../script/DeployTodoList.s.sol";
import {TodoList} from "../src/TodoList.sol";

contract TestTodoList is Test {
    TodoList todoList;
    address constant sender = address(0x1);
    string constant OLD_NAME = "HELLO";
    string constant NEW_NAME = "GOODBYE";
    uint256 constant NON_EXISTANT_TODO_ID = 1;

    function setUp() public {
        DeployTodoList deployTodoList = new DeployTodoList();
        todoList = deployTodoList.run();
    }

    function testAddTodo() public {
        TodoList.Todo memory myTodo = TodoList.Todo({taskName: OLD_NAME, complete: false});
        vm.startPrank(sender);
        todoList.addTodo(OLD_NAME);
        TodoList.Todo memory firstTodo = todoList.getTodoByID(0);
        vm.stopPrank();
        assertEq(keccak256(abi.encode(myTodo)), keccak256(abi.encode(firstTodo)));
    }

    function testUpdateTodoWithNonEmptyString() public {
        TodoList.Todo memory myTodo = TodoList.Todo({taskName: NEW_NAME, complete: true});
        vm.startPrank(sender);
        todoList.addTodo(OLD_NAME);
        todoList.updateTodo(NEW_NAME, true, 0);
        TodoList.Todo memory firstTodo = todoList.getTodoByID(0);
        vm.stopPrank();
        // Refactor
        assertEq(firstTodo.complete, true);
        assertEq(keccak256(abi.encode(myTodo)), keccak256(abi.encode(firstTodo)));
    }

    function testUpdateTodoWithEmptyString() public {
        TodoList.Todo memory myTodo = TodoList.Todo({taskName: OLD_NAME, complete: true});
        vm.startPrank(sender);
        todoList.addTodo(OLD_NAME);
        todoList.updateTodo("", true, 0);
        TodoList.Todo memory firstTodo = todoList.getTodoByID(0);
        vm.stopPrank();
        assertEq(keccak256(abi.encode(myTodo)), keccak256(abi.encode(firstTodo)));
    }

    function testDeleteTodo() public {
        vm.startPrank(sender);
        todoList.addTodo(OLD_NAME);
        TodoList.Todo[] memory beforeDeletion = todoList.getTodoList();
        todoList.addTodo(NEW_NAME);
        TodoList.Todo[] memory afterDeletion = todoList.deleteTodo(1);
        vm.stopPrank();

        assertEq(keccak256(abi.encode(beforeDeletion)), keccak256(abi.encode(afterDeletion)));
    }

    function testDeleteTodoNonExistant() public {
        vm.expectRevert();
        vm.startPrank(sender);
        todoList.deleteTodo(NON_EXISTANT_TODO_ID);
        vm.stopPrank();
    }
}
