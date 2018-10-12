module SoundIO
  module Output
    class Buffer
      attr_reader :areas

      def initialize(frame_cnt)
        @areas = ChannelAreas.new
        @frame_count = FFI::MemoryPointer.new(:int)
        set_frame_count = frame_cnt
      end

      def set_frame_count=(num)
        @frame_count.write_int(num)
      end

      def frame_count
        @frame_count.read_int
      end

      def frame_count_ptr
        @frame_count
      end
    end

    private

    class ChannelAreas < FFI::Struct
      layout(areas: :pointer)

      def write(sample, channel_idx, offset)
        # TODO: DRY arrays
        increment = channel_idx * ChannelArea.size
        area = ChannelArea.new(self[:areas] + increment)
        pointer = FFI::Pointer.new(area.ptr + area.step * offset)
        pointer.write(:float, sample)
      end
    end
  end
end
