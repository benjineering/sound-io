require 'ffi'
require 'sound_io'
require 'sound_io/error'
require 'sound_io/device'
require 'sound_io/enums'
require 'sound_io/channel_layout'

module SoundIO
  class OutStream < FFI::ManagedStruct
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
      layout_error: :error
    )

    def self.release(ptr)
      SoundIO.soundio_outstream_destroy(ptr)
    end

    def open
      error = SoundIO.soundio_outstream_open(self)
      raise Error.new('Error opening out stream', error) unless error == :none

      unless self[:layout_error] == :none
        raise Error.new('Unable to set channel layout', self[:layout_error])
      end
    end

    def start
      error = SoundIO.soundio_outstream_start(self)
      raise Error.new('Error starting out stream', error) unless error == :none
    end
  end
end
