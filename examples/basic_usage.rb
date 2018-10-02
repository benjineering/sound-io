require 'bundler/setup'
require 'sound_io'
require 'synthesize'

sio = SoundIO::Context.new
sio.connect
sio.flush_events

out_dev = sio.output_device
raise 'No output device' if out_dev.nil?
out_stream = out_dev.create_out_stream

sine = Synthesize.sine(440, 1).wave_table

out_stream.write_callback = lambda do |stream, frame_min, frame_max|
  layout = stream.channel_layout
  frames_left = frame_max

  while frames_left > 0 do
    result = stream.begin_write(frames_left)
    frame_count = result.frame_count
    break if frame_count < 0

    (0...frame_count).each do |frame|
      sample = sine.next(1)

      (0...layout.channel_count).each do |channel|
        result.areas.write(sample, channel, frame)
      end
    end

    frames_left -= frame_count;
    stream.end_write
  end
end

out_stream.open
out_stream.start

loop do
  sio.wait_events;
end
