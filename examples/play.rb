require 'bundler/setup'
require 'sound_io'
require 'synthesize'

sine = Synthesize.sine(300, 0.3).wave_table
square = Synthesize.square(380, 0.2).wave_table

sio = SoundIO::Context.new
sio.connect
sio.flush_events

out_stream = sio.output_device.create_out_stream
out_stream.open

out_stream.error_callback do |error|
  sio.wakeup
  puts error
end

out_stream.start do |sample_range|
  out_stream.write(sample_range.max) do |buffer|
    buffer << [sine.next(buffer.frame_count), square.next(buffer.frame_count)]
  end
end

sio.wait_events
