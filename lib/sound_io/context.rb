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
      SoundIO.soundio_create
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
  end
end
