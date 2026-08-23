-- Display waifu.nfp on the 3x3 monitor.
local monitor = peripheral.find("monitor")
if not monitor then
    print("No monitor found.")
    return
end

monitor.setTextScale(1)
monitor.setBackgroundColor(colors.black)
monitor.clear()

local image = paintutils.loadImage("waifu.nfp")
if not image then
    print("Could not load waifu.nfp")
    return
end

paintutils.drawImage(image, 1, 1)
