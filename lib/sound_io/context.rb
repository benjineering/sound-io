require 'ffi'
require 'sound_io'
require 'sound_io/enums'

module SoundIO
  class Context < FFI::ManagedStruct
    layout(
      userdata: :pointer,
      on_devices_change: callback([Context.ptr], :void),
      on_backend_disconnect: callback([Context.ptr, :int], :void),
      on_events_signal: callback([Context.ptr], :void),
      current_backend: :backend,
      app_name: :string,
      emit_rtprio_warning: callback([], :void),
      jack_info_callback: callback([:string], :void),
      jack_error_callback: callback([:string], :void)
    )

    def self.new(*args)
      ctx = SoundIO.soundio_create
      raise Error.no_memory if ctx.nil?
      ctx
    end

    def self.release(ptr)
      SoundIO.soundio_destroy(ptr)
    end

    def backend
      self[:current_backend]
    end

    def connect(backend = nil)
      error =
      if backend.nil?
        SoundIO.soundio_connect(self)
      else
        SoundIO.soundio_connect_backend(self, backend)
      end

      unless error == :none
        raise Error.new('Error connecting context', error)
      end
    end

    def disconnect
      SoundIO.soundio_disconnect(self)
    end

    def flush_events
      SoundIO.soundio_flush_events(self)
    end

    def default_output_device_index
      SoundIO.soundio_default_output_device_index(self)
    end    

    def default_input_device_index
      SoundIO.soundio_default_input_device_index(self)
    end

    def input_devices
      count = SoundIO.soundio_input_device_count(self)
      return [] if count < 1

      (0..(count - 1)).collect do |i|
        SoundIO.soundio_get_input_device(self, i)
      end
    end

    def output_devices
      count = SoundIO.soundio_output_device_count(self)
      return [] if count < 1

      (0..(count - 1)).collect do |i|
        SoundIO.soundio_get_output_device(self, i)
      end
    end

    def output_device(idx = nil)
      idx = SoundIO.soundio_default_output_device_index(self) if idx.nil?
      return nil if idx < 0

      dev = SoundIO.soundio_get_output_device(self, idx)
      return nil if dev.nil?

      SoundIO.soundio_device_ref(dev) # unref called in Device.release
      dev
    end

    def wait_events
      SoundIO.soundio_wait_events
    end
  end
end
