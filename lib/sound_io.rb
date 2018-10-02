require 'sound_io/version'
require 'sound_io/device'
require 'sound_io/context'
require 'sound_io/enums'
require 'sound_io/error'
require 'sound_io/ring_buffer'
require 'sound_io/out_stream'
require 'sound_io/in_stream'
require 'sound_io/channel_layout'
require 'sound_io/channel_area'
require 'ffi'

module SoundIO
	extend FFI::Library
	
	# TODO: reference lib better
	ffi_lib Gem.win_platform? ? File.expand_path('C:\\Users\\8enwi\\Documents\\libsoundio-1.1.0\\x86_64\\libsoundio.dll') : 'soundio'

	# kneel before the mighty FFI monolith
	
	# module
	attach_function :soundio_version_string, [], :string
	attach_function :soundio_version_major, [], :int
	attach_function :soundio_version_minor, [], :int
	attach_function :soundio_version_patch, [], :int
	attach_function :soundio_have_backend, [:backend], :bool
	attach_function :soundio_backend_name, [:backend], :string

	def self.have_backend?(backend)
		soundio_have_backend(backend)
	end

	# error
	attach_function :soundio_strerror, [:error], :string

	# context
	attach_function :soundio_create, [], Context.ptr
	attach_function :soundio_destroy, [Context.ptr], :void
	attach_function :soundio_connect, [Context.ptr], :error
	attach_function :soundio_connect_backend, [Context.ptr, :backend], :error
	attach_function :soundio_disconnect, [Context.ptr], :void
	attach_function :soundio_backend_count, [Context.ptr], :int
	attach_function :soundio_get_backend, [Context.ptr, :int], :backend
	attach_function :soundio_flush_events, [Context.ptr], :void
	attach_function :soundio_wait_events, [Context.ptr], :void
	attach_function :soundio_wakeup, [Context.ptr], :void
	attach_function :soundio_force_device_scan, [Context.ptr], :void	
	attach_function :soundio_input_device_count, [Context.ptr], :int
	attach_function :soundio_output_device_count, [Context.ptr], :int
	attach_function :soundio_get_input_device, [Context.ptr, :int], Device.ptr
	attach_function :soundio_get_output_device, [Context.ptr, :int], Device.ptr
	attach_function :soundio_default_input_device_index, [Context.ptr], :int
	attach_function :soundio_default_output_device_index, [Context.ptr], :int
	attach_function :soundio_ring_buffer_create, [Context.ptr, :int], RingBuffer.ptr

	# device
	attach_function :soundio_device_equal, [Device.ptr, Device.ptr], :bool
	attach_function :soundio_device_ref, [Device.ptr], :void
	attach_function :soundio_device_unref, [Device.ptr], :void	
	attach_function :soundio_device_sort_channel_layouts, [Device.ptr], :void
	attach_function :soundio_device_nearest_sample_rate, [Device.ptr, :int], :int
	attach_function :soundio_device_supports_format, [Device.ptr, :format], :bool
	attach_function :soundio_device_supports_layout, [Device.ptr, ChannelLayout.ptr], :bool
	attach_function :soundio_device_supports_sample_rate, [Device.ptr, :int], :bool	
	attach_function :soundio_outstream_create, [Device.ptr], OutStream.ptr
	attach_function :soundio_instream_create, [Device.ptr], InStream.ptr

	# channel layout
	attach_function :soundio_channel_layout_equal, [ChannelLayout.ptr, ChannelLayout.ptr], :bool
	attach_function :soundio_get_channel_name, [:channel_id], :string
	attach_function :soundio_parse_channel_id, [:string, :int], :channel_id
	attach_function :soundio_channel_layout_builtin_count, [:void], :int
	attach_function :soundio_channel_layout_get_builtin, [:int], ChannelLayout.ptr
	attach_function :soundio_channel_layout_get_default, [:int], ChannelLayout.ptr
	attach_function :soundio_channel_layout_find_channel, [ChannelLayout.ptr, :channel_id], :int
	attach_function :soundio_channel_layout_detect_builtin, [ChannelLayout.ptr], :bool
	attach_function :soundio_best_matching_channel_layout, [ChannelLayout.ptr, :int, ChannelLayout.ptr, :int], ChannelLayout.ptr
	attach_function :soundio_sort_channel_layouts, [ChannelLayout.ptr, :int], :void

	# format
	attach_function :soundio_get_bytes_per_sample, [:format], :int
	attach_function :soundio_format_string, [:format], :string

	# TODO: implement own C functions to call these two
	# FFI is not finding them because they're static	
	# attach_function :soundio_get_bytes_per_frame, [:format, :int], :int
	# attach_function :soundio_get_bytes_per_second, [:format, :int, :int], :int

  # outstream
	attach_function :soundio_outstream_destroy, [OutStream.ptr], :void
	attach_function :soundio_outstream_open, [OutStream.ptr], :error
	attach_function :soundio_outstream_start, [OutStream.ptr], :error
	attach_function :soundio_outstream_begin_write, [OutStream.ptr, :pointer, :pointer], :int
	attach_function :soundio_outstream_end_write, [OutStream.ptr], :int
	attach_function :soundio_outstream_clear_buffer, [OutStream.ptr], :int
	attach_function :soundio_outstream_pause, [OutStream.ptr, :bool], :int
	attach_function :soundio_outstream_get_latency, [OutStream.ptr, :pointer], :int

  # instream
	attach_function :soundio_instream_destroy, [InStream.ptr], :void
	attach_function :soundio_instream_open, [InStream.ptr], :error
	attach_function :soundio_instream_start, [InStream.ptr], :error
	attach_function :soundio_instream_begin_read, [InStream.ptr, :pointer, :pointer], :int
	attach_function :soundio_instream_end_read, [InStream.ptr], :int
	attach_function :soundio_instream_pause, [InStream.ptr, :bool], :int
	attach_function :soundio_instream_get_latency, [InStream.ptr, :pointer], :int

  # ringbuffer
	attach_function :soundio_ring_buffer_destroy, [RingBuffer.ptr], :void
	attach_function :soundio_ring_buffer_capacity, [RingBuffer.ptr], :int
	attach_function :soundio_ring_buffer_write_ptr, [RingBuffer.ptr], :pointer
	attach_function :soundio_ring_buffer_advance_write_ptr, [RingBuffer.ptr, :int], :void
	attach_function :soundio_ring_buffer_read_ptr, [RingBuffer.ptr], :pointer
	attach_function :soundio_ring_buffer_advance_read_ptr, [RingBuffer.ptr, :int], :void
	attach_function :soundio_ring_buffer_fill_count, [RingBuffer.ptr], :int
	attach_function :soundio_ring_buffer_free_count, [RingBuffer.ptr], :int
	attach_function :soundio_ring_buffer_clear, [RingBuffer.ptr], :void
end
