require 'sound_io'
require 'sound_io/error'
require 'sound_io/device'
require 'sound_io/enums'
require 'sound_io/channel_layout'
require 'sound_io/output/buffer'
require 'ffi'

module SoundIO
  module Output
    class Stream < FFI::ManagedStruct
      layout(
        device: Device.ptr,
        format: SoundIO::FORMAT,
        sample_rate: :int,
        layout: ChannelLayout,
        software_latency: :double,
        userdata: :pointer,
        write_callback: callback([Stream.ptr, :int, :int], :void),
        underflow_callback: callback([Stream.ptr], :void),
        error_callback: callback([Stream.ptr, SoundIO::ERROR], :void),
        name: :string,
        non_terminal_hint: :bool,
        bytes_per_frame: :int,
        bytes_per_sample: :int,
        layout_error: SoundIO::ERROR
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

      def error_callback=(proc)
        self[:error_callback] = -> stream, error do
          proc.call(SoundIO::Error.new('Output stream error callback', error))
        end
      end

      def open
        error = SoundIO.outstream_open(self)

        unless error == :none
          raise SoundIO::Error.new('Error opening stream', error)
        end

        unless self[:layout_error] == :none
          raise SoundIO::Error.new(
            'Unable to set channel layout', 
            self[:layout_error]
          )
        end
      end

      def start
        error = SoundIO.outstream_start(self)
        unless error == :none
          raise SoundIO::Error.new('Error starting stream', error)
        end
      end

      def begin_write(requested_frame_count)
        buffer = Buffer.new(requested_frame_count, self[:layout].channel_count)

        error = SoundIO.outstream_begin_write(
          self, 
          buffer.areas,
          buffer.frame_count_ptr
        )

        unless error == :none
          raise SoundIO::Error.new('Error beginning write', error)
        end

        if block_given?
          begin
            yield buffer
          rescue => ex          
            unless self[:error_callback].nil?
              self[:error_callback].call(self, ex)
            end
          end
  
          end_write
        else
          return buffer
        end
      end

      def end_write
        error = SoundIO.outstream_end_write(self)

        unless error ==:none
          raise SoundIO::Error.new('Error ending write', error)
        end
      end

      def channel_layout
        return self[:layout]
      end

      alias_method :write, :begin_write
    end
  end
end
