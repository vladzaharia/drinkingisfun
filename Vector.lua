
local Vector = {}


local function isnumber(v) 
	return type(v) == "number"
end

function Vector.add(v1, v2)
	if isnumber(v1) then
		v1 = Vector(v1, v1)
	elseif isnumber(v2) then
		v2 = Vector(v2, v2)
	end
	return Vector(v1.x + v2.x, v1.y + v2.y)
end

function Vector.sub(v1, v2)
	if isnumber(v1) then
		v1 = Vector(v1, v1)
	elseif isnumber(v2) then
		v2 = Vector(v2, v2)
	end
	return Vector(v1.x - v2.x, v1.y - v2.y)
end

function Vector.mul(v1, v2)
	if isnumber(v1) then
		v1 = Vector(v1, v1)
	elseif isnumber(v2) then
		v2 = Vector(v2, v2)
	end
	return Vector(v1.x * v2.x, v1.y * v2.y)
end

function Vector.div(v1, v2)
	if isnumber(v1) then
		v1 = Vector(v1, v1)
	elseif isnumber(v2) then
		v2 = Vector(v2, v2)
	end
	return Vector(v1.x / v2.x, v1.y / v2.y)
end

function Vector.neg(v)
	return Vector(-v.x, -v.y)
end

function Vector.concat(v1, v2)
	return tostring(v1) .. tostring(v2)
end

function Vector.eq(v1, v2)
	return v1.x == v2.x and v1.y == v2.y
end

-- This function can't be named "tostring" or it'll shadow the the global one
function Vector.tostringvec(v)
	return v.x .. "," .. v.y
end

function Vector.new(self, x,y)
	assert(isnumber(x))
	assert(isnumber(y))
	local vec = {x=x,y=y}
	setmetatable(vec, Vector.mt)
	return vec
end

Vector.mt = {
	__add = Vector.add,
	__sub = Vector.sub,
	__mul = Vector.mul,
	__div = Vector.div,
	__unm = Vector.neg,
	__concat = Vector.concat,
	__eq = Vector.eq,
	__tostring = Vector.tostringvec
}

-- This allows us to call Vector as a function rather than use Vector.new()
local t = getmetatable(Vector) or {}
t.__call = Vector.new
setmetatable(Vector, t)


return Vector