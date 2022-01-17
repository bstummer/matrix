--[[

Matrix library in Luau

Version of this module: 1.0.0

Created by Vaschex
This is composed of functions from other libraries, mostly in other languages

- When using arithmetic operators with a matrix and a number, the number
has to be on the right

]]

local function deepCopy(t)
	local copy = {}
	for k, v in next, t do
		if type(v) == "table" then
			v = deepCopy(v)
		end
		copy[k] = v
	end
	return copy
end

local function round(n:number, places:number):number
	places = 10 ^ places
	n *= places
	if n >= 0 then 
		n = math.floor(n + 0.5) 
	else 
		n = math.ceil(n - 0.5) 
	end
	return n / places
end

local module = {}

local matrix = {}
matrix.__index = matrix
matrix.__unm = function(mtx)
	return -1 * mtx
end
matrix.__add = function(first, second)
	if type(second) == "number" then
		for i = 1, #first do
			for j = 1, #first[1] do
				first[i][j] += second
			end
		end
		return first
	else --second can be larger than first
		for i = 1, #first do
			for j = 1, #first[1] do
				first[i][j] += second[i][j]
			end
		end
		return first
	end
end
matrix.__sub = function(first, second)
	if type(second) == "number" then
		for i = 1, #first do
			for j = 1, #first[1] do
				first[i][j] -= second
			end
		end
		return first
	else
		for i = 1, #first do
			for j = 1, #first[1] do
				first[i][j] -= second[i][j]
			end
		end
		return first
	end
end
matrix.__mul = function(first, second)
	if type(second) == "number" then
		for i = 1, #first do
			for j = 1, #first[1] do
				first[i][j] *= second
			end
		end
		return first
	else
		for i = 1, #first do
			for j = 1, #first[1] do
				first[i][j] *= second[i][j]
			end
		end
		return first
	end
end
matrix.__div = function(first, second)
	if type(second) == "number" then
		for i = 1, #first do
			for j = 1, #first[1] do
				first[i][j] /= second
			end
		end
		return first
	else
		for i = 1, #first do
			for j = 1, #first[1] do
				first[i][j] /= second[i][j]
			end
		end
		return first
	end
end
matrix.__mod = function(first, second)
	if type(second) == "number" then
		for i = 1, #first do
			for j = 1, #first[1] do
				first[i][j] %= second
			end
		end
		return first
	else
		for i = 1, #first do
			for j = 1, #first[1] do
				first[i][j] %= second[i][j]
			end
		end
		return first
	end
end
matrix.__pow = function(first, second)
	if type(second) == "number" then
		for i = 1, #first do
			for j = 1, #first[1] do
				first[i][j] ^= second
			end
		end
		return first
	else
		for i = 1, #first do
			for j = 1, #first[1] do
				first[i][j] ^= second[i][j]
			end
		end
		return first
	end
end
matrix.__tostring = function(mtx)
	local result = "\n{"
	for i, v in ipairs(mtx) do
		result ..= "{"
		for i2, v2 in ipairs(v) do
			if i2 ~= #v then
				result ..= v2 .. ","
			else
				result ..= v2
			end
		end
		if i ~= #mtx then
			result ..= "},\n"
		else
			result ..= "}"
		end
	end
	result ..= "}"
	return result
end
--[[function matrix:List() --only for testing with py, js, etc.
	local result = ""
	result ..= "\n["
	for i, v in ipairs(self) do
		result ..= "["
		for i2, v2 in ipairs(v) do
			if i2 ~= #v then
				result ..= v2 .. ","
			else
				result ..= v2
			end
		end
		if i ~= #self then
			result ..= "],\n"
		else
			result ..= "]"
		end
	end
	result ..= "]"
	return result
end]]
--eq, lt and le only get invoked when having the same metatable and type
matrix.__eq = function(first, second)
	if #first ~= #second or #first[1] ~= #second[1] then
		return false
	end
	for i = 1, #first do
		for j = 1, #first[1] do
			if first[i][j] ~= second[i][j] then
				return false
			end
		end
	end
	return true
end
--matrix.__lt = function(first, second)
--end
--matrix.__le = function(first, second)	
--end

function module.new(rows:number, columns:number?, defaultValue:number?)
	local mtx = {}
	defaultValue = defaultValue or 0
	for r = 1, rows do
		table.insert(mtx, {})
		for c = 1, columns or rows do
			mtx[r][c] = defaultValue
		end
	end
	return setmetatable(mtx, matrix)
end

function module.identity(size:number)
	local mtx = {}
	for r = 1, size do
		table.insert(mtx, {})
		for c = 1, size do
			if r == c then
				mtx[r][c] = 1
			else
				mtx[r][c] = 0
			end
		end
	end
	return setmetatable(mtx, matrix)
end

function module.fromTable(t:{{number}})
	return setmetatable(t, matrix)
end

function matrix:Clone()
	local mtx = {}
	for _, v in ipairs(self) do
		table.insert(mtx, {unpack(v)})
	end
	return setmetatable(mtx, matrix)
end

function matrix:Transpose()
	local mtx = {}
	for i = 1, #self[1] do
		table.insert(mtx, {})
		for j = 1, #self do
			mtx[i][j] = self[j][i]
		end
	end
	return setmetatable(mtx, matrix)
end

function matrix:Rotate(degrees:number)
	local height, width = #self, #self[1]
	local mtx = {}
	if degrees == 90 then
		for _ = 1, width do
			table.insert(mtx, {})
		end
		for i = 1, height do
			for j = 1, width do
				mtx[j][height - i + 1] = self[i][j]
			end
		end
	elseif degrees == -90 then
		for _ = 1, width do
			table.insert(mtx, {})
		end
		for i = 1, height do
			for j = 1, width do
				mtx[width - j + 1][i] = self[i][j]
			end
		end
	elseif degrees == 180 then
		for _ = 1, height do
			table.insert(mtx, {})
		end
		for i = 1, height do
			for j = 1, width do
				mtx[height - i + 1][height - j + 1] = self[i][j]
			end
		end
	else
		error("Invalid degrees, the options are 90, -90, 180")
	end
	return setmetatable(mtx, matrix)
end

function matrix:Minor(row:number, col:number)
	local height, width = #self, #self[1]
	if not (0 <= row and 0 < height) then
		error("row should be between 0 and ".. height)
	elseif not (0 <= col and 0 < width) then
		error("col should be between 0 and ".. width)
	end
	local result = {}
	for r = 1, height do
		if r == row then
			continue
		end
		local row = {}
		table.insert(result, row)
		for c = 1, width do
			if c == col then
				continue
			end
			table.insert(row, self[r][c])
		end
	end
	return setmetatable(result, matrix)
end

function matrix:Determinant():number
	local height, width = #self, #self[1]
	if height ~= width then
		error("Matrix must be square")
	end
	local tmp, rv = deepCopy(self), 1
	for c = width, 2, -1 do
		local pivot = -1
		local r = 1
		for i = 1, c do
			if math.abs(tmp[i][c]) > pivot then
				pivot = math.abs(tmp[i][c])
				r = i
			end
		end
		pivot = tmp[r][c]
		if not pivot then
			return 0
		end
		tmp[r], tmp[c] = tmp[c], tmp[r]
		if r ~= c then
			rv = -rv
		end
		rv *= pivot
		local fact = -1 / pivot
		for r = 1, c-1 do
			local f = fact * tmp[r][c]
			for x = 1, c-1 do
				tmp[r][x] += f * tmp[c][x]
			end
		end
	end
	return round(rv * tmp[1][1], 8) --floating point errors
end

--stateful iterator
function matrix:Iterate()
	local height, width, r, c = #self, #self[1], 1, 0
	return function()
		c += 1
		if c > width then
			r, c = r + 1, 1
		end
		if r <= height then
			return r, c
		end
	end
end

function matrix:Adjugate()
	local height, width = #self, #self[1]
	if height == 2 then
		local a, b = self[1][1], self[1][2]
		local c, d = self[2][1], self[2][2]
		return setmetatable({{d, -b}, {-c, a}}, matrix)
	end
	local mtx = {}
	for r = 1, height do
		table.insert(mtx, {})
		for c = 1, width do
			local sign
			if (r + c) % 2 == 0 then
				sign = 1
			else
				sign = -1
			end
			mtx[r][c] = self:Minor(r, c):Determinant() * sign
		end
	end
	return setmetatable(mtx, matrix)
end

function matrix:Inverse()
	return self:Adjugate() * (1 / self:Determinant())
end

function matrix:Destroy()
	table.clear(self)
	setmetatable(self, nil)
end

return module