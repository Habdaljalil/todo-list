// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.30;

/// @notice Throws if Todo does not exist
/// @dev Called if a function calls a user's Todo that is not in their Todo array(Todo[])
error TODO__DOES__NOT__EXIST();

/// @title Todo List
/// @author Hassan Abdaljalil
/// @notice Creates a list of Todos for users that allows them to add, modify, and delete todos
contract TodoList {
    /// @notice Each user gets a list of todos
    /// @dev Every address that interacts with the contract gets an array of Todos
    mapping(address => Todo[]) private userToTodo;

    /// @notice Defines a Todo to with a name and a status of complete/incomplete
    /// @dev Creates a Todo struct with a taskName of type string and complete of type boolean
    struct Todo {
        string taskName;
        bool complete;
    }

    /// @notice Checks to see if a Todo exists, given an ID
    /// @dev Wraps the _todoExists function
    /// @param _todoID is the position(in storage) in a user's Todo array
    modifier todoExists(uint256 _todoID) {
        _todoExists(_todoID);
        _;
    }

    /// @notice Function that verifies the existance of a Todo based on its ID
    /// @dev Reads the msg.sender's array in storage, then it checks to see if the ID is out of bounds
    /// @param _todoID is the position(in storage) in a user's Todo array
    function _todoExists(uint256 _todoID) internal view {
        Todo[] memory userTodo = userToTodo[msg.sender];
        if (_todoID > (userTodo.length - 1)) {
            revert TODO__DOES__NOT__EXIST();
        }
    }

    /// @notice Adds a Todo to a user's list of todos
    /// @dev Creates a new Todo struct, then pushes it to msg.sender's Todo array
    /// @param _taskName is the name of the task the use wants to make
    /// @return Todo struct created by the user
    function addTodo(string memory _taskName) external returns (Todo memory) {
        Todo[] storage userTodo = userToTodo[msg.sender];
        Todo memory newTodo = Todo({taskName: _taskName, complete: false});
        userTodo.push(newTodo);
        return newTodo;
    }

    /// @notice Modifies an existing Todo
    /// @dev Updates a Todo struct, then pushes it to msg.sender's Todo array
    /// @param _newName is the name of the new Todo; if left blank, it will not modify the name of the Todo
    /// @param _newComplete is the new complete state of the Todo
    /// @param _todoID is the position(in storage) in a msg.sender's Todo array
    /// @return Todo struct modified by the user
    function updateTodo(string memory _newName, bool _newComplete, uint256 _todoID)
        external
        todoExists(_todoID)
        returns (Todo memory)
    {
        Todo storage todo = userToTodo[msg.sender][_todoID];
        todo.complete = _newComplete;
        if (keccak256(abi.encode(_newName)) != keccak256(abi.encode(""))) {
            // If the new name isn't blank, change it
            todo.taskName = _newName;
        }
        return todo;
    }

    /// @notice Deletes a Todo
    /// @dev Removes the ID of msg.sender's Todo from their array
    /// @param _todoID is the position(in storage) in a user's Todo array
    /// @return Todo, the new array after the removal of an element
    function deleteTodo(uint256 _todoID) external todoExists(_todoID) returns (Todo[] memory) {
        Todo[] memory todoListCopy = userToTodo[msg.sender];
        uint256 todoListCopyLength = todoListCopy.length;
        clearTodo(msg.sender);
        Todo[] storage todoList = userToTodo[msg.sender];

        for (uint256 i = 0; i < todoListCopyLength; i++) {
            if (i != _todoID) {
                todoList.push(todoListCopy[i]);
            }
            // implicitly covered by tests
        }

        return todoList;
    }

    /// @notice Removes all elements from a user's Todo array
    /// @dev Loops through a user's Todo array and deletes all values
    /// @param _user is the address of the user whose Todo array will be cleared
    /// @return Todo, the cleared array
    function clearTodo(address _user) private returns (Todo[] storage) {
        Todo[] storage todoList = userToTodo[_user];
        uint256 todoLength = todoList.length;

        for (uint256 i = 0; i < todoLength; i++) {
            todoList.pop();
        }

        return todoList;
    }

    // View functions

    /// @notice Gets the user's entire Todo list
    /// @dev Finds the array of msg.sender and returns a copy
    /// @return Todo, the entire Todo array
    function getTodoList() external view returns (Todo[] memory) {
        return userToTodo[msg.sender];
    }

    /// @notice Gets one Todo from the user's Todo list
    /// @dev Gets a msg.sender's Todo array, then finds the specfic element and returns a copy
    /// @param _todoID is the position(in storage) in a user's Todo array
    /// @return Todo, one Todo element in msg.sender's array of Todos
    function getTodoByID(uint256 _todoID) external view todoExists(_todoID) returns (Todo memory) {
        return userToTodo[msg.sender][_todoID];
    }
}
