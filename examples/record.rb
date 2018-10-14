require 'bundler/setup'
require 'sound_io'

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

buffer = SoundIO::RingBuffer.new

device = sio.input_device
device.sort_channel_layouts

rate = PRIORITISED_SAMPLE_RATES.find { |r| device.supports_sample_rate(r) }
fmt = PRIORITISED_FORMATS.find { |f| device.supports_format(f) }

stream = device.create_in_stream(format: fmt, sample_rate: rate)

stream.open


