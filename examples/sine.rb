require 'bundler/setup'
require 'sound_io'
require 'synthesize'

sio = SoundIO::Context.new
sio.connect
sio.flush_events

out_stream = sio.output_device.create_out_stream
sine = Synthesize.sine(440, 1).wave_table

out_stream.write_callback = lambda do |stream, frame_min, frame_max|
  stream.write(frame_max) do |buffer|
    frame_count = buffer.frame_count
    next if frame_count < 0
    samples = sine.next(frame_count)
    buffer << samples
  end
end

out_stream.error_callback = lambda do |stream, error|
  sio.wakeup
  puts error
end

out_stream.open
out_stream.start

sio.wait_events
