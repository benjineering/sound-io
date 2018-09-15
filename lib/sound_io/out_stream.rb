require 'ffi'
require 'sound_io/device'
require 'sound_io/enums'
require 'sound_io/channel_layout'

module SoundIO
  class OutStream < FFI::Struct
    layout(
      device: Device.ptr,
      format: :format,
      sample_rate: :int,
      layout: ChannelLayout.ptr,
      software_latency: :double,
      userdata: :pointer,
      write_callback: callback([OutStream.ptr, :int, :int], :void),
      underflow_callback: callback([OutStream.ptr], :void),
      error_callback: callback([OutStream.ptr, :int], :void),
      name: :string,
      non_terminal_hint: :bool,
      bytes_per_frame: :int,
      bytes_per_sample: :int,
      layout_error: :int
    )
  end
end
