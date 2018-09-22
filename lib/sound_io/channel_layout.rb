require 'ffi'
require 'sound_io/enums'

module SoundIO
  class ChannelLayout < FFI::Struct
    layout(
      name: :string,
      channel_count: :int,
      channels: :channel_id
    )

    def name
      self[:name]
    end

    def channel_count
      self[:channel_count]
    end

    def channels
      self[:channels]
    end
  end
end
