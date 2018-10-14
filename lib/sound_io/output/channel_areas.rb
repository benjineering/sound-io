require 'ffi'

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
  end
end
