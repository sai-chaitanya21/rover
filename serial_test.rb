# Manual test script for hardware verification
ser = SerialPort.new("/dev/ttyUSB0", 115200, 8, 1, SerialPort::NONE)

# Thread to listen for Arduino feedback (Distances, Acknowledgment, Errors)
Thread.new {
  while true
    line = ser.readline
    puts "<- #{line}" if line
  end
}

puts "Manual Control Mode Started"
puts "Commands: F150 (Forward), B150 (Back), L100 (Left), R100 (Right), S (Stop)"
puts "CRITICAL: Use CAPITAL letters only!"

while buf = Readline.readline("> ", true)
  ser.write("#{buf}\n")
end "manual control"
