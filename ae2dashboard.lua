-- AE2 Factory Dashboard
-- Run with: ae2dashboard
--
-- This program READS the three peripherals from your screenshots.
-- It does not push/pull items or change machine settings.

local monitor = peripheral.find("monitor")
if not monitor then
    print("No monitor found.")
    return
end

local devices = {
    {
        id = "ae2:charger_0",
        name = "AE2 CHARGER",
        kind = "energy",
    },
    {
        id = "ae2:controller_0",
        name = "AE2 CONTROLLER",
        kind = "energy",
    },
    {
        id = "ae2:drive_0",
        name = "AE2 DRIVE",
        kind = "inventory",
    },
}

local function exists(id)
    return peripheral.isPresent(id)
end

local function drawEnergy(y, device)
    local okEnergy, energy = pcall(peripheral.call, device.id, "getEnergy")
    local okCapacity, capacity = pcall(peripheral.call, device.id, "getEnergyCapacity")

    monitor.setCursorPos(2, y)
    monitor.setTextColor(colors.white)

    if not okEnergy or not okCapacity or not energy or not capacity or capacity <= 0 then
        monitor.write("Energy: unavailable")
        return y + 1
    end

    local percent = (energy / capacity) * 100

    if percent >= 50 then
        monitor.setTextColor(colors.lime)
    elseif percent >= 20 then
        monitor.setTextColor(colors.yellow)
    else
        monitor.setTextColor(colors.red)
    end

    monitor.write(string.format("Energy: %.1f%%", percent))

    monitor.setCursorPos(2, y + 1)
    monitor.setTextColor(colors.lightGray)
    monitor.write(string.format("%.0f / %.0f", energy, capacity))

    return y + 2
end

local function drawInventory(y, device)
    local ok, items = pcall(peripheral.call, device.id, "list")

    monitor.setCursorPos(2, y)
    if not ok or not items then
        monitor.setTextColor(colors.red)
        monitor.write("Inventory: unavailable")
        return y + 1
    end

    local count = 0
    for _ in pairs(items) do
        count = count + 1
    end

    local okSize, size = pcall(peripheral.call, device.id, "size")

    monitor.setTextColor(colors.lightBlue)
    if okSize and size then
        monitor.write("Occupied slots: " .. count .. " / " .. size)
    else
        monitor.write("Occupied slots: " .. count)
    end

    return y + 1
end

while true do
    local _, height = monitor.getSize()

    monitor.setBackgroundColor(colors.black)
    monitor.clear()

    monitor.setCursorPos(1, 1)
    monitor.setTextColor(colors.cyan)
    monitor.write("STATECH INDUSTRIES")

    monitor.setCursorPos(1, 2)
    monitor.setTextColor(colors.white)
    monitor.write("AE2 CONTROL CENTER")

    local y = 4

    for _, device in ipairs(devices) do
        if y > height - 2 then
            break
        end

        monitor.setCursorPos(1, y)
        if exists(device.id) then
            monitor.setTextColor(colors.lime)
            monitor.write("[ONLINE] ")
        else
            monitor.setTextColor(colors.red)
            monitor.write("[OFFLINE]")
        end

        monitor.setTextColor(colors.yellow)
        monitor.write(" " .. device.name)

        y = y + 1

        if exists(device.id) then
            if device.kind == "energy" then
                y = drawEnergy(y, device)
            else
                y = drawInventory(y, device)
            end
        end

        y = y + 1
    end

    monitor.setCursorPos(1, height)
    monitor.setTextColor(colors.gray)
    monitor.write("Updates every 2 seconds")

    sleep(2)
end
