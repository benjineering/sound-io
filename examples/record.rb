require 'bundler/setup'
require 'sound_io'

PRIORITISED_FORMATS = [
  :float32ne,
  :float32fe,
  :s32ne,
  :s32fe,
  :s24ne,
  :s24fe,
  :s16ne,
  :s16fe,
  :float64ne,
  :float64fe,
  :u32ne,
  :u32fe,
  :u24ne,
  :u24fe,
  :u16ne,
  :u16fe,
  :s8,
  :u8,
  :invalid,
]

PRIORITISED_SAMPLE_RATES = [
  48000,
  44100,
  96000,
  24000,
  0,
]


