require 'ffi'

module SoundIO

  # opaque struct
  class RingBuffer < FFI::Struct
    layout(dummy: :pointer)
  end
end
