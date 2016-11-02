local Array = {}

local function show(self)
    local ret = "["
    for n, x in ipairs(self.xs) do
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
                 then ret = ret .. x:show()
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

local function dot(self, ys)
    local zs = {}
    for _, x in ipairs(self.xs) do
        table.insert(zs, x)
    end
    for _, y in ipairs(ys.xs) do
        table.insert(zs, y)
    end
    return Array.new(zs)
end

local function map(self, f)
	local ys = {}
	for _, x in ipairs(self.xs) do
		table.insert(ys, f(x))
	end
	return Array.new(ys)
end

local function apply(self, xs)
	local ys = {}
	for _, f in ipairs(self.xs) do
		for _, x in ipairs(xs.xs) do
			table.insert(ys, f(x))
		end
	end
	return Array.new(ys)
end

local function liftA(self, f)
    return Array.pure(f):apply(self)
end

local function liftA2(self, f)
    return function(ys)
        return self:map(f):apply(ys)
    end
end

local function liftA3(self, f)
    return function(ys)
        return function(zs)
            return self:map(f):apply(ys):apply(zs)
        end
    end
end

local function bind(self, f)
    local ys = {}
    for _, x in ipairs(self.xs) do
        for _, y in ipairs(f(x).xs) do
            table.insert(ys, y)
        end
    end
    return Array.new(ys)
end

local function join(xss)
    local ys = {}
    for _, xs in ipairs(xss.xs) do
        for _, x in ipairs(xs.xs) do
            table.insert(ys, x)
        end
    end
    return Array.new(ys)
end

local function head(self)
    return self.xs[1]
end

local function last(self)
    return self.xs[#self.xs]
end

local function tail(self)
    local xs = {}
    for n, x in ipairs(self.xs) do
        if n ~= 1 then table.insert(xs, x) end
    end
    return Array.new(xs)
end

local function null(self)
    return #self.xs == 0
end

local function length(self)
    return #self.xs
end

local function reverse(self)
    local xs = {}
    for i = #self.xs, 0, -1 do
        table.insert(xs, self.xs[i])
    end
    return Array.new(xs)
end

local function filter(self, p)
    local xs = {}
    for _, x in ipairs(self.xs) do
        if p(x) then table.insert(xs, x) end
    end
    return Array.new(xs)
end

local function partition(self, p)
    local xs, ys = {}, {}
    for _, x in ipairs(self.xs) do
        if p(x)
        then table.insert(xs, x)
        else table.insert(ys, x)
        end
    end
    return new(xs), new(ys)
end

local function iter(self, f)
	for _, x in ipairs(self.xs) do
		f(x)
	end
end

local function foldl(self, f)
    return function(acc)
        for _, x in ipairs(self.xs) do
            acc = f(acc)(x)
        end
        return acc
    end
end

local function foldr(self, f)
    return function(acc)
        local xs = self.xs
        for i = #xs, 1, -1 do
            acc = f(xs[i])(acc)
        end
        return acc
    end
end

local function filterM(self, p)
    return self:foldr(function(x) 
        return p(x):liftA2(function(flg)
            if flg
                then return function(xs) return Array.pure(x):dot(xs) end
                else return function(xs) return Array.Empty():dot(xs) end
            end
        end)
    end)(Array.pure(Array.Empty()))
end

Array.new = function(xs)
    return {
        xs = xs,
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
		iter = iter,
        foldr = foldr,
        foldl = foldl,
        liftA = liftA,
        liftA2 = liftA2,
        liftA3 = liftA3,
        filterM = filterM,
    }
end

Array.pure = function(x)
    return Array.new({x})
end

Array.singleton = Array.pure

Array.Empty = function()
	return Array.new({})
end

Array.Id = Array.new({})

return Array
