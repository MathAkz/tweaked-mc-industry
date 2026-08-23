-- AE2 peripheral test
-- Run with: ae2test

local ids = {
    "ae2:charger_0",
    "ae2:controller_0",
    "ae2:drive_0",
}

for _, id in ipairs(ids) do
    print("================================")
    print(id)

    if not peripheral.isPresent(id) then
        print("NOT FOUND")
    else
        print("FOUND")
        print("Type: " .. table.concat({ peripheral.getType(id) }, ", "))

        local methods = peripheral.getMethods(id) or {}
        table.sort(methods)

        print("Methods:")
        for _, method in ipairs(methods) do
            print("  " .. method)
        end
    end
end
