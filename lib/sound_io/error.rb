require 'sound_io'
require 'sound_io/enums'

module SoundIO
  class Error < StandardError
    attr_reader :symbol, :string

    def initialize(msg, sym)
      @symbol = sym
      @string = SoundIO.soundio_strerror(sym)
      super("#{msg} - #{@string}")
    end
  end
end
