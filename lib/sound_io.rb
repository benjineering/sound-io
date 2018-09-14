require 'sound_io/version'
require 'sound_io/device'
require 'ffi'

module SoundIO
	extend FFI::Library
	ffi_lib 'soundio'
	
	# libsoundio version number
	attach_function :soundio_version_string, [], :string
	attach_function :soundio_version_major, [], :int
	attach_function :soundio_version_minor, [], :int
	attach_function :soundio_version_patch, [], :int

	# TODO: create the SoundIO struct 👇

	# libsoundio instance creation
	#attach_function :soundio_create, [], :pointer
end
