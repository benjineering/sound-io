require 'bundler/setup'
require 'sound_io'

sio = SoundIO::Context.new
sio.connect
sio.flush_events

out_dev = sio.output_device
raise 'No output device' if out_dev.nil?

out_stream = out_dev.create_out_stream

offset_secs = 0.0

out_stream.write_callback = lambda do |stream, frame_min, frame_max|
  layout = stream.layout
  secs_per_frame = 1.0 / stream.sample_rate
  frames_left = frame_max

  while frames_left > 0
    frame_count = frames_left
    result = stream.begin_write(frame_count)
    frame_count = result.frames
    break if frame_count < 0

    pitch = 440.0
    radians_per_sec = pitch * 2.0 * MATH::PI

    (0..(frame_count - 1)).each do |frame|
      sample = Math.sin((offset_secs + frame * secs_per_frame) * radians_per_sec)

      (0..(layout.channel_count - 1)).each do |channel|
        result.write(channel, frame, sample)
      end
    end

    offset_secs = (offset_secs + secs_per_frame * frame_count) % 1.0
    stream.end_write
    frames_left -= frame_count;
  end
end

out_stream.open
out_stream.start

loop do
  sio.wait_events;
  puts '!!!!'
end
