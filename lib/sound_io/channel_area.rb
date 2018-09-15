require 'ffi'
require 'sound_io/enums'

module SoundIO
  class ChannelArea < FFI::Struct
    layout(
      ptr: :pointer,
      step: :int
    )
  end
end
