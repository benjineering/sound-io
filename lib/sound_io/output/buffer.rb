require 'sound_io/output/channel_areas'

module SoundIO
  module Output
    class Buffer
      attr_reader :areas, :frame_count

      def initialize(areas, frame_count)
        @areas = areas
        @frame_count = frame_count
      end
    end
  end
end
