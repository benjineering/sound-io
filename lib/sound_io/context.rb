require 'sound_io'
require 'sound_io/enums'
require 'ffi'

module SoundIO
  class Context < FFI::ManagedStruct
    layout(
      userdata: :pointer,
      on_devices_change: callback([Context.ptr], :void),
      on_backend_disconnect: callback([Context.ptr, SoundIO::ERROR], :void),
      on_events_signal: callback([Context.ptr], :void),
      current_backend: :backend,
      app_name: :string,
      emit_rtprio_warning: callback([:void], :void),
      jack_info_callback: callback([:string], :void),
      jack_error_callback: callback([:string], :void)
    )

    def self.new(*args)
      ctx = SoundIO.create
      raise Error.no_memory if ctx.nil?
      ctx
    end

    def self.release(ptr)
      SoundIO.destroy(ptr)
    end

    def on_devices_change
      self[:on_devices_change] = -> { yield }
    end

    def on_backend_disconnect
      self[:on_backend_disconnect] = -> error { yield error }
    end

    def on_events_signal
      self[:on_events_signal] = -> { yield }
    end

    def current_backend
      self[:current_backend]
    end

    def app_name
      self[:app_name]
    end

    def app_name=(name)
      self[:app_name] = name
    end

    def emit_rtprio_warning
      self[:emit_rtprio_warning] = -> { yield }
    end

    def jack_info_callback
      self[:jack_info_callback] = -> message { yield message }
    end

    def jack_error_callback
      self[:jack_error_callback] = -> message { yield message }
    end

    def connect(backend = nil)
      error =
      if backend.nil?
        SoundIO.connect(self)
      else
        SoundIO.connect_backend(self, backend)
      end

      unless error == :none
        raise Error.new('Error connecting context', error)
      end
    end

    def disconnect
      SoundIO.disconnect(self)
    end

    def backends
      SoundIO.backend_count(self).times.collect do |i|
        SoundIO.get_backend(self, i)
      end
    end

    def flush_events
      SoundIO.flush_events(self)
    end

    def wait_events
      SoundIO.wait_events(self)
    end

    def wakeup
      SoundIO.wakeup(self)
    end

    def force_device_scan
      SoundIO.force_device_scan(self)
    end

    def default_output_device_index
      SoundIO.default_output_device_index(self)
    end    

    def default_input_device_index
      SoundIO.default_input_device_index(self)
    end

    def input_devices
      count = SoundIO.input_device_count(self)
      return [] if count < 1

      count.times.collect do |i|
        dev = SoundIO.get_input_device(self, i)
        SoundIO.device_ref(dev) # unref called in Device.release
        dev
      end
    end

    def input_device(idx = nil)
      idx = SoundIO.default_input_device_index(self) if idx.nil?
      return nil if idx < 0

      dev = SoundIO.get_input_device(self, idx)
      return nil if dev.nil?

      SoundIO.device_ref(dev) # unref called in Device.release
      dev
    end

    def output_devices
      count = SoundIO.output_device_count(self)
      return [] if count < 1

      count.times.collect do |i|
        dev = SoundIO.get_output_device(self, i)
        SoundIO.device_ref(dev) # unref called in Device.release
        dev
      end
    end

    def output_device(idx = nil)
      idx = SoundIO.default_output_device_index(self) if idx.nil?
      return nil if idx < 0

      dev = SoundIO.get_output_device(self, idx)
      return nil if dev.nil?

      SoundIO.device_ref(dev) # unref called in Device.release
      dev
    end

    def create_ring_buffer(capacity)
      SoundIO.ring_buffer_create(self, capacity)
    end
  end
end
