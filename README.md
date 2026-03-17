# Matrix Library for Luau

A robust and easy-to-use Matrix mathematics library for Luau. This module allows you to create, manipulate, and perform complex linear algebra operations on matrices using standard Luau mathematical operators.

Version: 1.1.0

<br>

## Features

- Overloaded Operators: Use standard mathematical operators (`+`, `-`, `*`, `/`, `%`, `^`) for matrix-matrix and matrix-scalar operations.
- Core Linear Algebra: Easily calculate determinants, adjugates, inverses, and transpositions.
- Transformations: Built-in methods for matrix rotation (90, -90, 180 degrees).
- Utility Methods: Includes string formatting, deep cloning, equality checking, and stateful iteration.

<br>

## Installation

Drop the Matrix.lua module script into your Luau/Roblox environment (e.g., ReplicatedStorage in Roblox).

```lua
local Matrix = require(path.to.Matrix)
```

<br>

## API Reference
### Constructors
- `Matrix.new(rows: number, columns: number?, defaultValue: number?)`   
Creates a new matrix with the specified dimensions. If `columns` is omitted, it creates a square matrix. Default value for all cells is 0 unless specified.
- `Matrix.identity(size: number)`   
Creates a square identity matrix of the given size (1s on the main diagonal, 0s elsewhere).
- `Matrix.fromTable(t: {{number}})`   
Wraps an existing 2D table (array of arrays) into a Matrix object.

### Operators
The module supports the following metamethods, allowing you to use standard Luau syntax:

- Unary Minus (`-mtx`): Negates all values in the matrix.
- Addition (`mtx1 + mtx2` / `mtx + scalar`): Element-wise addition.
- Subtraction (`mtx1 - mtx2` / `mtx - scalar` / `scalar - mtx`): Element-wise subtraction.
- Multiplication (`mtx1 * mtx2` / `mtx * scalar`): Performs true matrix multiplication (dot product) when multiplying two matrices. Performs element-wise multiplication for scalars.
- Division (`mtx / scalar` / `scalar / mtx`): Element-wise division.
- Modulo (`mtx % scalar` / `scalar % mtx`): Element-wise modulo.
- Power (`mtx ^ scalar` / `scalar ^ mtx`): Element-wise exponentiation.
- Equality (`mtx1 == mtx2`): Checks if dimensions and all elements are identical.
- ToString (`tostring(mtx)`): Returns a formatted, multi-line string representation of the matrix.

### Methods
- `matrix:Clone()`   
Returns a deep copy of the matrix.
- `matrix:Transpose()`   
Returns a new matrix where the rows and columns are swapped.
- `matrix:Rotate(degrees: number)`   
Rotates the matrix by the specified degrees. Valid options are 90, -90, and 180.
- `matrix:Minor(row: number, col: number)`   
Returns a new matrix with the specified row and column removed.
- `matrix:Determinant(): number`   
Calculates and returns the determinant of a square matrix. Returns 0 if the matrix is singular.
- `matrix:Adjugate()`   
Calculates and returns the adjugate (adjoint) matrix.
- `matrix:Inverse()`   
Calculates and returns the inverse matrix. Throws an error if the matrix is singular (determinant is 0).
- `matrix:Iterate()`   
Returns a stateful iterator for traversing the matrix. Yields `(row, column, value)`.
- `matrix:Destroy()`   
Clears the matrix data and removes its metatable, aiding in garbage collection.

<br>

## Example Usage
```lua
local Matrix = require(path.to.Matrix)

-- Create a 2x2 matrix
local mtxA = Matrix.fromTable({
    {4, 7},
    {2, 6}
})

-- Create an identity matrix
local mtxB = Matrix.identity(2)

-- Matrix multiplication
local result = mtxA * mtxB
print(result) 

-- Calculate determinant and inverse
print("Determinant:", mtxA:Determinant())
local inverseMtx = mtxA:Inverse()

-- Iterate through values
for r, c, val in mtxA:Iterate() do
    print(string.format("Row %d, Col %d = %d", r, c, val))
end

mtxA:Destroy()
mtxB:Destroy()
```
