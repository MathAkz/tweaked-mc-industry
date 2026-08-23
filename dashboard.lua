-- Statech / CC:Tweaked Peripheral Dashboard
-- Run with: dashboard
-- This only displays what the computer can see.

local monitor = peripheral.find("monitor")
if not monitor then
    print("No monitor found.")
    return
end

monitor.setTextScale(1)
monitor.setBackgroundColor(colors.black)

local function typeText(name)
    local types = { peripheral.getType(name) }
    if #types == 0 then return "unknown" end
    return table.concat(types, ", ")
end

while true do
    local names = peripheral.getNames()
    table.sort(names)

    monitor.clear()
    monitor.setCursorPos(1, 1)
    monitor.setTextColor(colors.cyan)
    monitor.write("STATECH INDUSTRIES")

    monitor.setCursorPos(1, 2)
    monitor.setTextColor(colors.white)
    monitor.write("Peripheral Monitor")

    monitor.setCursorPos(1, 4)
    monitor.setTextColor(colors.lime)
    monitor.write("Found: " .. #names)

    local width, height = monitor.getSize()
    local y = 6

    for _, name in ipairs(names) do
        if y > height then break end

        monitor.setCursorPos(1, y)
        monitor.setTextColor(colors.yellow)
        monitor.write(name)
        y = y + 1

        if y <= height then
            monitor.setCursorPos(3, y)
            monitor.setTextColor(colors.lightGray)
            local text = typeText(name)
            local available = math.max(1, width - 2)
            if #text > available then
                text = text:sub(1, math.max(1, available - 3)) .. "..."
            end
            monitor.write(text)
            y = y + 2
        end
    end

    sleep(2)
end
