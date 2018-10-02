require 'sound_io/enums'
require 'ffi'

module SoundIO
  class ChannelArea < FFI::Struct
    layout(
      ptr: :pointer,
      step: :int
    )

    def ptr
      self[:ptr]
    end

    def step
      self[:step]
    end
  end
end
