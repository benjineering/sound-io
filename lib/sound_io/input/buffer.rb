module SoundIO
  module Input
    class ChannelAreas < FFI::Struct
      layout(areas: :pointer)

      def read(channel_idx, offset)
        # TODO: DRY arrays
        increment = channel_idx * SoundIO::ChannelArea.size
        area = SoundIO::ChannelArea.new(self[:areas] + increment)
        pointer = FFI::Pointer.new(area.ptr + area.step * offset)
        pointer.read_float
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
      
      def read(n, channel_idx, offset = 0)        
        raise Error.new('n exceeds frame_count') if n > frame_count

        return @areas.read(channel_idx, offset) if n == 1
        
        data = Array.new(n);
        n.times { |i| data << @areas.read(channel_idx, offset + i) }
        data
      end

      def read_all
        data = Array.new(@channel_count, Array.new(frame_count))

        @channel_count.times do |channel|
          frame_count.times do |offset|
            data[channel][offset] = @areas.read(channel, offset)
=begin
            if data[channel][offset] > 1.0
              data[channel][offset] = 1.0
            elsif data[channel][offset] < -1.0
              data[channel][offset] = -1.0
            end
=end
          end
        end

        return [] if data[0][0] == 0.0

        data
      end
    end
  end
end
