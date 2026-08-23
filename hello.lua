local monitor = peripheral.find("monitor")

monitor.clear()
monitor.setTextScale(2)

monitor.setCursorPos(1, 1)
monitor.setTextColor(colors.cyan)
monitor.write("STATECH")

monitor.setCursorPos(1, 3)
monitor.setTextColor(colors.lime)
monitor.write("Factory Online!")
