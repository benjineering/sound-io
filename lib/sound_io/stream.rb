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
      self.class::ACTION # declared in child classes
    end

    def self.type_name
      self.class::TYPE # declared in child classes
    end

    def self.release(ptr)
      SoundIO.send("#{self.class::TYPE}stream_destroy", ptr)
    end

    def format
      self[:format]
    end

    def format=(format)
      self[:format] = format.to_sym
    end

    def sample_rate
      self[:sample_rate]
    end

    def sample_rate=(rate)
      self[:sample_rate] = rate
    end

    def channel_layout
      self[:layout]
    end

    def channel_layout=(layout)
      self[:layout] = layout
    end

    def software_latency
      self[:software_latency]
    end

    def action_callback
      self[:action_callback] = -> stream, samples_min, samples_max do
        yield samples_min..samples_max
      end
    end

    def flow_callback
      self[:flow_callback] = -> { yield }
    end

    def error_callback
      self[:error_callback] = -> error do
        yield SoundIO::Error.new('Output stream error callback', error)
      end
    end

    def name
      self[:name]
    end

    def name=(name)
      self[:name] = name.gsub(':', '')
    end

    def non_terminal_hint?
      self[:non_terminal_hint]
    end

    def non_terminal_hint=(val)
      self[:non_terminal_hint] = val
    end

    def bytes_per_frame
      self[:bytes_per_frame]
    end

    def bytes_per_sample
      self[:bytes_per_sample]
    end

    def layout_error
      err =
      if self[:layout_error] == :none
        SoundIO::Error.new('', self[:layout_error])
      else
        SoundIO::Error.new('Error opening stream', self[:layout_error])
      end
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

      if block_given?
        self[:action_callback] = -> stream, samples_min, samples_max do
          yield samples_min..samples_max
        end
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

    def pause
      SoundIO.send("#{self.class::TYPE}stream_pause", self)
    end

    def get_latency
      SoundIO.send("#{self.class::TYPE}stream_get_latency", self)
    end
  end
end
