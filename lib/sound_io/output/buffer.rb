module SoundIO
  module Output
    class ChannelAreas < FFI::Struct
      layout(areas: :pointer)

      def write(sample, channel_idx, offset)
        # TODO: DRY arrays
        increment = channel_idx * SoundIO::ChannelArea.size
        area = SoundIO::ChannelArea.new(self[:areas] + increment)
        pointer = FFI::Pointer.new(area.ptr + area.step * offset)
        pointer.write(:float, sample)
      end
    end

    private_constant :ChannelAreas

    class Buffer
      attr_reader :areas, :frame_count_ptr

      def initialize(frame_count, channel_count)
        @areas = ChannelAreas.new
        @frame_count_ptr = FFI::MemoryPointer.new(:int)
        self.frame_count = frame_count
        @channel_count = channel_count
      end

      def frame_count
        @frame_count_ptr.read_int
      end

      def frame_count=(num)
        @frame_count_ptr.write_int(num)
      end
      
      def write(samples, channel_idx, offset = 0)
        if samples.is_a?(Array)
          if samples.length > frame_count
            raise new Error('samples length exceeds frame_count')
          end

          samples.each_with_index do |s, i|
            @areas.write(s, channel_idx, offset + i)
          end
        else
          @areas.write(samples, channel_idx, offset)
        end
      end

      def write_mono(samples, offset = 0)
        if samples.is_a?(Array) && samples.length > frame_count
          raise new Error('samples length exceeds frame_count')
        end

        @channel_count.times { |i| write(samples, 0, offset) }
      end

      alias_method :<<, :write_mono
    end
  end
end
