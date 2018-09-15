require 'sound_io/version'
require 'sound_io/device'
require 'sound_io/context'
require 'sound_io/enums'
require 'ffi'

module SoundIO
	extend FFI::Library
	ffi_lib 'soundio'
	
	# version
	attach_function :soundio_version_string, [], :string
	attach_function :soundio_version_major, [], :int
	attach_function :soundio_version_minor, [], :int
	attach_function :soundio_version_patch, [], :int

	# contexts
	attach_function :soundio_create, [], Context.ptr
	attach_function :soundio_destroy, [Context.ptr], :void
	attach_function :soundio_connect, [Context.ptr], :int

	# devices
	attach_function :soundio_device_equal, [Device.ptr, Device.ptr], :bool
end
