require 'sound_io/enums'
require 'sound_io/sound_io'
require 'ffi'

module SoundIO
  class ChannelLayout < FFI::Struct
    layout(
      :name, :string,
      :channel_count, :int,
      :channels, [:channel_id, SoundIO::MAX_CHANNELS]
    )

    def name
      self[:name]
    end

    def channel_count
      self[:channel_count]
    end

    def channels
      self[:channels].take(self[:channel_count])
    end
  end
end
