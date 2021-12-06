
-- Read an entire file.
-- Use "a" in Lua 5.3; "*a" in Lua 5.1 and 5.2
local function readall(filename)
    local fh = assert(io.open(filename, "rb"))
    local contents = assert(fh:read(_VERSION <= "Lua 5.2" and "*a" or "a"))
    fh:close()
    return contents
end

local function splitLines(inputFileText)
    local lines = {}
    for s in inputFileText:gmatch("[^\r\n]+") do
        table.insert(lines, s)
    end
    return lines
end

local lines = splitLines(readall("input.txt"))

-- PART ONE

local prevDepth = nil
local increaseCounter = 0
for _k, line in ipairs(lines) do
    local newDepth = tonumber(line)
    if prevDepth ~= nil then
        if newDepth > prevDepth then
            increaseCounter = increaseCounter + 1
        end
    end
    prevDepth = newDepth
end

print("Part One Answer")
print(increaseCounter)

-- PART TWO
local previous = nil
local secondPrevious = nil
local previousWindowSum = nil
local rollingWindowSum = 0
increaseCounter = 0
for _k, line in ipairs(lines) do
    local newDepth = tonumber(line)
    if secondPrevious ~= nil then
        rollingWindowSum = previous + secondPrevious + newDepth
        if previousWindowSum ~= nil then
            if rollingWindowSum > previousWindowSum then
                increaseCounter = increaseCounter + 1
            end
        end
        previousWindowSum = rollingWindowSum
    end
    secondPrevious = previous
    previous = newDepth
end

print("Part Two Answer")
print(increaseCounter)
