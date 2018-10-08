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
    next if frame_count < 0
    samples = sine.next(frame_count)
    buffer << samples
  end
end

out_stream.open
out_stream.start

loop do
  sio.wait_events;
end
