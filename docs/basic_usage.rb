require 'sound_io'

sio = SoundIO::Context.new
sio.connect
sio.flush_events

out = sio.output_device
puts out
