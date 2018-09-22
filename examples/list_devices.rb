require 'bundler/setup'
require 'sound_io'

def print_channel_layout(layout)
  if layout.name
    puts "#{layout.name}"
  else
    layout.channels.first.each { |channel| puts channel.name }
  end
end

def print_device(device, is_default)
  default_str = is_default ? ' (default)' : ''
  raw_str = device.raw? ? ' (raw)' : ''
  puts "\n#{device.name}#{default_str}#{raw_str}"
  puts "id: #{device.id}"

  unless device.probe_error.nil?
    puts "probe error: #{device.probe_error_str}"
    return
  end

  puts ' channel layouts:'
  device.layouts.each do |layout|
    print_channel_layout(layout)
  end

  unless device.current_layout.channels.empty?
    puts ' current layout'
    print_channel_layout(device.current_layout)
  end

  puts ' sample rates:'
  device.sample_rates.each do |rate|
    puts "    #{range.min} - #{range.max}"
  end

  unless device.sample_rate_current.nil?
    puts " current sample rate: #{device.sample_rate_current}"
  end

  puts ' formats:'
  puts device.formats.collect { |f| f.to_s }.join(', ')

  unless device.current_format.invalid?
    puts "  current format: #{device.current_format}"
  end

  puts "  min software latency: #{device.software_latency_min} sec"
  puts "  max software latency: #{device.software_latency_max} sec"

  unless device.software_latency_current == 0.0
    puts "  current software latency: #{device.software_latency_current} sec"
  end
end

def list_devices(sio)
  default_input_idx = sio.default_input_device_index
  default_output_idx = sio.default_output_device_index

  puts "\n--------Input Devices--------"
  sio.input_devices.each_with_index do |device, i|
    print_device(device, default_input_idx == i)
  end

  puts "\n--------Output Devices--------"
  sio.output_devices.each_with_index do |device, i|
    print_device(device, default_output_idx == i)
  end
end

sio = SoundIO::Context.new(:dummy)
sio.connect
sio.flush_events
list_devices(sio)
