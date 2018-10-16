require 'bundler/setup'
require 'sound_io'
require 'wavefile'
#require 'SVG/Graph/Line'

RECORD_SECS = 5

PRIORITISED_FORMATS = [
  :float32le,
  :float32be,
  :s32le,
  :s32be,
  :s24le,
  :s24be,
  :s16le,
  :s16be,
  :float64le,
  :float64be,
  :u32le,
  :u32be,
  :u24le,
  :u24be,
  :u16le,
  :u16be,
  :invalid,
]

PRIORITISED_SAMPLE_RATES = [
  48000,
  44100,
  96000,
  24000,
  0,
]

sio = SoundIO::Context.new
sio.connect
sio.flush_events

device = sio.input_device
device.sort_channel_layouts

rate = PRIORITISED_SAMPLE_RATES.find { |r| device.supports_sample_rate(r) }
fmt = PRIORITISED_FORMATS.find { |f| device.supports_format(f) }
in_stream = device.create_in_stream(format: fmt, sample_rate: rate)

# TODO: create wav format and outpath dynamically
wav_format = WaveFile::Format.new(:mono, :pcm_32, rate)
wav_writer = WaveFile::Writer.new('/Users/ben/Desktop/record.wav', wav_format)

#graph = SVG::Graph::Line.new(
#  width: 1000,
#  height: 300,
#  fields: [0, 50, 100]
#)

file = File.open('/Users/ben/Desktop/record.csv', 'w')

in_stream.read_callback = -> stream, frame_min, frame_max do
  stream.read(frame_max) do |buffer|
    frame_count = buffer.frame_count
    next if frame_count < 0
    samples = buffer.read_all

    unless samples.empty?
      #graph.add_data(samples.first, 'L')
      #graph.add_data(samples.last, 'R')

      #require 'pry'; binding.pry

      samples.first.length.times do |i|
        file << samples.first[i]
        file << ','
        file << samples.last[i]
        file << "\n"
      end

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

puts wav_writer.total_duration.milliseconds.to_s + 'ms'

#File.open('/Users/ben/Desktop/record.svg', 'w') { |f| f.write(graph.burn) }
file.close
wav_writer.close
