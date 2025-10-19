# TodoList
[Git Source](https://github.com/Habdaljalil/todo-list/blob/f2195e79a40968e09ed7e7c30e18bb1dfef668ae/src/TodoList.sol)

**Author:**
Hassan Abdaljalil

Creates a list of Todos for users that allows them to add, modify, and delete todos


## State Variables
### userToTodo
Each user gets a list of todos

Every address that interacts with the contract gets an array of Todos


```solidity
mapping(address => Todo[]) private userToTodo
```


## Functions
### todoExists

Checks to see if a Todo exists, given an ID

Wraps the _todoExists function


```solidity
modifier todoExists(uint256 _todoID) ;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_todoID`|`uint256`|is the position(in storage) in a user's Todo array|


### _todoExists

Function that verifies the existance of a Todo based on its ID

Reads the msg.sender's array in storage, then it checks to see if the ID is out of bounds


```solidity
function _todoExists(uint256 _todoID) internal view;
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_todoID`|`uint256`|is the position(in storage) in a user's Todo array|


### addTodo

Adds a Todo to a user's list of todos

Creates a new Todo struct, then pushes it to msg.sender's Todo array


```solidity
function addTodo(string memory _taskName) external returns (Todo memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_taskName`|`string`|is the name of the task the use wants to make|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`Todo`|Todo struct created by the user|


### updateTodo

Modifies an existing Todo

Updates a Todo struct, then pushes it to msg.sender's Todo array


```solidity
function updateTodo(string memory _newName, bool _newComplete, uint256 _todoID)
    external
    todoExists(_todoID)
    returns (Todo memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_newName`|`string`|is the name of the new Todo; if left blank, it will not modify the name of the Todo|
|`_newComplete`|`bool`|is the new complete state of the Todo|
|`_todoID`|`uint256`|is the position(in storage) in a msg.sender's Todo array|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`Todo`|Todo struct modified by the user|


### deleteTodo

Deletes a Todo

Removes the ID of msg.sender's Todo from their array


```solidity
function deleteTodo(uint256 _todoID) external todoExists(_todoID) returns (Todo[] memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_todoID`|`uint256`|is the position(in storage) in a user's Todo array|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`Todo[]`|Todo, the new array after the removal of an element|


### clearTodo

Removes all elements from a user's Todo array

Loops through a user's Todo array and deletes all values


```solidity
function clearTodo(address _user) private returns (Todo[] storage);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_user`|`address`|is the address of the user whose Todo array will be cleared|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`Todo[]`|Todo, the cleared array|


### getTodoList

Gets the user's entire Todo list

Finds the array of msg.sender and returns a copy


```solidity
function getTodoList() external view returns (Todo[] memory);
```
**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`Todo[]`|Todo, the entire Todo array|


### getTodoByID

Gets one Todo from the user's Todo list

Gets a msg.sender's Todo array, then finds the specfic element and returns a copy


```solidity
function getTodoByID(uint256 _todoID) external view todoExists(_todoID) returns (Todo memory);
```
**Parameters**

|Name|Type|Description|
|----|----|-----------|
|`_todoID`|`uint256`|is the position(in storage) in a user's Todo array|

**Returns**

|Name|Type|Description|
|----|----|-----------|
|`<none>`|`Todo`|Todo, one Todo element in msg.sender's array of Todos|


## Structs
### Todo
Defines a Todo to with a name and a status of complete/incomplete

Creates a Todo struct with a taskName of type string and complete of type boolean


```solidity
struct Todo {
    string taskName;
    bool complete;
}
```