require 'sound_io/device'
require 'sound_io/enums'
require 'sound_io/channel_layout'
require 'ffi'

module SoundIO
  module Input
    class Stream < FFI::ManagedStruct
      layout(
        device: Device.ptr,
        format: SoundIO::FORMAT,
        sample_rate: :int,
        layout: ChannelLayout,
        software_latency: :double,
        userdata: :pointer,
        read_callback: callback([Stream.ptr, :int, :int], :void),
        overflow_callback: callback([Stream.ptr], :void),
        error_callback: callback([Stream.ptr, SoundIO::ERROR], :void),
        name: :string,
        non_terminal_hint: :bool,
        bytes_per_frame: :int,
        bytes_per_sample: :int,
        layout_error: SoundIO::ERROR
      )

      def self.release(ptr)
        SoundIO.instream_destroy(ptr)
      end

      def open
        error = SoundIO.instream_open(self)

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
        error = SoundIO.instream_start(self)
        unless error == :none
          raise SoundIO::Error.new('Error starting stream', error)
        end
      end

      def begin_read(requested_frame_count)
        buffer = Buffer.new(requested_frame_count, self[:layout].channel_count)

        error = SoundIO.instream_begin_read(
          self, 
          buffer.areas,
          buffer.frame_count_ptr
        )

        unless error == :none
          raise SoundIO::Error.new('Error beginning read', error)
        end

        if block_given?
          begin
            yield buffer
          rescue => ex          
            unless self[:error_callback].nil?
              self[:error_callback].call(self, ex)
            end
          end
  
          end_read
        else
          return buffer
        end
      end

      def end_read
        error = SoundIO.instream_end_read(self)

        unless error ==:none
          raise SoundIO::Error.new('Error ending read', error)
        end
      end

      def channel_layout
        self[:layout]
      end

      def bytes_per_frame
        self[:bytes_per_frame]
      end

      def read_callback=(proc)
        self[:read_callback] = proc
      end

      def overflow_callback=(proc)
        self[:overflow_callback] = proc
      end

      def error_callback=(proc)
        self[:error_callback] = -> stream, error do
          proc.call(SoundIO::Error.new('Output stream error callback', error))
        end
      end

      alias_method :read, :begin_read
    end
  end
end
