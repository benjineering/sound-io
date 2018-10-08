require 'sound_io/channel_area'
require 'ffi'

module SoundIO
  module Buffer
    class OutputBufferBak < FFI::Struct
      attr_reader :areas, :frame_count_ptr, :channel_count

      def initialize(channel_count, frame_count = 0)
        @areas = FFI::MemoryPointer.new(:pointer, 0)
        @channel_count = channel_count
        @frame_count_ptr = FFI::MemoryPointer.new(:int)
        frame_count = frame_count
      end

      def frame_count
        @frame_count_ptr.read_int
      end

      def frame_count=(num)
        @frame_count_ptr.write_int(num)
      end

      def areas_ptr
        FFI::Pointer.new(@areas)
      end

      def write(samples, channel_idx, offset = 0)
        # TODO: DRY arrays
        increment = channel_idx * ChannelArea.size
        area = ChannelArea.new(@areas + increment)
        pointer = FFI::Pointer.new(area.ptr + area.step * offset)

        if samples.is_a?(Array)
          if samples.length > frame_count
            raise new Error('samples length exceeds frame_count')
          end

          (0...samples.length).each { |s| pointer.write_float(s) }

          #pointer.write_array_of_float(samples)
        else
          pointer.write_float(samples)
        end
      end

      def write_mono(samples, offset = 0)
        if samples.is_a?(Array) && samples.length > frame_count
          raise new Error('samples length exceeds frame_count')
        end

        (0...@channel_count).each { |c| write(samples, c, offset) }
      end

      alias_method :<<, :write_mono
    end
  end
end
