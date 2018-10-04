require 'bundler/setup'
require 'sound_io'
require 'synthesize'

sio = SoundIO::Context.new
sio.connect
sio.flush_events

device = sio.output_device
raise 'No output device' if device.nil?
out_stream = device.create_out_stream
sine = Synthesize.sine(440, 1).wave_table

out_stream.write_callback = lambda do |stream, frame_min, frame_max|  
  stream.write(frame_max) do |buffer|
    frame_count = buffer.frame_count
    break if frame_count < 0
    sample = sine.next(frame_count)
    buffer.areas << sample
  end
end

out_stream.error_callback = lambda do |error|
  error = Error.new(error) if error.is_a?(ERROR)
  puts error
end

out_stream.open
out_stream.start

loop do
  sio.wait_events;
end
