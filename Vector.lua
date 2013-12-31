module("Vector", package.seeall)


function Vector.add(v1, v2)
	return {v1.x + v2.x, v1.y + v2.y}
end

function Vector.sub(v1, v2)
	return {v1.x - v2.x, v1.y - v2.y}
end

function Vector.mul(v1, v2)
	return {v1.x * v2.x, v1.y * v2.y}
end

function Vector.div(v1, v2)
	return {v1.x / v2.x, v1.y / v2.y}
end

function Vector.neg(v)
	return {-v.x, -v.y}
end

function Vector.eq(v1, v2)
	return v1.x == v2.x and v1.y == v2.y
end

function Vector.tostring(v)
	return v.x .. "," .. v.y
end



local meta = {
	__add = Vector.add,
	__sub = Vector.sub,
	__mul = Vector.mul,
	__div = Vector.div,
	__unm = Vector.neg,
	__eq = Vector.eq
}

function Vector.new(x,y)
	local vec = {x,y}
	setmetatable(vec, meta)
	return vec
end

