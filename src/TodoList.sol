// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.30;



error TODO__DOES__NOT__EXIST();

/// @title 
/// @author 
/// @notice 
contract TodoList {

    mapping (address => Todo[]) private userToTodo;

    struct Todo {
        string taskName;
        bool complete;
    }

    
    // User adds todo
    function addTodo(string memory _task) external returns (Todo memory) {
        Todo[] storage userTodo = userToTodo[msg.sender];
        Todo memory newTodo = Todo({taskName: _task, complete: false});
        userTodo.push(newTodo);
        return newTodo;
    }
    // User modifies todo
    function updateTodo(string memory _newName, bool _newComplete, uint256 _id) external returns (Todo memory) {
        // Implement error handler
        Todo storage todo = userToTodo[msg.sender][_id];
        todo.complete = _newComplete;
        if (keccak256(abi.encode(_newName)) != keccak256(abi.encode(""))) {
            // If the new name isn't blank, change it
            todo.taskName = _newName;
        }
        return todo; 
    }

    // User deletes todo



    // View functions
    // User gets all todos

    // User gets one of their todos
    function getTodoByID(uint256 _id) external view returns (Todo memory) {

    }
}