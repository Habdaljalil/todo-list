// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.30;

import {Script} from "forge-std/Script.sol";
import {TodoList} from "../src/TodoList.sol";

contract DeployTodoList is Script {
    TodoList todoList;

    function run() public returns (TodoList) {
        vm.startBroadcast();
        todoList = new TodoList();
        vm.stopBroadcast();
        return todoList;
    }
}
