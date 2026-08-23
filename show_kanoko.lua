-- Kanoko display for a 3x3 CC:Tweaked monitor
local monitor = peripheral.find("monitor")

if not monitor then
    print("ERROR: No monitor found.")
    return
end

if not fs.exists("kanoko.nfp") then
    print("ERROR: kanoko.nfp not found.")
    return
end

local image = paintutils.loadImage("kanoko.nfp")
if not image then
    print("ERROR: Could not load kanoko.nfp")
    return
end

monitor.setTextScale(1)
monitor.setBackgroundColor(colors.black)
monitor.clear()

local oldTerm = term.redirect(monitor)
paintutils.drawImage(image, 1, 1)
term.redirect(oldTerm)

print("Kanoko displayed.")
