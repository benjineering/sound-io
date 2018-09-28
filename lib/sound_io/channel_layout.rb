require 'sound_io/enums'
require 'ffi'

module SoundIO
  class ChannelLayout < FFI::Struct
    layout(
      name: :string,
      channel_count: :int,
      channels: :pointer
    )

    def name
      self[:name]
    end

    def channel_count
      self[:channel_count]
    end

    def channels
      # TODO: this properly - it's an array of enums
      [:invalid]
    end
  end
end
