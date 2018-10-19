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

    def self.built_ins
      SoundIO.channel_layout_builtin_count.times.collect do |i|
        SoundIO.channel_layout_get_builtin(i)
      end
    end

    def self.default(channel_count)
      SoundIO.channel_layout_get_default(channel_count)
    end

    # TODO: this........... probably doesn't work.
    def self.best_matching(preferred_layouts, available_layouts)
      SoundIO.best_matching_channel_layout(
        preferred_layouts.first,
        preferred_layouts.length,
        available_layouts.first,
        available_layouts.length
      )
    end

    def name
      self[:name]
    end

    def channel_count
      self[:channel_count]
    end

    def channels
      self[:channels].take(self[:channel_count])
    end

    def ==(other)
      SoundIO.channel_layout_equal(self, other)
    end

    def find_channel(channel_id)
      SoundIO.channel_layout_find_channel(self, channel_id)
    end

    def detect_builtin
      SoundIO.channel_layout_detect_builtin(self)
    end

    def sort_by_channels_desc(channel_count)
      SoundIO.sort_channel_layouts(self, channel_count)
    end
  end
end
