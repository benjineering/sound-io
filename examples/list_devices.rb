require 'bundler/setup'
require 'sound_io'

BACKEND = nil

def print_channel_layout(layout)
  if layout.name
    puts layout.name
  else
    layout.channels.first.each { |channel| puts channel.name }
  end
end

def print_device(device, is_default)
  default_str = is_default ? ' (default)' : ''
  raw_str = device.raw? ? ' (raw)' : ''
  puts "\n#{device.name}#{default_str}#{raw_str}"
  puts "  id: #{device.id}"

  unless device.probe_error.none?
    puts "probe error: #{device.probe_error_str}"
    return
  end

  puts '  channel layouts:'
  device.layouts.each do |layout|
    print '    '
    print_channel_layout(layout)
  end

  unless device.current_layout.channels.empty?
    print '  current layout: '
    print_channel_layout(device.current_layout)
  end

  puts '  sample rates:'
  device.sample_rates.each do |rate|
    puts "    #{rate.min} - #{rate.max}"
  end

  unless device.current_sample_rate.nil?
    puts "  current sample rate: #{device.current_sample_rate}"
  end

  puts '  formats: ' +  device.formats.collect { |f| f.to_s }.join(', ')

  unless device.current_format.nil?
    puts "  current format: #{device.current_format}"
  end

  printf "  min software latency: %0.8f sec\n", device.min_software_latency
  printf "  max software latency: %0.8f sec\n", device.max_software_latency

  if device.current_software_latency > 0.0
    printf "  current software latency: %0.8f sec\n", device.current_software_latency
  end
end

def list_devices(sio)
  default_input_idx = sio.default_input_device_index
  default_output_idx = sio.default_output_device_index

  puts "--------Input Devices--------"
  sio.input_devices.each_with_index do |device, i|
    print_device(device, default_input_idx == i)
  end

  puts "\n\n--------Output Devices--------"
  sio.output_devices.each_with_index do |device, i|
    print_device(device, default_output_idx == i)
  end

  device_count = sio.input_devices.length + sio.output_devices.length
  puts "\n\n"
  puts "#{device_count} devices found"
end

sio = SoundIO::Context.new
sio.connect(BACKEND)
sio.flush_events
list_devices(sio)
