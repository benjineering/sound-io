require 'sound_io'
require 'sound_io/error'
require 'sound_io/device'
require 'sound_io/enums'
require 'sound_io/channel_layout'
require 'sound_io/buffer'
require 'ffi'

module SoundIO
  class Stream < FFI::ManagedStruct
    STRUCT_LAYOUT = {
      device: Device.ptr,
      format: SoundIO::FORMAT,
      sample_rate: :int,
      layout: ChannelLayout,
      software_latency: :double,
      userdata: :pointer,
      action_callback: callback([Stream.ptr, :int, :int], :void),
      flow_callback: callback([Stream.ptr], :void),
      error_callback: callback([Stream.ptr, SoundIO::ERROR], :void),
      name: :string,
      non_terminal_hint: :bool,
      bytes_per_frame: :int,
      bytes_per_sample: :int,
      layout_error: SoundIO::ERROR
    }

    layout(STRUCT_LAYOUT)

    def self.action_name
      self.class::ACTION
    end

    def self.type_name
      self.class::TYPE
    end

    def self.release(ptr)
      SoundIO.send("#{self.class::TYPE}stream_destroy", ptr)
    end

    def format=(fmt)
      self[:format] = fmt.to_sym
    end

    def channel_layout
      return self[:layout]
    end

    def action_callback
      self[:action_callback] = -> stream, samples_min, samples_max do
        yield samples_min..samples_max
      end
    end

    def error_callback
      self[:error_callback] = -> error do
        yield SoundIO::Error.new('Output stream error callback', error)
      end
    end    

    def flow_callback
      self[:flow_callback] = -> { yield }
    end

    def open
      error = SoundIO.send("#{self.class::TYPE}stream_open", self)

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
      error = SoundIO.send("#{self.class::TYPE}stream_start", self)
      unless error == :none
        raise SoundIO::Error.new('Error starting stream', error)
      end
    end

    def begin_action(requested_frame_count)
      buffer = Buffer.new(requested_frame_count, self[:layout].channel_count)

      error = SoundIO.send(
        "#{self.class::TYPE}stream_begin_#{self.class::ACTION}",
        self, 
        buffer.areas,
        buffer.frame_count_ptr
      )

      unless error == :none
        raise SoundIO::Error.new("Error beginning #{self.class::ACTION}", error)
      end

      if block_given?
        begin
          yield buffer
        rescue => ex
          unless self[:error_callback].nil?
            self[:error_callback].call(self, ex)
          end
        end

        end_action
      else
        return buffer
      end
    end

    def end_action
      error = SoundIO.send(
        "#{self.class::TYPE}stream_end_#{self.class::ACTION}", 
        self
      )

      unless error ==:none
        raise SoundIO::Error.new("Error ending #{self.class::ACTION}", error)
      end
    end
  end
end
