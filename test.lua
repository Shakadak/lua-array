local OA = require "ArrayObject"
local PA = require "Array"

print("Object Array")

local function printPure(x)
    print(OA.pure(x):show())
end
local function add(x) return function(y) return x + y end end

local just = OA.pure("")
local nothing = OA.Id
local one = OA.new({1, 2})

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
local two = OA.pure(add):apply(one):apply(one)
print("two = "..two:show())
print(two:show())
print(OA.Id:apply(one):apply(one):show())
print()

local three = two:map(add(1))
print(three:show())
print(nothing:map(add(1)):show())
print()

print(OA.new({1, 2, 3, 4}):reverse():show())
print(three:filter(function(x) return x ~= 4 end):show())

print("OA.new({1, 2, 3}):filterM(function(x) return OA.new({true, false}) end)")
print(OA.new({1, 2, 3}):filterM(function(x) return OA.new({true, false}) end):show())
print("Pure Array")
print("local powerset = filterM(function(x) return {true, false} end)")
local powerset = PA.filterM(function(x) return {true, false} end)
print("powerset({1, 2, 3})")
print(PA.show(PA.map(PA.show)(powerset({1, 2, 3}))))
