require 'sound_io'

SECONDS_OFFSET = 0

sio = SoundIO::Context.new
sio.connect
sio.flush_events

out_dev = sio.output_device
raise 'No output device' if out_dev.nil?

out_stream = out_dev.create_stream(format: :float32be)

out_stream.callback do |frames_min, frames_max|
  puts "#{frames_min} #{frames_max}"
end

# TODO: combine open and start?
out_stream.open
out_stream.start

loop do
  sio.wait_events(soundio);
end
