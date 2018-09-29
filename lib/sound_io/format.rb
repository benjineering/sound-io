require 'sound_io/enums'

module SoundIO
  class Format
    def initialize(sym)
      @sym = sym
    end

    def bytes_per_sample
      invalid? ? nil : SoundIO.soundio_get_bytes_per_sample(@sym)
    end

    def to_s
      SoundIO.soundio_format_string(@sym)
    end

    def to_sym
      @sym
    end

    def invalid?
      @sym == :invalid
    end
  end
end
