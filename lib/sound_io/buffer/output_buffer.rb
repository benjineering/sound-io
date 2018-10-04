require 'sound_io/channel_area'
require 'ffi'

module SoundIO
  module Buffer
    class OutputBuffer < FFI::Struct
      attr_reader :areas, :frame_count_ptr

      def initialize(frame_count = 0)
        @areas = ChannelArea.new.to_ptr.to_ptr
        @frame_count_ptr = FFI::Pointer.new # TODO: should be memory pointer?
        frame_count = frame_count
      end

      def frame_count
        @frame_count_ptr.read_int
      end

      def frame_count=(num)
        @frame_count_ptr.write(num)
      end

      # TODO: handle sample array
      def write(samples, channel_idx, offset)
        # TODO: DRY arrays
        increment = channel_idx * ChannelArea.size
        area = ChannelArea.new(self[:areas] + increment)
        pointer = FFI::Pointer.new(area.ptr + area.step * offset)
        pointer.write(:float, samples)
      end

      # TODO: handle sample array
      def write_mono(samples, channel_count, offset)
        raise 'not yet implemented'
      end
    end
  end
end
