require 'sound_io/channel_area'
require 'ffi'

module SoundIO
  module Response
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
