-- STATECH INDUSTRIES - Paged Factory Dashboard
-- Run: dashboard
--
-- Shows all known AE2 / MI / Extended Industrialization peripherals
-- across automatically rotating pages.
-- READ-ONLY: no item/fluid transfers or machine settings are changed.

local monitor = peripheral.find("monitor")

if not monitor then
    print("No monitor found.")
    return
end

monitor.setTextScale(1)
monitor.setBackgroundColor(colors.black)

local devices = {
    { id = "ae2:charger_0", name = "AE2 CHARGER", kind = "energy" },
    { id = "ae2:controller_0", name = "AE2 CONTROLLER", kind = "energy" },
    { id = "ae2:drive_0", name = "AE2 DRIVE", kind = "inventory" },

    { id = "modern_industrialization:laser_engraver_0", name = "LASER ENGRAVER", kind = "inventory" },
    { id = "modern_industrialization:electric_wiremill_0", name = "ELECTRIC WIREMILL", kind = "inventory" },
    { id = "modern_industrialization:electric_mixer_0", name = "ELECTRIC MIXER", kind = "inventory" },
    { id = "modern_industrialization:electric_cutting_machine_0", name = "ELECTRIC CUTTING MACHINE", kind = "fluid_inventory" },
    { id = "modern_industrialization:electric_compressor_0", name = "ELECTRIC COMPRESSOR", kind = "inventory" },
    { id = "modern_industrialization:chemical_reactor_0", name = "CHEMICAL REACTOR", kind = "fluid_inventory" },
    { id = "modern_industrialization:assembler_0", name = "ASSEMBLER", kind = "fluid_inventory" },
    { id = "modern_industrialization:polarizer_0", name = "POLARIZER", kind = "inventory" },

    { id = "extended_industrialization:electric_bending_machine_0", name = "ELECTRIC BENDING MACHINE", kind = "inventory" },
    { id = "extended_industrialization:electric_alloy_smelter_0", name = "ELECTRIC ALLOY SMELTER", kind = "inventory" },
}

local function present(id)
    return peripheral.isPresent(id)
end

local function call(id, method, ...)
    local ok, result = pcall(peripheral.call, id, method, ...)
    if ok then return true, result end
    return false, nil
end

local function itemInfo(id)
    local ok, items = call(id, "list")
    if not ok or type(items) ~= "table" then return nil end

    local occupied = 0
    for _ in pairs(items) do occupied = occupied + 1 end

    local okSize, size = call(id, "size")
    return occupied, okSize and size or nil
end

local function fluidInfo(id)
    local ok, tanks = call(id, "tanks")
    if not ok or type(tanks) ~= "table" then return nil end

    local filled = 0
    local total = 0

    for _, tank in pairs(tanks) do
        total = total + 1
        if type(tank) == "table" and tonumber(tank.amount or 0) > 0 then
            filled = filled + 1
        end
    end

    return filled, total
end

local function drawDevice(device, y, width, height)
    if y > height - 1 then return y, false end

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
    local maxName = math.max(1, width - 5)
    if #name > maxName then
        name = name:sub(1, math.max(1, maxName - 3)) .. "..."
    end
    monitor.write(name)

    y = y + 1

    if not present(device.id) then
        return y + 1, true
    end

    if device.kind == "energy" then
        local okE, energy = call(device.id, "getEnergy")
        local okC, capacity = call(device.id, "getEnergyCapacity")

        monitor.setCursorPos(3, y)

        if okE and okC and type(energy) == "number" and
           type(capacity) == "number" and capacity > 0 then

            local pct = energy / capacity * 100

            if pct >= 50 then
                monitor.setTextColor(colors.lime)
            elseif pct >= 20 then
                monitor.setTextColor(colors.yellow)
            else
                monitor.setTextColor(colors.red)
            end

            monitor.write(string.format("Energy %.1f%%", pct))
        else
            monitor.setTextColor(colors.gray)
            monitor.write("Energy unavailable")
        end

        return y + 2, true
    end

    local occupied, size = itemInfo(device.id)

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
        local filled, total = fluidInfo(device.id)

        monitor.setCursorPos(3, y)
        monitor.setTextColor(colors.cyan)

        if filled ~= nil then
            monitor.write(string.format("Fluids: %d/%d tanks", filled, total))
        else
            monitor.write("Fluids unavailable")
        end

        y = y + 1
    end

    return y + 1, true
end

local function makePages(height)
    -- Each device normally needs 3-4 lines. Reserve 5 lines for header/footer.
    local capacity = math.max(1, math.floor((height - 5) / 4))
    local pages = {}

    local page = {}
    for _, device in ipairs(devices) do
        table.insert(page, device)
        if #page >= capacity then
            table.insert(pages, page)
            page = {}
        end
    end

    if #page > 0 then table.insert(pages, page) end
    return pages
end

while true do
    local width, height = monitor.getSize()
    local pages = makePages(height)

    for pageNumber, page in ipairs(pages) do
        monitor.setBackgroundColor(colors.black)
        monitor.clear()

        monitor.setCursorPos(1, 1)
        monitor.setTextColor(colors.cyan)
        monitor.write("STATECH INDUSTRIES")

        monitor.setCursorPos(1, 2)
        monitor.setTextColor(colors.white)
        monitor.write("FACTORY CONTROL")

        monitor.setCursorPos(math.max(1, width - 9), 1)
        monitor.setTextColor(colors.gray)
        monitor.write(string.format("%d/%d", pageNumber, #pages))

        local y = 4

        for _, device in ipairs(page) do
            y = drawDevice(device, y, width, height)
        end

        monitor.setCursorPos(1, height)
        monitor.setTextColor(colors.gray)
        monitor.write("Auto page every 4s")

        sleep(4)
    end
end
