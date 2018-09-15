require 'ffi'
require 'sound_io/enums'

module SoundIO
  class Instance < FFI::Struct
    layout(
      userdata: :pointer,
      on_devices_change: callback([Instance.ptr], :void),
      on_backend_disconnect: callback([Instance.ptr, :int], :void),
      on_events_signal: callback([Instance.ptr], :void),
      current_backend: :backend,
      app_name: :string,
      emit_rtprio_warning: callback([], :void),
      jack_info_callback: callback([:string], :void),
      jack_error_callback: callback([:string], :void)
    )
  end
end
