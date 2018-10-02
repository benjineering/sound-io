require 'sound_io/enums'

module SoundIO
  class Format
    def initialize(sym)
      @sym = sym
    end

    def bytes_per_sample
      invalid? ? nil : SoundIO.get_bytes_per_sample(@sym)
    end

    def to_s
      SoundIO.format_string(@sym)
    end

    def to_sym
      @sym
    end

    def invalid?
      @sym == :invalid
    end
  end
end
