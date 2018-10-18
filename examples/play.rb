require 'bundler/setup'
require 'sound_io'
require 'synthesize'

sio = SoundIO::Context.new
sio.connect
sio.flush_events

out_stream = sio.output_device.create_out_stream
sine = Synthesize.sine(300, 1).wave_table
square = Synthesize.square(380, 1).wave_table

out_stream.write_callback do |sample_range|
  out_stream.write(sample_range.max) do |buffer|
    buffer << [sine.next(buffer.frame_count), square.next(buffer.frame_count)]
  end
end

out_stream.error_callback do |error|
  sio.wakeup
  puts error
end

out_stream.open
out_stream.start

sio.wait_events
