local Array = require "ArrayObject"
local PA = require "Array"

local function printPure(x)
    print(Array.pure(x):show())
end
local function add(x) return function(y) return x + y end end

local just = Array.pure("")
local nothing = Array.Id
local one = Array.fromIvTable({1, 2})

print(just:show())
print(nothing:show())
printPure(nil)
printPure(just)
printPure(nothing)
printPure({})
printPure(13)
printPure(add)
print()

print("one = "..one:show())
local two = Array.pure(add):apply(one):apply(one)
print("two = "..two:show())
print(two:show())
print(Array.Id:apply(one):apply(one):show())
print()

local three = two:map(add(1))
print(three:show())
print(nothing:map(add(1)):show())
print()

print(Array.fromIvTable({1, 2, 3, 4}):reverse():show())
print(three:filter(function(x) return x ~= 4 end):show())

print("Pure Array")
print("local powerset = filterM(function(x) return {true, false} end)")
local powerset = PA.filterM(function(x) return {true, false} end)
print("powerset({1, 2, 3})")
print(PA.show(PA.map(PA.show)(powerset({1, 2, 3}))))
