require 'sound_io/enums'
require 'ffi'

module SoundIO
  class ChannelArea < FFI::Struct
    layout(
      ptr: :pointer,
      step: :int
    )
  end
end
