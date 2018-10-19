require 'sound_io'

module SoundIO
  class Channel
    attr_reader :id, :name

    def initialize(sym_or_str)
      if sym_or_str.is_a?(Symbol)
        @id = sym_or_str
        @name = SoundIO.get_channel_name(sym_or_str)
      else
        @id = SoundIO.parse_channel_id(channel_name, channel_name.length)
        @name = sym_or_str
      end
    end    
  end
end
