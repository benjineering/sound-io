require 'sound_io'
require 'sound_io/enums'

module SoundIO
  class Error < StandardError
    attr_reader :string

    def initialize(msg, sym)
      @symbol = sym

      if sym.nil?
        super(msg)
      else
        @string = SoundIO.strerror(sym)
        super("#{msg} - #{@string}")
      end
    end

    def none?
      @symbol == :none
    end

    def to_sym
      @symbol
    end

    def ==(sym)
      to_sym == sym.to_sym
    end

    def self.no_memory
      super('Out of memory')
    end
  end
end
