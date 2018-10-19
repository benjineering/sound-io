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

stream = device.create_in_stream(format: FORMAT, sample_rate: RATE)
stream.open
channel_count = stream.channel_layout.channel_count

wav_format = WaveFile::Format.new(channel_count, WAV_FORMAT, RATE)
wav_writer = WaveFile::Writer.new(OUT_PATH, wav_format)

stream.overflow_callback { puts 'overflow!' }
stream.error_callback { |error| puts error }

stream.start do |sample_range|
  stream.read(sample_range.max) do |buffer|
    frame_count = buffer.frame_count
    next if frame_count < 0
    samples = buffer.read_all

    unless samples.empty?

      # gotta make columns rows for WaveFile
      rotated = Array.new(samples.first.length, Array.new(samples.length))

      samples.first.length.times do |sample_idx|
        rotated[sample_idx] = samples.collect { |channel| channel[sample_idx] }
      end

      wav_buffer = WaveFile::Buffer.new(rotated, wav_format)
      wav_writer.write(wav_buffer)
    end
  end
end

secs = 0
loop do
  puts RECORD_SECS - secs
  sleep(1)
  secs += 1
  break if secs >= RECORD_SECS
end

wav_writer.close
