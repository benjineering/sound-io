require 'sound_io/version'
require 'sound_io/device'
require 'ffi'

module SoundIO
  extend FFI::Library
  
  # TODO:
  # A pointer to a function that takes a pointer and an integer
  # layout :function1, callback([:pointer, :int], :void)

	class SoundIo < FFI::Struct
		layout(
			userdata: :pointer,
			on_devices_change: :pointer,
			on_backend_disconnect: :pointer,
			on_events_signal: :pointer,
			current_backend: :int,
			app_name: :string,
			emit_rtprio_warning: :pointer,
			jack_info_callback: :pointer,
			jack_error_callback: :pointer
		)
	end
end
