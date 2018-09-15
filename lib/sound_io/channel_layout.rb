require 'ffi'
require 'sound_io/enums'

module SoundIO
  class ChannelLayout < FFI::Struct
    layout(
      name: :string,
      channel_count: :int,
      channels: :channel_id
    )
  end
end
