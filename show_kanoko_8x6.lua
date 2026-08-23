-- Kanoko for an 8x6 monitor wall at text scale 1.
local monitor = peripheral.find("monitor")
if not monitor then
    print("ERROR: No monitor found.")
    return
end

local image = paintutils.loadImage("kanoko_8x6.nfp")
if not image then
    print("ERROR: kanoko_8x6.nfp not found or invalid.")
    return
end

local w, h = monitor.getSize()
print("Monitor size: " .. w .. " x " .. h)
print("Image size: " .. #image[1] .. " x " .. #image)

monitor.setTextScale(1)
monitor.setBackgroundColor(colors.black)
monitor.clear()

local oldTerm = term.redirect(monitor)
paintutils.drawImage(image, 1, 1)
term.redirect(oldTerm)

print("Kanoko displayed.")
