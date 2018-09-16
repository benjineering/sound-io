require 'sound_io'
require 'sound_io/enums'

module SoundIO
  class Error < StandardError
    attr_reader :symbol, :string

    def initialize(msg, sym = nil)
      @symbol = sym

      if sym.nil?
        super(msg)
      else
        @string = SoundIO.soundio_strerror(sym) unless sym.nil?
        super("#{msg} - #{@string}")
      end
    end
  end
end
