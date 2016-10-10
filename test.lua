local Array = require "ArrayObject"

local function printPure(x)
    print(Array.pure(x):show())
end
local function add(x) return function(y) return x + y end end

local just = Array.pure("")
local nothing = Array.Id
local one = Array.pure(1)

print(just:show())
print(nothing:show())
printPure(nil)
printPure(just)
printPure(nothing)
printPure({})
printPure(13)
printPure(add)
print()

local two = Array.pure(add):apply(one):apply(one)
print(two:show())
print(Array.Id:apply(one):apply(one):show())
print()

local three = two:map(add(1))
print(three:show())
print(nothing:map(add(1)):show())
print()
