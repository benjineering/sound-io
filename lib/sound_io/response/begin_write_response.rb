require 'sound_io/response/channel_areas'

module SoundIO
  module Response
    class BeginWriteResponse
      attr_reader :areas, :frame_count

      def initialize(areas, frame_count)
        @areas = areas
        @frame_count = frame_count
      end
    end
  end
end
