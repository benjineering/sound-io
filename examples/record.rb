require 'bundler/setup'
require 'sound_io'
require 'wavefile'
#require 'SVG/Graph/Line'

RECORD_SECS = 6
RATE = 44100 # PRIORITISED_SAMPLE_RATES.find { |r| device.supports_sample_rate(r) }
FORMAT = :float32le # PRIORITISED_FORMATS.find { |f| device.supports_format(f) }

sio = SoundIO::Context.new
sio.connect
sio.flush_events

device = sio.input_device
device.sort_channel_layouts

in_stream = device.create_in_stream(format: FORMAT, sample_rate: RATE)

# TODO: create wav format and outpath dynamically
wav_format = WaveFile::Format.new(:mono, :float_32, RATE)
wav_writer = WaveFile::Writer.new('/Users/ben/Desktop/record.wav', wav_format)

in_stream.read_callback = -> stream, frame_min, frame_max do
  stream.read(frame_max) do |buffer|
    frame_count = buffer.frame_count
    next if frame_count < 0
    samples = buffer.read_all

    unless samples.empty?
      wav_buffer = WaveFile::Buffer.new(samples.first, wav_format)
      wav_writer.write(wav_buffer)
    end
  end
end

in_stream.overflow_callback = -> stream { puts 'overflow!' }
in_stream.error_callback = -> stream, error { puts error }

in_stream.open
in_stream.start

secs = 0
loop do
  puts RECORD_SECS - secs
  sleep(1)
  secs += 1
  break if secs >= RECORD_SECS
end

wav_writer.close
