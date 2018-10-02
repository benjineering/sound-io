require 'sound_io/device'
require 'sound_io/enums'
require 'sound_io/channel_layout'
require 'ffi'

module SoundIO
  class InStream < FFI::Struct
    layout(
      device: Device.ptr,
      format: :format,
      sample_rate: :int,
      layout: ChannelLayout,
      software_latency: :double,
      userdata: :pointer,
      read_callback: callback([InStream.ptr, :int, :int], :void),
      underflow_callback: callback([InStream.ptr], :void),
      error_callback: callback([InStream.ptr, :error], :void),
      name: :string,
      non_terminal_hint: :bool,
      bytes_per_frame: :int,
      bytes_per_sample: :int,
      layout_error: :error
    )
  end
end
