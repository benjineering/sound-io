require 'sound_io'
require 'sound_io/error'
require 'sound_io/device'
require 'sound_io/enums'
require 'sound_io/channel_layout'

require 'sound_io/output/int_pointer'
require 'sound_io/output/channel_areas'
require 'sound_io/output/buffer'

require 'ffi'

module SoundIO
  class OutStream < FFI::ManagedStruct
    layout(
      device: Device.ptr,
      format: :format,
      sample_rate: :int,
      layout: ChannelLayout,
      software_latency: :double,
      userdata: :pointer,
      write_callback: callback([OutStream.ptr, :int, :int], :void),
      underflow_callback: callback([OutStream.ptr], :void),
      error_callback: callback([OutStream.ptr, :error], :void),
      name: :string,
      non_terminal_hint: :bool,
      bytes_per_frame: :int,
      bytes_per_sample: :int,
      layout_error: :error
    )

    def self.release(ptr)
      SoundIO.outstream_destroy(ptr)
    end

    def format=(fmt)
      self[:format] = fmt.to_sym
    end

    def write_callback=(proc)
      self[:write_callback] = proc
    end

    def open
      error = SoundIO.outstream_open(self)
      raise Error.new('Error opening stream', error) unless error == :none

      unless self[:layout_error] == :none
        raise Error.new('Unable to set channel layout', self[:layout_error])
      end
    end

    def start
      error = SoundIO.outstream_start(self)
      raise Error.new('Error starting stream', error) unless error == :none
    end

    def begin_write(requested_frame_count)
      frame_count_ptr = Output::IntPointer.new(requested_frame_count)
      areas = Output::ChannelAreas.new
      error = SoundIO.outstream_begin_write(self, areas, frame_count_ptr)
      raise Error.new('Error beginning write', error) unless error == :none
      Output::Buffer.new(areas, frame_count_ptr.value)
    end

    def end_write
      error = SoundIO.outstream_end_write(self)
      raise Error.new('Error ending write', error) unless error ==:none
    end

    def channel_layout
      return self[:layout]
    end
  end
end
