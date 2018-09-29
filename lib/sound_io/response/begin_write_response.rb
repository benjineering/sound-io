require 'sound_io/response/channel_areas_pointer'

module SoundIO
  module Response
    class BeginWriteResponse
      attr_reader :areas_pointer, :frames

      def initialize(areas_pointer, frames)
        @areas_pointer = areas
        @frames = frames
      end
    end
  end
end
