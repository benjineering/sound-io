require 'ffi'

module SoundIO
  module Response
    class IntPointer < FFI::Struct
      layout(value: :int)

      def initialize(num)
        self[:value] = num
      end

      def value
        self[:value]
      end
    end
  end
end
