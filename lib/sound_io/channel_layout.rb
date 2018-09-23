require 'sound_io/enums'
require 'ffi'

module SoundIO
  class ChannelLayout < FFI::Struct
    layout(
      name: :pointer,
      channel_count: :int,
      channels: :pointer
    )

    def name
      self[:name].read_string
    end

    def channel_count
      self[:channel_count]
    end

    def channels
      # TODO: this properly
      [:invalid]
    end
  end
end
