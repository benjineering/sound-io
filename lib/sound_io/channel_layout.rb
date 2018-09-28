require 'sound_io/enums'
require 'sound_io/sound_io'
require 'ffi'

module SoundIO
  class ChannelLayout < FFI::Struct
    layout(
      :name, :string,
      :channel_count, :int,
      :channels, [:channel_id, SoundIO.max_channels]
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
