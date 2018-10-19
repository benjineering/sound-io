require 'ffi'

module SoundIO
  class ChannelAreas < FFI::Struct
    layout(areas: :pointer)
    
    def read(channel_idx, offset)
      pointer(channel_idx, offset).read_float
    end

    def write(sample, channel_idx, offset)
      pointer(channel_idx, offset).write(:float, sample)
    end

    private

    def pointer(channel_idx, offset)
      increment = channel_idx * SoundIO::ChannelArea.size
      area = SoundIO::ChannelArea.new(self[:areas] + increment)
      FFI::Pointer.new(area.ptr + area.step * offset)
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
        end
      end

      # TODO: fail earlier or return valid portion
      return [] if data[0][0] == 0.0

      data
    end
    
    def write(samples, channel_idx, offset = 0)
      if samples.is_a?(Array)
        samples.each_with_index do |s, i|
          @areas.write(s, channel_idx, offset + i)
        end
      else
        @areas.write(samples, channel_idx, offset)
      end
    end

    def write_all(samples)
      if samples.first.is_a?(Array)
        samples.each_with_index do |channel, channel_idx|
          channel.each_with_index do |sample, offset|
            write(sample, channel_idx, offset)
          end
        end
      else
        @channel_count.times { |i| write(samples, i) }
      end
    end

    alias_method :<<, :write_all
  end
end
