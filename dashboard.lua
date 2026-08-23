-- STATECH INDUSTRIES - Full Machine Dashboard
-- CC:Tweaked Lua
-- Run: dashboard
--
-- Based on the peripherals you showed in your scanner screenshots.
-- This dashboard is READ-ONLY: it does not push/pull items or fluids.

local monitor = peripheral.find("monitor")

if not monitor then
    print("No monitor found.")
    return
end

monitor.setTextScale(1)
monitor.setBackgroundColor(colors.black)

-- Exact peripheral IDs/types shown in your screenshots.
local devices = {
    { id = "ae2:charger_0",                  name = "AE2 CHARGER",            kind = "energy" },
    { id = "ae2:controller_0",               name = "AE2 CONTROLLER",         kind = "energy" },
    { id = "ae2:drive_0",                    name = "AE2 DRIVE",              kind = "inventory" },

    { id = "modern_industrialization:laser_engraver_0",     name = "LASER ENGRAVER",       kind = "inventory" },
    { id = "modern_industrialization:electric_wiremill_0",  name = "ELECTRIC WIREMILL",    kind = "inventory" },
    { id = "modern_industrialization:electric_mixer_0",     name = "ELECTRIC MIXER",       kind = "inventory" },
    { id = "modern_industrialization:electric_cutting_machine_0", name = "ELECTRIC CUTTING MACHINE", kind = "fluid_inventory" },
    { id = "modern_industrialization:electric_compressor_0", name = "ELECTRIC COMPRESSOR",  kind = "inventory" },
    { id = "modern_industrialization:chemical_reactor_0",   name = "CHEMICAL REACTOR",     kind = "fluid_inventory" },
    { id = "modern_industrialization:assembler_0",          name = "ASSEMBLER",            kind = "fluid_inventory" },
    { id = "modern_industrialization:polarizer_0",          name = "POLARIZER",            kind = "inventory" },

    { id = "extended_industrialization:electric_bending_machine_0", name = "ELECTRIC BENDING MACHINE", kind = "inventory" },
    { id = "extended_industrialization:electric_alloy_smelter_0",   name = "ELECTRIC ALLOY SMELTER",   kind = "inventory" },
}

local function present(id)
    return peripheral.isPresent(id)
end

local function call(id, method, ...)
    local ok, result = pcall(peripheral.call, id, method, ...)
    if ok then
        return true, result
    end
    return false, nil
end

local function itemCount(id)
    local ok, items = call(id, "list")
    if not ok or type(items) ~= "table" then
        return nil
    end

    local occupied = 0
    local total = 0

    for _, stack in pairs(items) do
        occupied = occupied + 1
        if type(stack) == "table" and type(stack.count) == "number" then
            total = total + stack.count
        end
    end

    local okSize, size = call(id, "size")
    return occupied, total, (okSize and size or nil)
end

local function tankCount(id)
    local ok, tanks = call(id, "tanks")
    if not ok or type(tanks) ~= "table" then
        return nil
    end

    local filled = 0
    for _, tank in pairs(tanks) do
        if type(tank) == "table" and tonumber(tank.amount or 0) > 0 then
            filled = filled + 1
        end
    end

    return filled, #tanks
end

local function drawDevice(device, y, width)
    if y > select(2, monitor.getSize()) then
        return y
    end

    monitor.setCursorPos(1, y)

    if present(device.id) then
        monitor.setTextColor(colors.lime)
        monitor.write("[ON] ")
    else
        monitor.setTextColor(colors.red)
        monitor.write("[--] ")
    end

    monitor.setTextColor(colors.yellow)
    local name = device.name

    if #name > width - 5 then
        name = name:sub(1, math.max(1, width - 8)) .. "..."
    end

    monitor.write(name)
    y = y + 1

    if not present(device.id) then
        return y + 1
    end

    if device.kind == "energy" then
        local okE, energy = call(device.id, "getEnergy")
        local okC, capacity = call(device.id, "getEnergyCapacity")

        monitor.setCursorPos(3, y)

        if okE and okC and type(energy) == "number" and type(capacity) == "number" and capacity > 0 then
            local pct = energy / capacity * 100

            if pct >= 50 then
                monitor.setTextColor(colors.lime)
            elseif pct >= 20 then
                monitor.setTextColor(colors.yellow)
            else
                monitor.setTextColor(colors.red)
            end

            monitor.write(string.format("Energy %.1f%%  %.0f/%.0f", pct, energy, capacity))
        else
            monitor.setTextColor(colors.gray)
            monitor.write("Energy unavailable")
        end

        return y + 2
    end

    local occupied, total, size = itemCount(device.id)

    monitor.setCursorPos(3, y)
    monitor.setTextColor(colors.lightBlue)

    if occupied ~= nil then
        if size then
            monitor.write(string.format("Items: %d/%d slots", occupied, size))
        else
            monitor.write("Items: " .. occupied .. " slots")
        end
    else
        monitor.write("Inventory unavailable")
    end

    y = y + 1

    if device.kind == "fluid_inventory" then
        local filled, tanks = tankCount(device.id)

        monitor.setCursorPos(3, y)
        monitor.setTextColor(colors.cyan)

        if filled ~= nil then
            monitor.write(string.format("Fluids: %d/%d tanks", filled, tanks))
        else
            monitor.write("Fluids unavailable")
        end

        y = y + 1
    end

    return y + 1
end

while true do
    local width, height = monitor.getSize()

    monitor.setBackgroundColor(colors.black)
    monitor.clear()

    monitor.setCursorPos(1, 1)
    monitor.setTextColor(colors.cyan)
    monitor.write("STATECH INDUSTRIES")

    monitor.setCursorPos(1, 2)
    monitor.setTextColor(colors.white)
    monitor.write("FACTORY CONTROL CENTER")

    monitor.setCursorPos(1, 3)
    monitor.setTextColor(colors.gray)
    monitor.write("Read-only machine monitor")

    local y = 5

    for _, device in ipairs(devices) do
        if y > height - 1 then
            break
        end
        y = drawDevice(device, y, width)
    end

    monitor.setCursorPos(1, height)
    monitor.setTextColor(colors.gray)
    monitor.write("Update: 2s")

    sleep(2)
end
