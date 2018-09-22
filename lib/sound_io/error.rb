require 'sound_io'
require 'sound_io/enums'

module SoundIO
  class Error < StandardError
    attr_reader :symbol, :string

    def initialize(msg, sym)
      @symbol = sym

      if sym.nil?
        super(msg)
      else
        @string = SoundIO.soundio_strerror(sym)
        super("#{msg} - #{@string}")
      end
    end

    def nil?
      @symbol == :none
    end

    def none?
      @symbol == :none
    end

    def self.no_memory
      super('Out of memory')
    end
  end
end
