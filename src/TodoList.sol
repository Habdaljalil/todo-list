// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.30;

error TODO__DOES__NOT__EXIST();
error TODO__LIST__DOES__NOT__EXIST();

/// @title
/// @author
/// @notice
contract TodoList {
    mapping(address => Todo[]) private userToTodo;

    struct Todo {
        string taskName;
        bool complete;
    }

    modifier todoExists(uint256 _todoID) {
        Todo[] memory userTodo = userToTodo[msg.sender];
        if (_todoID > (userTodo.length)) {
            revert TODO__DOES__NOT__EXIST();
        } else {
            _;
        }
    }

    modifier todoListExists(address _user) {
        if (!(userToTodo[_user].length >= 0)) {
            revert TODO__LIST__DOES__NOT__EXIST();
        } else {
            _;
        }
    }

    // User adds todo
    function addTodo(string memory _taskName) external returns (Todo memory) {
        Todo[] storage userTodo = userToTodo[msg.sender];
        Todo memory newTodo = Todo({taskName: _taskName, complete: false});
        userTodo.push(newTodo);
        return newTodo;
    }

    // User modifies todo
    function updateTodo(
        string memory _newName,
        bool _newComplete,
        uint256 _todoID
    ) external todoListExists(msg.sender) todoExists(_todoID) returns (Todo memory) {
        Todo storage todo = userToTodo[msg.sender][_todoID];
        todo.complete = _newComplete;
        if (keccak256(abi.encode(_newName)) != keccak256(abi.encode(""))) {
            // If the new name isn't blank, change it
            todo.taskName = _newName;
        }
        return todo;
    }

    // User deletes todo
    function deleteTodo(
        uint256 _todoID
    ) external todoListExists(msg.sender) todoExists(_todoID) returns (Todo[] memory) {
        Todo[] memory todoListCopy = userToTodo[msg.sender];
        uint256 todoListCopyLength = todoListCopy.length;
        clearTodo(msg.sender);
        Todo[] storage todoList = userToTodo[msg.sender];

        for (uint i = 0; i < todoListCopyLength; i++) {
            if (i != _todoID) {
                todoList.push(todoListCopy[i]);
            }
        }

        return todoList;
    }

    function clearTodo(address _user) private todoListExists(_user) returns (Todo[] storage) {
        Todo[] storage todoList = userToTodo[msg.sender];
        uint256 todoLength = todoList.length;

        for (uint i = 0; i < todoLength; i++) {
            todoList.pop();
        }

        return todoList;
    }

    function createToDoList() external returns (Todo[] memory) {
        
    }

    // View functions
    // User gets all todos

    function getTodoList() external view todoListExists(msg.sender) returns(Todo[] memory) {

    }

    // User gets one of their todos
    function getTodoByID(uint256 _todoID) external view todoListExists(msg.sender) todoExists(_todoID) returns (Todo memory) {

    }
}
