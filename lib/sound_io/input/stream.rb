require 'sound_io/device'
require 'sound_io/enums'
require 'sound_io/channel_layout'
require 'ffi'

module SoundIO
  module Input
    class Stream < FFI::Struct
      layout(
        device: Device.ptr,
        format: SoundIO::FORMAT,
        sample_rate: :int,
        layout: ChannelLayout,
        software_latency: :double,
        userdata: :pointer,
        read_callback: callback([Stream.ptr, :int, :int], :void),
        underflow_callback: callback([Stream.ptr], :void),
        error_callback: callback([Stream.ptr, SoundIO::ERROR], :void),
        name: :string,
        non_terminal_hint: :bool,
        bytes_per_frame: :int,
        bytes_per_sample: :int,
        layout_error: SoundIO::ERROR
      )

      def open
        SoundIO.instream_open(self)
      end
    end
  end
end
