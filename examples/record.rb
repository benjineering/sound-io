require 'bundler/setup'
require 'sound_io'
require 'wavefile'

RECORD_SECS = 5
RATE = 44100
FORMAT = :float32le
WAV_FORMAT = :float_32
OUT_PATH = File.expand_path('~/Desktop/record.wav')

sio = SoundIO::Context.new
sio.connect
sio.flush_events

device = sio.input_device
device.sort_channel_layouts

in_stream = device.create_in_stream(format: FORMAT, sample_rate: RATE)
in_stream.open
channel_count = in_stream.channel_layout.channel_count

wav_format = WaveFile::Format.new(channel_count, WAV_FORMAT, RATE)
wav_writer = WaveFile::Writer.new(OUT_PATH, wav_format)

in_stream.read_callback = -> stream, frame_min, frame_max do
  stream.read(frame_max) do |buffer|
    frame_count = buffer.frame_count
    next if frame_count < 0
    samples = buffer.read_all

    unless samples.empty?

      # gotta make columns rows for WaveFile
      # maybe I should just output in this format from buffer?
      rotated = Array.new(samples.first.length, Array.new(samples.length))

      samples.first.length.times do |sample_idx|
        rotated[sample_idx] = samples.collect { |channel| channel[sample_idx] }
      end

      wav_buffer = WaveFile::Buffer.new(rotated, wav_format)
      wav_writer.write(wav_buffer)
    end
  end
end

in_stream.overflow_callback = -> stream { puts 'overflow!' }
in_stream.error_callback = -> stream, error { puts error }

in_stream.start

secs = 0
loop do
  puts RECORD_SECS - secs
  sleep(1)
  secs += 1
  break if secs >= RECORD_SECS
end

wav_writer.close
