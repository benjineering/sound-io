module SoundIO
  module Output
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


    class Buffer
      attr_reader :areas, :frame_count_ptr

      def initialize(frame_count)
        @areas = Output::ChannelAreas.new
        @frame_count_ptr = FFI::MemoryPointer.new(:int)
        self.frame_count = frame_count
      end

      def frame_count
        @frame_count_ptr.read_int
      end

      def frame_count=(num)
        @frame_count_ptr.write_int(num)
      end
    end
  end
end
