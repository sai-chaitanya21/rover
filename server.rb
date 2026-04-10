# Using the port and baud rate we verified yesterday
ser = SerialPort.new("/dev/ttyUSB0", 115200, 8, 1, SerialPort::NONE)

def run_cmd(ser, cmd)
  puts "-> #{cmd}"
  ser.write("#{cmd}\n")
end

state = :stop

puts "Rover Autonomous Mode Started..."

while true
  line = ser.gets
  # Only process lines that start with 'D' (Distance data)
  next unless line && line.start_with?('D')
  
  dist = line[1..-1].to_f
  puts "<- Distance: #{dist}cm"

  # Logic: If closer than 25cm, stop and turn. Otherwise, go forward.
  if dist < 25 && dist > 0
    if state != :turning
      run_cmd(ser, 'S') # Safety stop before changing direction
      sleep 0.2
      run_cmd(ser, 'L100') # Turn left
      state = :turning
      sleep 0.5 
    end
  elsif dist >= 25
    if state != :forward
      run_cmd(ser, 'F120') # Speed 120 helps avoid the E:V (voltage) error
      state = :forward
    end
  end
  sleep 0.1
end
