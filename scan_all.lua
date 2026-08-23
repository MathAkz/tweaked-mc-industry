-- STATECH INDUSTRIES - Machine Scanner
-- Run: scan_all
-- This checks the exact machine IDs used by dashboard.lua.

local ids = {
    "ae2:charger_0",
    "ae2:controller_0",
    "ae2:drive_0",
    "modern_industrialization:laser_engraver_0",
    "modern_industrialization:electric_wiremill_0",
    "modern_industrialization:electric_mixer_0",
    "modern_industrialization:electric_cutting_machine_0",
    "modern_industrialization:electric_compressor_0",
    "modern_industrialization:chemical_reactor_0",
    "modern_industrialization:assembler_0",
    "modern_industrialization:polarizer_0",
    "extended_industrialization:electric_bending_machine_0",
    "extended_industrialization:electric_alloy_smelter_0",
}

for _, id in ipairs(ids) do
    print("========================================")
    print(id)

    if peripheral.isPresent(id) then
        print("FOUND")
        print("TYPE: " .. table.concat({peripheral.getType(id)}, ", "))

        local methods = peripheral.getMethods(id) or {}
        table.sort(methods)

        print("METHODS:")
        for _, method in ipairs(methods) do
            print("  " .. method)
        end
    else
        print("NOT FOUND")
    end
end
