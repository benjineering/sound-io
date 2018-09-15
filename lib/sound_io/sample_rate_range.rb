require 'ffi'

module SoundIO
  class SampleRateRange < FFI::Struct
    layout(
      min: :int,
      max: :int
    )
  end
end
