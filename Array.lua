local Array = {}

local function show(xs)
    local ret = "["
    for n, x in ipairs(xs) do
        if n ~= 1 then ret = ret .. ", " end
        if type(x) == "nil"
            then ret = ret .. "Nil"
        elseif type(x) == "string"
            then ret = ret .. "\""..x.."\""
        elseif type(x) == "function"
            then ret = ret .. "Function"
        elseif type(x) == "number"
            then ret = ret .. x
        elseif type(x) == "userdata"
            then ret = ret .. "Userdata"
        elseif type(x) == "thread"
            then ret = ret .. "Thread"
        elseif type(x) == "table"
            then if type(x.show) == "function"
                 then ret = ret .. "("..x:show()..")"
                 else ret = ret .. "Table"
            end
        elseif type(x) == "boolean"
            then if x
                 then ret = ret .. "True"
                 else ret = ret .. "False"
            end
        end
    end
    ret = ret .. "]"
	return ret
end

local function dot(xs)
    return function(ys)
        local zs = {}
        for _, x in ipairs(self.xs) do
            table.insert(zs, x)
        end
        for _, y in ipairs(ys) do
            table.insert(zs, y)
        end
        return zs
    end
end

local function map(f)
    return function(xs)
	    local ys = {}
	    for _, x in ipairs(xs) do
		    table.insert(ys, f(x))
	    end
	    return ys
    end
end

local function apply(fs)
    return function(xs)
	    local ys = {}
	    for _, f in ipairs(fs) do
		    for _, x in ipairs(xs.xs) do
			    table.insert(ys, f(x))
		    end
	    end
	    return ys
    end
end

local function bind(xs)
    return function(f)
        local ys = {}
        for _, x in ipairs(xs) do
            for _, y in ipairs(f(x)) do
                table.insert(ys, y)
            end
        end
        return ys
    end
end

local function join(xss)
    local ys = {}
    for _, xs in ipairs(xss) do
        for _, x in ipairs(xs) do
            table.insert(ys, x)
        end
    end
    return ys
end

local function head(xs)
    return xs[1]
end

local function last(xs)
    return xs[#xs]
end

local function tail(xs)
    local ys = {}
    for n, x in ipairs(xs) do
        if n ~= 1 then table.insert(ys) end
    end
    return ys
end

local function null(xs)
    return #xs == 0
end

local function length(xs)
    return #xs
end

local function reverse(xs)
    local ys = {}
    for i = #xs, 0, -1 do
        table.insert(ys, xs[i])
    end
    return ys
end

local function filter(p)
    return function(xs)
        local ys = {}
        for _, x in ipairs(xs) do
            if p(x) then table.insert(ys, x) end
        end
        return ys
    end
end

local function partition(p)
    return function(xs)
        local ys, zs = {}, {}
        for _, x in xs do
            if p(x)
            then table.insert(ys, x)
            else table.insert(zs, x)
            end
        end
        return ys, zs
    end
end

local function foldl(self, f)
end

local function pure(x)
    return {x}
end

local function empty()
	return {}
end

return {
    dot = dot,
    append = dot,
    map = map,
    apply = apply,
    bind = bind,
    join = join,
    concat = join,
    show = show,
    head = head,
    last = last,
    tail = tail,
    null = null,
    length = length,
    reverse = reverse,
    filter = filter,
    partition = partition,
}
