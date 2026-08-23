-- Statech / CC:Tweaked Peripheral Scanner
-- Run with: scan
-- This only inspects peripherals; it does not modify machines.

local function typeText(name)
    local types = { peripheral.getType(name) }
    if #types == 0 then return "unknown" end
    return table.concat(types, ", ")
end

local function safeMethods(name)
    local ok, methods = pcall(peripheral.getMethods, name)
    if ok and methods then
        table.sort(methods)
        return methods
    end
    return {}
end

local names = peripheral.getNames()
table.sort(names)

local file = fs.open("peripheral_scan.txt", "w")
file.writeLine("STATECH INDUSTRIES - CC:TWEAKED PERIPHERAL SCAN")
file.writeLine("Peripherals found: " .. #names)
file.writeLine("")

print("Found " .. #names .. " peripheral(s).")
print("")

for _, name in ipairs(names) do
    local types = typeText(name)
    local methods = safeMethods(name)

    print("[" .. name .. "]")
    print("  Type: " .. types)

    file.writeLine("===============================================")
    file.writeLine("NAME: " .. name)
    file.writeLine("TYPE: " .. types)
    file.writeLine("METHODS:")

    if #methods == 0 then
        file.writeLine("  (none / unavailable)")
    else
        for _, method in ipairs(methods) do
            print("  " .. method)
            file.writeLine("  " .. method)
        end
    end
    file.writeLine("")
end

file.close()
print("")
print("Full report saved as peripheral_scan.txt")
